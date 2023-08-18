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
      return Center(child: Text(state.errorMessage!));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  _buildLoginForm(BuildContext context, LoginState state) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            enabled: !state.isLoading,
            initialValue: state.email,
            onChanged: (String value) =>
                context.read<LoginBloc>().add(ChangeEmail(value: value)),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Email'),
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            enabled: !state.isLoading,
            initialValue: state.email,
            onChanged: (String value) =>
                context.read<LoginBloc>().add(ChangePassword(value: value)),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Password'),
              hintText: 'Enter your password',
            ),
          ),
          if (state.errorMessage != null)
            Text(state.errorMessage!,
                style: const TextStyle(color: Colors.red)),
          OutlinedButton(onPressed: null, child: const Text('Submit'))
        ],
      )),
    );
  }
}
