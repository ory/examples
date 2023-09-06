// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_network_flutter/entities/message.dart';
import 'package:ory_network_flutter/repositories/settings.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../repositories/auth.dart';

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
    return BlocConsumer<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        // listen to password changes
        listenWhen: (previous, current) {
          return previous.password.value != current.password.value &&
              passwordController.text != current.password.value;
        },
        // if password value has changed, update text controller value
        listener: (BuildContext context, SettingsState state) {
          passwordController.text = state.password.value;
        },
        builder: (context, state) {
          // settings flow was created
          if (state.flowId != null) {
            return _buildSettingsForm(context, state);
          } // otherwise, show loading or error
          else {
            return _buildSettingsFlowNotCreated(context, state);
          }
        });
  }

  _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.info:
        return Colors.grey;
    }
  }

  _buildSettingsFlowNotCreated(BuildContext context, SettingsState state) {
    if (state.message != null) {
      return Center(
          child: Text(
        state.message!.text,
        style: TextStyle(color: _getMessageColor(state.message!.type)),
      ));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  _buildSettingsForm(BuildContext context, SettingsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 32,
            ),
            const Text('Set a new password',
                style: TextStyle(
                    fontWeight: FontWeight.w600, height: 1.5, fontSize: 18)),
            const Text(
                'The key aspects of a strong password are length, varying characters, no ties to your personal information and no dictionary words.'),
            const SizedBox(
              height: 32,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New password'),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: !state.isLoading,
                  controller: passwordController,
                  onChanged: (String value) => context
                      .read<SettingsBloc>()
                      .add(ChangePassword(value: value)),
                  obscureText: state.isPasswordHidden,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter a password',
                      // change password visibility
                      suffixIcon: GestureDetector(
                        onTap: () => context.read<SettingsBloc>().add(
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
            if (state.message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  state.message!.text,
                  style:
                      TextStyle(color: _getMessageColor(state.message!.type)),
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
                        context.read<SettingsBloc>().add(SubmitNewPassword(
                            flowId: state.flowId!,
                            value: state.password.value));
                      },
                child: const Text('Submit'),
              ),
            ),
          ]),
    );
  }
}
