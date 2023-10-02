import 'package:flutter/material.dart';
import 'package:ory_client/ory_client.dart';

class InputSubmitNode extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final UiNode node;
  final void Function(BuildContext, String, String) onChange;
  final void Function(BuildContext, UiNodeGroupEnum, String, String) onSubmit;

  const InputSubmitNode(
      {super.key,
      required this.formKey,
      required this.node,
      required this.onChange,
      required this.onSubmit});

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
                    type == UiNodeInputAttributesTypeEnum.submit &&
                        attributes.value?.value == 'false') {
                  final nodeName = attributes.name;

                  onChange(context, 'true', nodeName);
                }
                onSubmit(
                    context,
                    node.group,
                    attributes.name,
                    attributes.value!.isString
                        ? attributes.value!.asString
                        : '');
              }
            },
            child: Text(node.meta.label?.text ?? ''),
          ),
        ),
      ],
    );
  }
}
