// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_client/ory_client.dart';
import '../entities/form_node.dart';
import 'exceptions.dart';
import '../entities/message.dart';
import 'storage.dart';

class AuthService {
  final _storage = SecureStorage();
  final FrontendApi _ory;
  AuthService(Dio dio) : _ory = OryClient(dio: dio).getFrontendApi();

  /// Delete expired session token from storage
  Future<void> deleteExpiredSessionToken() async {
    await _storage.deleteToken();
  }

  /// Get current session information
  Future<Session> getCurrentSessionInformation() async {
    try {
      final token = await _storage.getToken();
      final response = await _ory.toSession(xSessionToken: token);
      if (response.data != null) {
        // return session
        return response.data!;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.deleteToken();
        throw const CustomException.unauthorized();
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  /// Create login flow
  Future<String> createLoginFlow() async {
    try {
      final token = await _storage.getToken();
      // create native login flow. If session token is available, refresh the session
      final response = await _ory.createNativeLoginFlow(
          xSessionToken: token, refresh: token != null);
      if (response.data != null) {
        // return flow id
        return response.data!.id;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw _handleUnknownException(e.response?.data);
    }
  }

  /// Create registration flow
  Future<String> createRegistrationFlow() async {
    try {
      final response = await _ory.createNativeRegistrationFlow();
      if (response.data != null) {
        // return flow id
        return response.data!.id;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw _handleUnknownException(e.response?.data);
    }
  }

  /// Log in with [email] and [password] using login flow with [flowId]
  Future<Session> loginWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    try {
      final token = await _storage.getToken();
      final UpdateLoginFlowWithPasswordMethod loginFLowBuilder =
          UpdateLoginFlowWithPasswordMethod((b) => b
            ..identifier = email
            ..password = password
            ..method = 'password');

      final response = await _ory.updateLoginFlow(
          flow: flowId,
          xSessionToken: token,
          updateLoginFlowBody: UpdateLoginFlowBody(
              (b) => b..oneOf = OneOf.fromValue1(value: loginFLowBuilder)));

      if (response.data?.session != null) {
        // save session token after successful login
        await _storage.persistToken(response.data!.sessionToken!);
        return response.data!.session;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.deleteToken();
        throw const CustomException.unauthorized();
      } else if (e.response?.statusCode == 400) {
        final messages = _checkFormForErrors(e.response?.data);
        throw CustomException.badRequest(messages: messages);
      } else if (e.response?.statusCode == 410) {
        // login flow expired, use new flow id and add error message
        throw CustomException.flowExpired(
            flowId: e.response?.data['use_flow_id'],
            message: 'Login flow has expired. Please enter credentials again.');
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  /// Register with [email] and [password] using registration flow with [flowId]
  Future<void> registerWithEmailAndPassword(
      {required String flowId,
      required String email,
      required String password}) async {
    try {
      final UpdateRegistrationFlowWithPasswordMethod registrationFLow =
          UpdateRegistrationFlowWithPasswordMethod((b) => b
            ..traits = JsonObject({'email': email})
            ..password = password
            ..method = 'password');

      final response = await _ory.updateRegistrationFlow(
          flow: flowId,
          updateRegistrationFlowBody: UpdateRegistrationFlowBody(
              (b) => b..oneOf = OneOf.fromValue1(value: registrationFLow)));
      if (response.data?.sessionToken != null) {
        // save session token after successful login
        await _storage.persistToken(response.data!.sessionToken!);
        return;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.deleteToken();
        throw const CustomException.unauthorized();
      } else if (e.response?.statusCode == 400) {
        final messages = _checkFormForErrors(e.response?.data);
        throw CustomException.badRequest(messages: messages);
      } else if (e.response?.statusCode == 410) {
        // registration flow expired, use new flow id and add error message
        throw CustomException.flowExpired(
            flowId: e.response?.data['use_flow_id'],
            message:
                'Registration flow has expired. Please enter credentials again.');
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  /// Log out
  Future<void> logout() async {
    try {
      final token = await _storage.getToken();

      final PerformNativeLogoutBody logoutBody =
          PerformNativeLogoutBody((b) => b..sessionToken = token);
      final response =
          await _ory.performNativeLogout(performNativeLogoutBody: logoutBody);
      if (response.statusCode == 204) {
        await _storage.deleteToken();
        return;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.deleteToken();
        throw const CustomException.unauthorized();
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  /// Create settings flow
  Future<SettingsFlow> createSettingsFlow() async {
    try {
      final token = await _storage.getToken();
      final response =
          await _ory.createNativeSettingsFlow(xSessionToken: token);

      if (response.data != null) {
        // return flow id
        return response.data!;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.deleteToken();
        throw const CustomException.unauthorized();
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  Future<SettingsFlow?> submitNewSettings(
      {required String flowId,
      required UiNodeGroupEnum group,
      required Map value}) async {
    try {
      final token = await _storage.getToken();
      final OneOf oneOf;
      print(value);

      switch (group) {
        case UiNodeGroupEnum.password:
          oneOf = OneOf.fromValue1(
              value: UpdateSettingsFlowWithPasswordMethod((b) => b
                ..method = group.name
                ..password = value['password']));
        case UiNodeGroupEnum.profile:
          oneOf = OneOf.fromValue1(
              value: UpdateSettingsFlowWithProfileMethod((b) => b
                ..method = group.name
                ..traits = JsonObject(value['traits'])));
        case UiNodeGroupEnum.lookupSecret:
          oneOf = OneOf.fromValue1(
              value: UpdateSettingsFlowWithLookupMethod((b) => b
                ..method = group.name
                ..lookupSecretConfirm =
                    getBoolValue(value['lookup_secret_confirm'])
                ..lookupSecretDisable =
                    getBoolValue(value['lookup_secret_disable'])
                ..lookupSecretReveal =
                    getBoolValue(value['lookup_secret_reveal'])
                ..lookupSecretRegenerate =
                    getBoolValue(value['lookup_secret_regenerate'])));
        case UiNodeGroupEnum.totp:
          oneOf = OneOf.fromValue1(
              value: UpdateSettingsFlowWithTotpMethod((b) => b
                ..method = group.name
                ..totpCode = value['totp_code']
                ..totpUnlink = getBoolValue(value['totp_unlink'])));
        default:
          oneOf = OneOf.fromValue1(value: null);
      }

      final response = await _ory.updateSettingsFlow(
          flow: flowId,
          xSessionToken: token,
          updateSettingsFlowBody:
              UpdateSettingsFlowBody((b) => b..oneOf = oneOf));
      print(response.data?.ui.messages);

      return response.data;
    } on DioException catch (e) {
      print(e.error);
      print(e.response?.data);
    }
    return null;
  }

  bool? getBoolValue(String? value) {
    if (value == null) {
      return null;
    } else {
      return value == 'true' ? true : false;
    }
  }

  /// Change old password to new [password] using settings flow with [flowId]
  Future<List<NodeMessage>?> submitNewPassword(
      {required String flowId, required String password}) async {
    try {
      final token = await _storage.getToken();
      final UpdateSettingsFlowWithPasswordMethod body =
          UpdateSettingsFlowWithPasswordMethod((b) => b
            ..method = 'password'
            ..password = password);

      final response = await _ory.updateSettingsFlow(
          flow: flowId,
          xSessionToken: token,
          updateSettingsFlowBody: UpdateSettingsFlowBody(
              (b) => b..oneOf = OneOf.fromValue1(value: body)));
      if (response.statusCode == 400) {
        // get input nodes with messages
        final inputNodesWithMessages = response.data?.ui.nodes
            .asList()
            .where((e) =>
                e.attributes.oneOf.isType(UiNodeInputAttributes) &&
                e.messages.isNotEmpty)
            .toList();

        // get input node messages
        final nodeMessages = inputNodesWithMessages
            ?.map((node) => node.messages
                .asList()
                .map((msg) => NodeMessage(
                    id: msg.id,
                    text: msg.text,
                    type: msg.type.name.messageType,
                    attr: (node.attributes.oneOf.value as UiNodeInputAttributes)
                        .name))
                .toList())
            .toList();

        // get general messages
        final generalMessages = response.data?.ui.messages
            ?.asList()
            .map((e) => NodeMessage(
                id: e.id, text: e.text, type: e.type.name.messageType))
            .toList();

        // add general messages to input node messages if they exist
        if (generalMessages != null) {
          nodeMessages?.add(generalMessages);
        }

        // flatten message list
        final flattedNodeMessages =
            nodeMessages?.expand((element) => element).toList();

        throw CustomException.badRequest(messages: flattedNodeMessages);
      }

      // get messages on success
      final messages = response.data?.ui.messages
          ?.asList()
          .map((msg) => NodeMessage(
              id: msg.id, text: msg.text, type: msg.type.name.messageType))
          .toList();
      return messages;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _storage.deleteToken();
        throw const CustomException.unauthorized();
      } else if (e.response?.statusCode == 403) {
        throw const CustomException.sessionRefreshRequired();
      } else if (e.response?.statusCode == 410) {
        // settings flow expired, use new flow id and add error message
        throw CustomException.flowExpired(
            flowId: e.response?.data['use_flow_id'],
            message:
                'Settings flow has expired. Please enter credentials again.');
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  /// Search for error messages and their context in [response]
  List<NodeMessage> _checkFormForErrors(Map<String, dynamic> response) {
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

  CustomException _handleUnknownException(Map? response) {
    // use human-readable reason if response contains it, otherwise use default value
    if (response != null &&
        response.containsKey('error') &&
        (response['error'] as Map).containsKey('reason')) {
      return CustomException.unknown(message: response['error']['reason']);
    } else {
      return const CustomException.unknown();
    }
  }
}
