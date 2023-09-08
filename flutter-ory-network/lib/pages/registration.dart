// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_network_flutter/widgets/social_provider_box.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/registration/registration_bloc.dart';
import '../repositories/auth.dart';
import 'login.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) => RegistrationBloc(
              authBloc: context.read<AuthBloc>(),
              repository: RepositoryProvider.of<AuthRepository>(context))
            ..add(CreateRegistrationFlow()),
          child: const RegistrationForm()),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<StatefulWidget> createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    return BlocConsumer<RegistrationBloc, RegistrationState>(
        bloc: registrationBloc,
        // listen to email and password changes
        listenWhen: (previous, current) {
          return (previous.email.value != current.email.value &&
                  emailController.text != current.email.value) ||
              (previous.password.value != current.password.value &&
                  passwordController.text != current.password.value);
        },
        // if email or password value have changed, update text controller values
        listener: (BuildContext context, RegistrationState state) {
          emailController.text = state.email.value;
          passwordController.text = state.password.value;
        },
        builder: (context, state) {
          // registration flow was created
          if (state.flowId != null) {
            return _buildRegistrationForm(context, state);
          } // otherwise, show loading or error
          else {
            return _buildRegistrationFlowNotCreated(context, state);
          }
        });
  }

  _buildRegistrationFlowNotCreated(
      BuildContext context, RegistrationState state) {
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

  _buildRegistrationForm(BuildContext context, RegistrationState state) {
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
            const Text('Sign up',
                style: TextStyle(
                    fontWeight: FontWeight.w600, height: 1.5, fontSize: 18)),
            const Text('Sign up with a social provider or with your email'),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Email',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: !state.isLoading,
                  controller: emailController,
                  onChanged: (String value) => context
                      .read<RegistrationBloc>()
                      .add(ChangeEmail(value: value)),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Password',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: !state.isLoading,
                  controller: passwordController,
                  onChanged: (String value) => context
                      .read<RegistrationBloc>()
                      .add(ChangePassword(value: value)),
                  obscureText: state.isPasswordHidden,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter a password',
                      // change password visibility
                      suffixIcon: GestureDetector(
                        onTap: () => context.read<RegistrationBloc>().add(
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
                          context.read<RegistrationBloc>().add(
                              RegisterWithEmailAndPassword(
                                  flowId: state.flowId!,
                                  email: state.email.value,
                                  password: state.password.value));
                        },
                  child: const Text('Sign up')),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Already have an account?'),
                TextButton(
                    // disable button when state is loading
                    onPressed: state.isLoading
                        ? null
                        : () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
                    child: const Text('Sign in'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
