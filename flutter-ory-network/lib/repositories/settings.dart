// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:ory_network_flutter/entities/message.dart';

import '../services/auth.dart';

class SettingsRepository {
  final AuthService service;

  SettingsRepository({required this.service});

  Future<String> createSettingsFlow() async {
    final flowId = await service.createSettingsFlow();
    return flowId;
  }

  Future<List<NodeMessage>?> submitNewPassword(
      {required String flowId, required String password}) async {
    final messages =
        await service.submitNewPassword(flowId: flowId, password: password);
    return messages;
  }
}
