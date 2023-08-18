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
}
