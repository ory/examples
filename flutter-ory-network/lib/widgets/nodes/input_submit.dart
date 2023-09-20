import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';

import '../../blocs/settings/settings_bloc.dart';

class InputSubmitNode extends StatelessWidget {
  final String flowId;
  final GlobalKey<FormState> formKey;
  final UiNode node;

  const InputSubmitNode(
      {super.key,
      required this.node,
      required this.formKey,
      required this.flowId});

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
                context
                    .read<SettingsBloc>()
                    .add(SubmitNewSettings(flowId: flowId, group: node.group));
              }
            },
            child: Text(node.meta.label?.text ?? ''),
          ),
        ),
      ],
    );
  }
}
