import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../repositories/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) => LoginBloc(
              authBloc: context.read<AuthBloc>(),
              repository: RepositoryProvider.of<AuthRepository>(context))
            ..add(CreateLoginFlow()),
          child: const LoginForm()),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<LoginBloc, LoginState>(
        bloc: loginBloc,
        builder: (context, state) {
          // creating login flow is in process, show loading indicator
          if (state.flowId != null) {
            return _buildLoginForm(context, state);
          } else {
            return _buildLoginFlowNotCreated(context, state);
          }
        });
  }

  _buildLoginFlowNotCreated(BuildContext context, LoginState state) {
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

  _buildLoginForm(BuildContext context, LoginState state) {
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
                context.read<LoginBloc>().add(ChangeEmail(value: value)),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text('Email'),
                hintText: 'Enter your email',
                errorText: state.email.errorMessage),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            enabled: !state.isLoading,
            initialValue: state.email.value,
            onChanged: (String value) =>
                context.read<LoginBloc>().add(ChangePassword(value: value)),
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text('Password'),
                hintText: 'Enter your password',
                errorText: state.password.errorMessage),
          ),
          const SizedBox(
            height: 20,
          ),
          if (state.errorMessage != null)
            Text(state.errorMessage!,
                style: const TextStyle(color: Colors.red)),
          OutlinedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<LoginBloc>().add(LoginWithEmailAndPassword(
                          flowId: state.flowId!,
                          email: state.email.value,
                          password: state.password.value));
                    },
              child: const Text('Submit'))
        ],
      )),
    );
  }
}
