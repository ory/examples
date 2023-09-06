// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../repositories/auth.dart';
import '../widgets/social_provider_box.dart';
import 'registration.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocProvider(
          create: (context) => LoginBloc(
              authBloc: context.read<AuthBloc>(),
              repository: RepositoryProvider.of<AuthRepository>(context))
            ..add(CreateLoginFlow()),
          child: const LoginForm()),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        // listen to email and password changes
        listenWhen: (previous, current) {
          return (previous.email.value != current.email.value &&
                  emailController.text != current.email.value) ||
              (previous.password.value != current.password.value &&
                  passwordController.text != current.password.value);
        },
        // if email or password value have changed, update text controller values
        listener: (BuildContext context, LoginState state) {
          emailController.text = state.email.value;
          passwordController.text = state.password.value;
        },
        builder: (context, state) {
          // login flow was created
          if (state.flowId != null) {
            return _buildLoginForm(context, state);
          } // otherwise, show loading or error
          else {
            return _buildLoginFlowNotCreated(context, state);
          }
        });
  }

  _buildLoginFlowNotCreated(BuildContext context, LoginState state) {
    if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
            child: Text(
          state.errorMessage!,
          style: const TextStyle(color: Colors.red),
        )),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  _buildLoginForm(BuildContext context, LoginState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SingleChildScrollView(
        // do not show scrolling indicator
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  //status bar height + padding
                  top: MediaQuery.of(context).viewPadding.top + 48),
              child: Image.asset(
                'assets/images/ory_logo.png',
                width: 70,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Text("Sign in",
                style: TextStyle(
                    fontWeight: FontWeight.w600, height: 1.5, fontSize: 18)),
            const Text(
                "Sign in with a social provider or with your email and password"),
            const SizedBox(
              height: 32,
            ),
            const Row(
              children: [
                SocialProviderBox(provider: SocialProvider.google),
                SizedBox(
                  width: 12,
                ),
                SocialProviderBox(provider: SocialProvider.github),
                SizedBox(
                  width: 12,
                ),
                SocialProviderBox(provider: SocialProvider.apple),
                SizedBox(
                  width: 12,
                ),
                SocialProviderBox(provider: SocialProvider.linkedin)
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            const Divider(
                color: Color.fromRGBO(226, 232, 240, 1), thickness: 1),
            const SizedBox(
              height: 32,
            ),

            const SizedBox(
              height: 20,
            ),

            const SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Email'),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: !state.isLoading,
                  controller: emailController,
                  onChanged: (String value) =>
                      context.read<LoginBloc>().add(ChangeEmail(value: value)),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your email',
                      errorText: state.email.errorMessage,
                      errorMaxLines: 3),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password'),
                      TextButton(
                          onPressed: null, child: Text("Forgot password?"))
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    enabled: !state.isLoading,
                    controller: passwordController,
                    onChanged: (String value) => context
                        .read<LoginBloc>()
                        .add(ChangePassword(value: value)),
                    obscureText: state.isPasswordHidden,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Enter your password',
                        // change password visibility
                        suffixIcon: GestureDetector(
                          onTap: () => context.read<LoginBloc>().add(
                              ChangePasswordVisibility(
                                  value: !state.isPasswordHidden)),
                          child: ImageIcon(
                            state.isPasswordHidden
                                ? const AssetImage('assets/icons/eye.png')
                                : const AssetImage('assets/icons/eye-off.png'),
                            size: 16,
                          ),
                        ),
                        errorText: state.password.errorMessage,
                        errorMaxLines: 3),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            // show general error message if it exists
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  maxLines: 3,
                ),
              ),
            // show loading indicator when state is in a loading mode
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator())),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                // disable button when state is loading
                onPressed: state.isLoading
                    ? null
                    : () {
                        context.read<LoginBloc>().add(LoginWithEmailAndPassword(
                            flowId: state.flowId!,
                            email: state.email.value,
                            password: state.password.value));
                      },
                child: const Text('Sign in'),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('No account?'),
                TextButton(
                    // disable button when state is loading
                    onPressed: state.isLoading
                        ? null
                        : () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationPage())),
                    child: const Text('Sign up'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
