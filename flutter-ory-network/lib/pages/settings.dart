// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';
import 'package:ory_network_flutter/repositories/settings.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../repositories/auth.dart';
import '../widgets/nodes/image.dart';
import '../widgets/nodes/input_submit.dart';
import '../widgets/nodes/input.dart';
import '../widgets/nodes/text.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = RepositoryProvider.of<AuthRepository>(context).service;
    return Scaffold(
      appBar: AppBar(
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
          )),
      body: BlocProvider(
          create: (context) => SettingsBloc(
              authBloc: context.read<AuthBloc>(),
              repository: SettingsRepository(service: service))
            ..add(CreateSettingsFlow()),
          child: const SettingsForm()),
    );
  }
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    return MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: settingsBloc,
            listenWhen: (SettingsState previous, SettingsState current) =>
                previous.isSessionRefreshRequired !=
                current.isSessionRefreshRequired,
            listener: (BuildContext context, SettingsState state) async {
              // if session needs to be refreshed, navigate to login flow screen
              if (state.isSessionRefreshRequired) {
                await Navigator.push(
                    context,
                    MaterialPageRoute<bool?>(
                        builder: (context) => const LoginPage(
                              isSessionRefresh: true,
                            ))).then((value) {
                  // retry updating settings when session was refreshed
                  if (value != null) {
                    if (value && state.settingsFlow?.id != null) {
                      settingsBloc.retry();
                    }
                  } else {
                    // if user goes back without finishing login,
                    // reset button values to prevent submitting values that
                    // were selected prior to session refresh navigation
                    settingsBloc.add(ResetButtonValues());
                  }
                });
              }
            },
          ),
          // listen to message changes and display them as a snackbar
          BlocListener(
              bloc: settingsBloc,
              listenWhen: (SettingsState previous, SettingsState current) =>
                  // listen to changes only when previous
                  // state was loading (e.g. updating settings),
                  // current state is not loading and session refresh is not required
                  previous.isLoading != current.isLoading &&
                  !current.isLoading &&
                  !current.isSessionRefreshRequired,
              listener: (BuildContext context, SettingsState state) {
                if (state.settingsFlow!.ui.messages != null) {
                  // for simplicity, we will only show the first message in snackbar
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: _getMessageColor(
                        state.settingsFlow!.ui.messages!.first.type),
                    content: Text(state.settingsFlow!.ui.messages!.first.text),
                  ));
                }
              }),

          // when there is a general message,
          // jump to the page start in order to show the message
          BlocListener(
              bloc: settingsBloc,
              listener: (BuildContext context, SettingsState state) {
                if (state.message != null) {
                  // for simplicity,
                  // we will only show the first message in snackbar
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.message!.text),
                  ));
                }
              })
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
          builder: (context, state) {
            // settings flow was created
            if (state.settingsFlow != null) {
              return _buildUi(context, state);
            } // otherwise, show loading or error
            else {
              return _buildSettingsFlowNotCreated(context, state);
            }
          },
        ));
  }

  _getMessageColor(UiTextTypeEnum type) {
    switch (type) {
      case UiTextTypeEnum.success:
        return Colors.green;
      case UiTextTypeEnum.error:
        return Colors.red;
      case UiTextTypeEnum.info:
        return Colors.grey;
    }
  }

  _buildSettingsFlowNotCreated(BuildContext context, SettingsState state) {
    if (state.message != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(child: Text(state.message!.text)),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  _buildUi(BuildContext context, SettingsState state) {
    final nodes = state.settingsFlow!.ui.nodes;

    // get profile nodes from all nodes
    final profileNodes =
        nodes.where((node) => node.group == UiNodeGroupEnum.profile).toList();

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

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 32,
              ),
              _buildGroup(context, UiNodeGroupEnum.profile, profileNodes),
              _buildGroup(context, UiNodeGroupEnum.password, passwordNodes),
              _buildGroup(
                  context, UiNodeGroupEnum.lookupSecret, lookupSecretNodes),
              _buildGroup(context, UiNodeGroupEnum.totp, totpNodes),
            ],
          ),
        ),
      ),
      // build progress indicator when state is loading
      BlocSelector<SettingsBloc, SettingsState, bool>(
          bloc: (context).read<SettingsBloc>(),
          selector: (SettingsState state) => state.isLoading,
          builder: (BuildContext context, bool booleanState) {
            if (booleanState) {
              return const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.white30),
              );
            } else {
              return Container();
            }
          }),
      BlocSelector<SettingsBloc, SettingsState, bool>(
          bloc: (context).read<SettingsBloc>(),
          selector: (SettingsState state) => state.isLoading,
          builder: (BuildContext context, bool booleanState) {
            if (booleanState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          })
    ]);
  }

  // get group heading
  _buildGroupHeadingText(UiNodeGroupEnum group) {
    switch (group) {
      case UiNodeGroupEnum.lookupSecret:
        return 'Backup Recovery Codes';
      case UiNodeGroupEnum.password:
        return 'Change Password';
      case UiNodeGroupEnum.profile:
        return 'Profile Settings';
      case UiNodeGroupEnum.totp:
        return '2FA Authenticator';
      default:
        return 'Settings';
    }
  }

  _buildGroup(BuildContext context, UiNodeGroupEnum group, List<UiNode> nodes) {
    final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_buildGroupHeadingText(group),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, height: 1.5, fontSize: 18)),
            const SizedBox(
              height: 30,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ((BuildContext context, index) {
                  final attributes = nodes[index].attributes.oneOf;
                  if (attributes.isType(UiNodeInputAttributes)) {
                    return _buildInputNode(context, formKey, nodes[index]);
                  } else if (attributes.isType(UiNodeTextAttributes)) {
                    return TextNode(node: nodes[index]);
                  } else if (attributes.isType(UiNodeImageAttributes)) {
                    return ImageNode(node: nodes[index]);
                  } else {
                    return Container();
                  }
                }),
                itemCount: nodes.length),
          ],
        ),
      ),
    );
  }

  _buildInputNode(
      BuildContext context, GlobalKey<FormState> formKey, UiNode node) {
    final inputNode = node.attributes.oneOf.value as UiNodeInputAttributes;
    switch (inputNode.type) {
      case UiNodeInputAttributesTypeEnum.submit:
        return InputSubmitNode(node: node, formKey: formKey);
      case UiNodeInputAttributesTypeEnum.button:
        return InputSubmitNode(node: node, formKey: formKey);
      case UiNodeInputAttributesTypeEnum.hidden:
        return Container();

      default:
        return InputNode(node: node);
    }
  }
}
