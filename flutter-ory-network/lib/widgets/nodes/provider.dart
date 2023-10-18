// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:ory_client/ory_client.dart';

class SocialProviderInput extends StatelessWidget {
  final UiNode node;

  const SocialProviderInput({super.key, required this.node});
  @override
  Widget build(BuildContext context) {
    final provider = node.attributes.oneOf.isType(UiNodeInputAttributes)
        ? (node.attributes.oneOf.value as UiNodeInputAttributes).value?.asString
        : null;
    final providerName = _getProviderName(provider);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Image.asset('assets/images/$providerName.png'),
        label: Text(node.meta.label?.text ?? ''),
        onPressed: () {
          //TODO
        },
      ),
    );
  }

  _getProviderName(String? value) {
    if (value == null) {
      return '';
    } else if (value.contains('google')) {
      return 'google';
    } else if (value.contains('apple')) {
      return 'apple';
    } else {
      return '';
    }
  }
}
