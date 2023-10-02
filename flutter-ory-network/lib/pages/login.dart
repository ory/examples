// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';
import 'package:ory_network_flutter/widgets/nodes/provider.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../repositories/auth.dart';
import '../widgets/helpers.dart';
import 'registration.dart';

class LoginPage extends StatelessWidget {
  final bool isSessionRefresh;
  final String aal;

  const LoginPage(
      {super.key, this.isSessionRefresh = false, required this.aal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: !isSessionRefresh,
      appBar: isSessionRefresh
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 72,
              toolbarHeight: 72,
              // use row to avoid force resizing of leading widget
              leading: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32, top: 32),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                width: 1, color: const Color(0xFFE2E8F0))),
                        child: const Icon(Icons.arrow_back, size: 16),
                      ),
                    ),
                  ),
                ],
              ))
          : null,
      body: BlocProvider(
          create: (context) => LoginBloc(
              authBloc: context.read<AuthBloc>(),
              repository: RepositoryProvider.of<AuthRepository>(context))
            ..add(CreateLoginFlow(aal: aal, refresh: true)),
          child: LoginForm(isSessionRefresh: isSessionRefresh)),
    );
  }
}

class LoginForm extends StatelessWidget {
  final bool isSessionRefresh;

  const LoginForm({super.key, this.isSessionRefresh = false});

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
    final defaultNodes =
        nodes.where((node) => node.group == UiNodeGroupEnum.default_).toList();

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
    final oidcNodes =
        nodes.where((node) => node.group == UiNodeGroupEnum.oidc).toList();

    return BlocListener<AuthBloc, AuthState>(
      bloc: (context).read<AuthBloc>(),
      // listen when the user was already authenticated and session was updated
      listenWhen: (previous, current) =>
          previous.session != null &&
          current.session != null &&
          previous.session != current.session,
      listener: (context, state) {
        // pop with true to trigger change password flow
        Navigator.of(context).pop(true);
      },
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            // do not show scrolling indicator
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSessionRefresh)
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
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 32),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: oidcNodes
                            .map((node) => SocialProviderInput(node: node))
                            .toList()),
                  ),
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
                  buildGroup<LoginBloc>(context, UiNodeGroupEnum.totp,
                      totpNodes, _onInputChange, _onInputSubmit),
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
                    builder: (BuildContext context, bool booleanState) {
                      if (booleanState) {
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
            builder: (BuildContext context, bool booleanState) {
              if (booleanState) {
                return const Opacity(
                  opacity: 0.8,
                  child:
                      ModalBarrier(dismissible: false, color: Colors.white30),
                );
              } else {
                return Container();
              }
            }),
        BlocSelector<LoginBloc, LoginState, bool>(
            bloc: (context).read<LoginBloc>(),
            selector: (LoginState state) => state.isLoading,
            builder: (BuildContext context, bool booleanState) {
              if (booleanState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            })
      ]),
    );
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
