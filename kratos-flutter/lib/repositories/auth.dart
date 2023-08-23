import 'package:ory_client/ory_client.dart';

import '../services/auth.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated }

class AuthRepository {
  final AuthService service;

  AuthRepository({required this.service});

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

  Future<void> loginWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    await service.loginWithEmailAndPassword(
        flowId: flowId, email: email, password: password);
  }

  Future<void> registerWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    await service.registerWithEmailAndPassword(
        flowId: flowId, email: email, password: password);
  }
}
