// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';

class SocialProviderBox extends StatelessWidget {
  final SocialProvider provider;

  const SocialProviderBox({super.key, required this.provider});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xFFE2E8F0))),
          child: // get icon from assets depending on provider
              Image.asset(
                  'assets/images/flows-auth-buttons-social-${provider.name}.png'),
        ),
      ),
    );
  }
}

enum SocialProvider { google, github, apple, linkedin }
