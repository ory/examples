import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ory_client/ory_client.dart';

import '../../blocs/settings/settings_bloc.dart';

class InputNode extends StatefulWidget {
  final UiNode node;

  const InputNode({super.key, required this.node});
  @override
  State<StatefulWidget> createState() => _InputNodeState();
}

class _InputNodeState extends State<InputNode> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ssign node value to text controller on init
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

// get text input type of a specific node
  _getTextInputType(UiNodeInputAttributesTypeEnum type) {
    switch (type) {
      case UiNodeInputAttributesTypeEnum.datetimeLocal:
        return TextInputType.datetime;
      case UiNodeInputAttributesTypeEnum.email:
        return TextInputType.emailAddress;
      case UiNodeInputAttributesTypeEnum.hidden:
        return TextInputType.none;
      case UiNodeInputAttributesTypeEnum.number:
        return TextInputType.number;
      case UiNodeInputAttributesTypeEnum.password:
        return TextInputType.text;
      case UiNodeInputAttributesTypeEnum.tel:
        return TextInputType.phone;
      case UiNodeInputAttributesTypeEnum.text:
        return TextInputType.text;
      case UiNodeInputAttributesTypeEnum.url:
        return TextInputType.url;
      default:
        return null;
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
        // find current node in updated state
        final node = state.settingsFlow?.ui.nodes.firstWhereOrNull((element) {
          if (element.attributes.oneOf.isType(UiNodeInputAttributes)) {
            return (element.attributes.oneOf.value as UiNodeInputAttributes)
                    .name ==
                attributes.name;
          } else {
            return false;
          }
        });
        // assign new value of node to text controller
        textEditingController.text =
            (node?.attributes.oneOf.value as UiNodeInputAttributes)
                    .value
                    ?.asString ??
                '';
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
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
              keyboardType: _getTextInputType(attributes.type),
              onChanged: (value) => context
                  .read<SettingsBloc>()
                  .add(ChangeNodeValue(value: value, name: attributes.name)),
              validator: (value) {
                if (attributes.required_ != null) {
                  if (attributes.required_! &&
                      (value == null || value.isEmpty)) {
                    return 'Property is required';
                  }
                }
                return null;
              },
            ),
            for (var message in widget.node.messages)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(message.text,
                    style: TextStyle(color: _getMessageColor(message.type))),
              ),
          ],
        ),
      ),
    );
  }
}
