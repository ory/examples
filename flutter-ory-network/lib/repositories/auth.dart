// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:ory_client/ory_client.dart';

import '../services/auth.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated }

class AuthRepository {
  final AuthService service;

  AuthRepository({required this.service});

  Future<void> deleteExpiredSessionToken() async {
    await service.deleteExpiredSessionToken();
  }

  Future<Session> getCurrentSessionInformation() async {
    final session = await service.getCurrentSessionInformation();
    return session;
  }

  Future<String> createLoginFlow() async {
    final flowId = await service.createLoginFlow();
    return flowId;
  }

  Future<String> createRegistrationFlow() async {
    final flowId = await service.createRegistrationFlow();
    return flowId;
  }

  Future<Session> loginWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    final session = await service.loginWithEmailAndPassword(
        flowId: flowId, email: email, password: password);
    return session;
  }

  Future<void> registerWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    await service.registerWithEmailAndPassword(
        flowId: flowId, email: email, password: password);
  }

  Future<void> logout() async {
    await service.logout();
  }
}
