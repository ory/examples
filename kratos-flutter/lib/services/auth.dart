import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_client/ory_client.dart';

import '../entities/form_node.dart';
import 'exceptions.dart';
import '../entities/message.dart';
import 'storage.dart';

class AuthService {
  final storage = SecureStorage();
  final FrontendApi _ory;
  AuthService(Dio dio) : _ory = OryClient(dio: dio).getFrontendApi();

  /// Get current session information
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

  /// Create login flow
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

  /// Create registration flow
  Future<String> createRegistrationFlow() async {
    try {
      final response = await _ory.createNativeRegistrationFlow();
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

  /// Log in with [email] and [password] using login flow with [flowId]
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

  /// Register with [email] and [password] using registration flow with [flowId]
  Future<void> registerWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    try {
      final UpdateRegistrationFlowWithPasswordMethod registrationFLowBuilder =
          UpdateRegistrationFlowWithPasswordMethod((b) => b
            ..traits = JsonObject({'email': email})
            ..password = password
            ..method = 'password');

      final response = await _ory.updateRegistrationFlow(
          flow: flowId,
          updateRegistrationFlowBody: UpdateRegistrationFlowBody((b) =>
              b..oneOf = OneOf.fromValue1(value: registrationFLowBuilder)));
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

  List<NodeMessage> checkFormForErrors(Map<String, dynamic> response) {
    final ui = Map<String, dynamic>.from(response['ui']);
    final nodeList = ui['nodes'] as List;

    // parse ui nodes
    final nodes = nodeList.map<FormNode>((e) => FormNode.fromJson(e)).toList();

    // get only nodes that have messages
    final nonEmptyNodes =
        nodes.where((element) => element.messages.isNotEmpty).toList();

    // get node messages
    final nodeMessages = nonEmptyNodes
        .map((node) => node.messages
            .map((msg) => msg.copyWith(attr: node.attributes.name))
            .toList())
        .toList();

    // get general message if it exists
    if (ui['messages'] != null) {
      final messageList = ui['messages'] as List;
      final messages =
          messageList.map<NodeMessage>((e) => NodeMessage.fromJson(e)).toList();
      nodeMessages.add(messages);
    }
    // flatten message lists
    final flattedNodeMessages =
        nodeMessages.expand((element) => element).toList();

    return flattedNodeMessages;
  }
}
