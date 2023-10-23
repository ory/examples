// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../repositories/auth.dart';
import '../widgets/helpers.dart';
import 'registration.dart';

class LoginPage extends StatelessWidget {
  final String aal;
  const LoginPage({super.key, required this.aal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocProvider(
          create: (context) => LoginBloc(
              authBloc: context.read<AuthBloc>(),
              repository: RepositoryProvider.of<AuthRepository>(context))
            ..add(CreateLoginFlow(aal: aal)),
          child: const LoginForm()),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.loginFlow != null) {
          return _buildUi(context, state);
        } else {
          return buildFlowNotCreated(context, state.message);
        }
      },
    );
  }

  _buildUi(BuildContext context, LoginState state) {
    final nodes = state.loginFlow!.ui.nodes;

    // get default nodes from all nodes
    final defaultNodes = nodes.where((node) {
      if (node.group == UiNodeGroupEnum.default_) {
        if (node.attributes.oneOf.isType(UiNodeInputAttributes)) {
          final attributes =
              node.attributes.oneOf.value as UiNodeInputAttributes;
          if (attributes.type == UiNodeInputAttributesTypeEnum.hidden) {
            return false;
          } else {
            return true;
          }
        }
      }
      return false;
    }).toList();

    // get password nodes from all nodes
    final passwordNodes =
        nodes.where((node) => node.group == UiNodeGroupEnum.password).toList();

    // get lookup secret nodes from all nodes
    final lookupSecretNodes = nodes
        .where((node) => node.group == UiNodeGroupEnum.lookupSecret)
        .toList();

    // get totp nodes from all nodes
    final totpNodes =
        nodes.where((node) => node.group == UiNodeGroupEnum.totp).toList();

    // get oidc nodes from all nodes
    final oidcNodes = nodes.where((node) {
      if (node.group == UiNodeGroupEnum.oidc) {
        if (node.attributes.oneOf.isType(UiNodeInputAttributes)) {
          final attributes =
              node.attributes.oneOf.value as UiNodeInputAttributes;
          return Platform.isAndroid
              ? !attributes.value!.asString.contains('ios')
              : attributes.value!.asString.contains('ios');
        }
      }
      return false;
    }).toList();

    return Stack(children: [
      Padding(
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
              // show header depending on auth state
              BlocSelector<AuthBloc, AuthState, bool>(
                bloc: (context).read<AuthBloc>(),
                selector: (AuthState state) =>
                    state.status == AuthStatus.aal2Requested,
                builder: (BuildContext context, bool boolState) {
                  return Text(
                      boolState ? 'Two-Factor Authentication' : 'Sign in',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          fontSize: 18));
                },
              ),

              if (oidcNodes.isNotEmpty)
                buildGroup<LoginBloc>(context, UiNodeGroupEnum.oidc, oidcNodes,
                    _onInputChange, _onInputSubmit),
              if (defaultNodes.isNotEmpty)
                buildGroup<LoginBloc>(context, UiNodeGroupEnum.default_,
                    defaultNodes, _onInputChange, _onInputSubmit),
              if (passwordNodes.isNotEmpty)
                buildGroup<LoginBloc>(context, UiNodeGroupEnum.password,
                    passwordNodes, _onInputChange, _onInputSubmit),
              if (lookupSecretNodes.isNotEmpty)
                buildGroup<LoginBloc>(context, UiNodeGroupEnum.lookupSecret,
                    lookupSecretNodes, _onInputChange, _onInputSubmit),
              if (totpNodes.isNotEmpty)
                buildGroup<LoginBloc>(context, UiNodeGroupEnum.totp, totpNodes,
                    _onInputChange, _onInputSubmit),

              const SizedBox(
                height: 32,
              ),
              if (state.loginFlow?.ui.messages != null)
                for (var message in state.loginFlow!.ui.messages!)
                  Text(
                    message.text,
                    style: TextStyle(color: getMessageColor(message.type)),
                  ),
              // show logout button if aal2 requested, otherwise sign up
              BlocSelector<AuthBloc, AuthState, bool>(
                  bloc: (context).read<AuthBloc>(),
                  selector: (AuthState state) =>
                      state.status == AuthStatus.aal2Requested,
                  builder: (BuildContext context, bool isAal2Requested) {
                    if (isAal2Requested) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Something\'s not working?'),
                          TextButton(
                              onPressed: () =>
                                  (context).read<AuthBloc>().add(LogOut()),
                              child: const Text('Logout'))
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('No account?'),
                          TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationPage())),
                              child: const Text('Sign up'))
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
      // build progress indicator when state is loading
      BlocSelector<LoginBloc, LoginState, bool>(
          bloc: (context).read<LoginBloc>(),
          selector: (LoginState state) => state.isLoading,
          builder: (BuildContext context, bool isLoading) {
            if (isLoading) {
              return const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.white30),
              );
            } else {
              return Container();
            }
          }),
      BlocSelector<LoginBloc, LoginState, bool>(
          bloc: (context).read<LoginBloc>(),
          selector: (LoginState state) => state.isLoading,
          builder: (BuildContext context, bool isLoading) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          })
    ]);
  }

  _onInputChange(BuildContext context, String value, String name) {
    context.read<LoginBloc>().add(ChangeNodeValue(value: value, name: name));
  }

  _onInputSubmit(
      BuildContext context, UiNodeGroupEnum group, String name, String value) {
    context
        .read<LoginBloc>()
        .add(UpdateLoginFlow(group: group, name: name, value: value));
  }
}
