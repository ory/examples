// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialProviderBox extends StatelessWidget {
  final SocialProvider provider;

  const SocialProviderBox({super.key, required this.provider});

  Future<void> handlePress() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      var x = await _googleSignIn.signIn();
      await x?.authentication.then((value) => print(value.idToken));
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.6,
        child: IconButton(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          onPressed: handlePress,
          // decoration: BoxDecoration(
          //     border: Border.all(width: 1, color: const Color(0xFFE2E8F0))),
          icon: // get icon from assets depending on provider
              Image.asset(
                  'assets/images/flows-auth-buttons-social-${provider.name}.png'),
        ),
      ),
    );
  }
}

enum SocialProvider { google, github, apple, linkedin }
