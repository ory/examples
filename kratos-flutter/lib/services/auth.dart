import 'package:dio/dio.dart';
import 'package:ory_client/ory_client.dart';

import 'exceptions.dart';
import 'storage.dart';

class AuthService {
  final storage = SecureStorage();
  final FrontendApi _ory;
  AuthService(Dio dio) : _ory = OryClient(dio: dio).getFrontendApi();

  Future<Session> getCurrentSessionInformation() async {
    try {
      final token = await storage.getToken();
      final response = await _ory.toSession(xSessionToken: token);
      if (response.data != null) {
        return response.data!;
      } else {
        throw DioException(requestOptions: response.requestOptions);
      }
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<String> createLoginFlow() async {
    try {
      final response = await _ory.createNativeLoginFlow();
      if (response.statusCode == 200) {
        return response.data!.id;
      } else {
        throw CustomException(statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }
}
