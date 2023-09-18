import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';

import '../blocs/settings/settings_bloc.dart';

class InputField extends StatefulWidget {
  final UiNode node;

  const InputField({super.key, required this.node});
  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final fieldValue =
        (widget.node.attributes.oneOf.value as UiNodeInputAttributes).value;
    textEditingController.text = fieldValue != null ? fieldValue.asString : '';
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

  @override
  Widget build(BuildContext context) {
    final attributes =
        widget.node.attributes.oneOf.value as UiNodeInputAttributes;

    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) =>
          previous.settingsFlow != current.settingsFlow,
      listener: (context, state) {
        final node = state.settingsFlow?.ui.nodes.firstWhereOrNull((p0) =>
            (p0.attributes.oneOf.value as UiNodeInputAttributes).name ==
            attributes.name);
        textEditingController.text =
            (node?.attributes.oneOf.value as UiNodeInputAttributes)
                    .value
                    ?.asString ??
                '';
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.node.meta.label?.text != null)
            Text(
              widget.node.meta.label!.text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          const SizedBox(
            height: 4,
          ),
          TextFormField(
            controller: textEditingController,
            enabled: !attributes.disabled,
            onChanged: (value) => context
                .read<SettingsBloc>()
                .add(ChangeNodeValue(value: value, name: attributes.name)),
            validator: (value) {
              if (attributes.required_ != null) {
                if (attributes.required_! && (value == null || value.isEmpty)) {
                  return 'Property is required';
                }
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          for (var message in widget.node.messages)
            Text(message.text,
                style: TextStyle(color: _getMessageColor(message.type))),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
