import 'package:dio/dio.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_client/ory_client.dart';

import 'exceptions.dart';
import 'message.dart';
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
        // return session
        return response.data!;
      } else {
        throw DioException(requestOptions: response.requestOptions);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const CustomException.unauthorized();
      } else {
        throw CustomException.unknown(
            statusCode: e.response?.statusCode,
            message: e.response?.data['error'] != null
                ? e.response?.data['error']['message']
                : null);
      }
    }
  }

  Future<String> createLoginFlow() async {
    try {
      final response = await _ory.createNativeLoginFlow();
      if (response.statusCode == 200) {
        // return flow id
        return response.data!.id;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw CustomException.unknown(
          statusCode: e.response?.statusCode,
          message: e.response?.data['error'] != null
              ? e.response?.data['error']['message']
              : null);
    }
  }

  Future<void> loginWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    try {
      final UpdateLoginFlowWithPasswordMethod loginFLowBilder =
          UpdateLoginFlowWithPasswordMethod((b) => b
            ..identifier = email
            ..password = password
            ..method = 'password');

      final response = await _ory.updateLoginFlow(
          flow: flowId,
          updateLoginFlowBody: UpdateLoginFlowBody(
              (b) => b..oneOf = OneOf.fromValue1(value: loginFLowBilder)));
      if (response.statusCode == 200 && response.data?.sessionToken != null) {
        // save session token after successful login
        await storage.persistToken(response.data!.sessionToken!);
        return;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const CustomException.unauthorized();
      } else if (e.response?.statusCode == 400) {
        final messages = checkFormForErrors(e.response?.data);
        throw CustomException.badRequest(messages: messages);
      } else if (e.response?.statusCode == 410) {
        throw CustomException.flowExpired(
            flowId: e.response?.data['use_flow_id']);
      } else {
        throw CustomException.unknown(
            statusCode: e.response?.statusCode,
            message: e.response?.data['error'] != null
                ? e.response?.data['error']['message']
                : null);
      }
    }
  }

  List<UiNodeMessage> checkFormForErrors(Map<String, dynamic> response) {
    final ui = Map<String, dynamic>.from(response['ui']);
    final nodeList = ui['nodes'] as List;
    final nodeMessages =
        nodeList.map((element) => element['messages'] as List).toList();

    if (ui['messages'] != null) {
      final messageList = ui['messages'] as List;
      nodeMessages.add(messageList);
    }

    final flattedNodeMessages =
        nodeMessages.expand((element) => element).toList();

    final parsedMessages = flattedNodeMessages
        .map<UiNodeMessage>((e) => UiNodeMessage.fromJson(e))
        .toList();

    return parsedMessages;
  }
}
