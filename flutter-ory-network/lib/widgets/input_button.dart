import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';

import '../blocs/settings/settings_bloc.dart';

class InputButton extends StatefulWidget {
  final String flowId;
  final GlobalKey<FormState> formKey;
  final UiNode node;

  const InputButton(
      {super.key,
      required this.node,
      required this.formKey,
      required this.flowId});
  @override
  State<StatefulWidget> createState() => _InputButtonState();
}

class _InputButtonState extends State<InputButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            // validate input fields that belong to this buttons group
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                context.read<SettingsBloc>().add(SubmitNewSettings(
                    flowId: widget.flowId, group: widget.node.group));
              }
            },
            child: Text(widget.node.meta.label?.text ?? ''),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
