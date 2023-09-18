// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';
import 'package:ory_network_flutter/repositories/settings.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../repositories/auth.dart';
import '../widgets/input_button.dart';
import '../widgets/input_field.dart';
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

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    return MultiBlocListener(
        listeners: [
          // if session needs to be refreshed, navigate to login flow screen
          BlocListener(
            bloc: settingsBloc,
            listener: (BuildContext context, SettingsState state) async {
              if (state.isSessionRefreshRequired) {
                await Navigator.push(
                    context,
                    MaterialPageRoute<bool?>(
                        builder: (context) => const LoginPage(
                              isSessionRefresh: true,
                            ))).then((value) {
                  if (value != null) {
                    // if (value && state.flowId != null) {
                    //   settingsBloc.add(SubmitNewPassword(
                    //       flowId: state.flowId!, value: state.password.value));
                    // }
                  }
                });
              }
            },
          ),
          // listens to message changes and displays them as a snackbar
          BlocListener(
              bloc: settingsBloc,
              listenWhen: (SettingsState previous, SettingsState current) =>
                  previous.isLoading != current.isLoading && !current.isLoading,
              listener: (BuildContext context, SettingsState state) {
                if (state.settingsFlow!.ui.messages != null) {
                  // for simplicity, we will only show the first message in snackbar
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.settingsFlow!.ui.messages!.first.text),
                  ));
                }
              }),
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
    final profileNodes =
        nodes.where((node) => node.group == UiNodeGroupEnum.profile).toList();
    final passwordNodes =
        nodes.where((node) => node.group == UiNodeGroupEnum.password).toList();
    final lookupSecretNodes = nodes
        .where((node) => node.group == UiNodeGroupEnum.lookupSecret)
        .toList();
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
              _buildGroup(context, state.settingsFlow!.id, profileNodes),
              _buildGroup(context, state.settingsFlow!.id, passwordNodes),
              _buildGroup(context, state.settingsFlow!.id, lookupSecretNodes),
              _buildGroup(context, state.settingsFlow!.id, totpNodes),
            ],
          ),
        ),
      ),
      if (state.isLoading)
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.white30),
        ),
      if (state.isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
    ]);
  }

  _buildTextNode(BuildContext context, UiNode node) {
    final attributes = node.attributes.oneOf.value as UiNodeTextAttributes;
    return Text(attributes.text.text);
  }

  _buildGroup(BuildContext context, String flowId, List<UiNode> nodes) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: ((BuildContext context, index) {
                final attributes = nodes[index].attributes.oneOf;
                if (attributes.isType(UiNodeInputAttributes)) {
                  return _buildInputNode(
                      context, flowId, formKey, nodes[index]);
                } else if (attributes.isType(UiNodeTextAttributes)) {
                  return _buildTextNode(context, nodes[index]);
                } else if (attributes.isType(UiNodeImageAttributes)) {
                  return _buildImageNode(
                      context, flowId, formKey, nodes[index]);
                } else {
                  return Container();
                }
              }),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                    height: 20,
                  ),
              itemCount: nodes.length),
        ],
      ),
    );
  }

  _buildInputNode(BuildContext context, String flowId,
      GlobalKey<FormState> formKey, UiNode node) {
    final inputNode = node.attributes.oneOf.value as UiNodeInputAttributes;
    switch (inputNode.type) {
      case UiNodeInputAttributesTypeEnum.submit:
        return InputButton(flowId: flowId, node: node, formKey: formKey);
      case UiNodeInputAttributesTypeEnum.button:
        return InputButton(flowId: flowId, node: node, formKey: formKey);
      case UiNodeInputAttributesTypeEnum.hidden:
        return Container();

      default:
        return InputField(node: node);
    }
  }

  _buildImageNode(BuildContext context, String flowId,
      GlobalKey<FormState> formKey, UiNode node) {
    final imageNode = node.attributes.oneOf.value as UiNodeImageAttributes;
    Uint8List bytes = base64.decode(imageNode.src.split(',').last);
    return Center(
      child: SizedBox(
          width: imageNode.width.toDouble(),
          height: imageNode.height.toDouble(),
          child: Image.memory(bytes)),
    );
  }
}
