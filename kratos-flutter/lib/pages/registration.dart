import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          child: const LoginForm()),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        bloc: registrationBloc,
        builder: (context, state) {
          // creating registration flow is in process, show loading indicator
          if (state.flowId != null) {
            return _buildRegistrationForm(context, state);
          } else {
            return _buildRegistrationFlowNotCreated(context, state);
          }
        });
  }

  _buildRegistrationFlowNotCreated(
      BuildContext context, RegistrationState state) {
    if (state.errorMessage != null) {
      return Center(
          child: Text(
        state.errorMessage!,
        style: const TextStyle(color: Colors.red),
      ));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  _buildRegistrationForm(BuildContext context, RegistrationState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            enabled: !state.isLoading,
            initialValue: state.email.value,
            onChanged: (String value) =>
                context.read<RegistrationBloc>().add(ChangeEmail(value: value)),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text('Email'),
                hintText: 'Enter your email',
                errorText: state.email.errorMessage,
                errorMaxLines: 3),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            enabled: !state.isLoading,
            initialValue: state.email.value,
            onChanged: (String value) => context
                .read<RegistrationBloc>()
                .add(ChangePassword(value: value)),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text('Password'),
                hintText: 'Enter your password',
                errorText: state.password.errorMessage,
                errorMaxLines: 3),
          ),
          const SizedBox(
            height: 20,
          ),
          if (state.errorMessage != null)
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          if (state.isLoading) const CircularProgressIndicator(),
          OutlinedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<RegistrationBloc>().add(
                          RegisterWithEmailAndPassword(
                              flowId: state.flowId!,
                              email: state.email.value,
                              password: state.password.value));
                    },
              child: const Text('Submit')),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?'),
              TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage())),
                  child: Text('Log in'))
            ],
          )
        ],
      )),
    );
  }
}
