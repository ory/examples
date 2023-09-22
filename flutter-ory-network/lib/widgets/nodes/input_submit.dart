// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';

import '../../blocs/settings/settings_bloc.dart';

class InputSubmitNode extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final UiNode node;

  const InputSubmitNode({super.key, required this.formKey, required this.node});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            // validate input fields that belong to this buttons group
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final attributes =
                    node.attributes.oneOf.value as UiNodeInputAttributes;
                final type = attributes.type;
                // if attribute type is a button, set its value to true on submit
                if (type == UiNodeInputAttributesTypeEnum.button ||
                    type == UiNodeInputAttributesTypeEnum.submit) {
                  final nodeName = attributes.name;

                  context
                      .read<SettingsBloc>()
                      .add(ChangeNodeValue(value: 'true', name: nodeName));
                }

                context
                    .read<SettingsBloc>()
                    .add(UpdateSettingsFlow(group: node.group));
              }
            },
            child: Text(node.meta.label?.text ?? ''),
          ),
        ),
      ],
    );
  }
}
