// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_client/ory_client.dart';

import 'exceptions.dart';
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
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await storage.deleteToken();
        throw const CustomException.unauthorized();
      } else if (e.response?.statusCode == 403) {
        if (e.response?.data['error']['id'] == 'session_aal2_required') {
          throw const CustomException.twoFactorAuthRequired();
        } else {
          throw _handleUnknownException(e.response?.data);
        }
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  /// Create login flow
  Future<LoginFlow> createLoginFlow({required String aal}) async {
    try {
      final token = await storage.getToken();
      final response = await _ory.createNativeLoginFlow(
          aal: aal,
          xSessionToken: token,
          returnSessionTokenExchangeCode: true,
          returnTo: 'ory://flutter-ory-network');
      if (response.data != null) {
        // return flow id
        return response.data!;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw _handleUnknownException(e.response?.data);
    }
  }

  /// Create registration flow
  Future<RegistrationFlow> createRegistrationFlow() async {
    try {
      final response = await _ory.createNativeRegistrationFlow(
          returnSessionTokenExchangeCode: true,
          returnTo: 'ory://flutter-ory-network');
      if (response.data != null) {
        // return flow id
        return response.data!;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw _handleUnknownException(e.response?.data);
    }
  }

  /// Update login flow with [flowId] for [group] with [value]
  Future<SuccessfulNativeLogin> updateLoginFlow(
      {required String flowId,
      required UiNodeGroupEnum group,
      required Map value}) async {
    try {
      final token = await storage.getToken();
      final OneOf oneOf;

      // create update body depending on method
      switch (group) {
        case UiNodeGroupEnum.password:
          oneOf = OneOf.fromValue1(
              value: UpdateLoginFlowWithPasswordMethod((b) => b
                ..method = group.name
                ..identifier = value['identifier']
                ..password = value['password']));
        case UiNodeGroupEnum.lookupSecret:
          oneOf = OneOf.fromValue1(
              value: UpdateLoginFlowWithLookupSecretMethod((b) => b
                // use pre-defined string as enum value doesn't include an underscore
                ..method = 'lookup_secret'
                ..lookupSecret = value['lookup_secret']));
        case UiNodeGroupEnum.totp:
          oneOf = OneOf.fromValue1(
              value: UpdateLoginFlowWithTotpMethod((b) => b
                ..method = group.name
                ..totpCode = value['totp_code']));
        case UiNodeGroupEnum.oidc:
          oneOf = OneOf.fromValue1(
              value: UpdateLoginFlowWithOidcMethod((b) => b
                ..method = group.name
                ..provider = value['provider']
                ..idToken = value['id_token']
                ..idTokenNonce = value['nonce']));

        // if method is not implemented, throw exception
        default:
          throw const CustomException.unknown();
      }

      final response = await _ory.updateLoginFlow(
          flow: flowId,
          xSessionToken: token,
          updateLoginFlowBody: UpdateLoginFlowBody((b) => b..oneOf = oneOf));

      if (response.data?.session != null) {
        // save session token after successful login
        await storage.persistToken(response.data!.sessionToken!);
        if (response.data!.session.identity != null) {
          return response.data!;
        } else {
          // identity is null, aal2 is required
          throw const CustomException.twoFactorAuthRequired();
        }
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await storage.deleteToken();
        throw const CustomException.unauthorized();
      } else if (e.response?.statusCode == 400) {
        final loginFlow = standardSerializers.deserializeWith(
            LoginFlow.serializer, e.response?.data);
        if (loginFlow != null) {
          throw CustomException<LoginFlow>.badRequest(flow: loginFlow);
        } else {
          throw const CustomException.unknown();
        }
      } else if (e.response?.statusCode == 410) {
        // settings flow expired, use new flow id
        throw CustomException.flowExpired(
            flowId: e.response?.data['use_flow_id']);
      } else if (e.response?.statusCode == 422) {
        final error = e.response?.data['error'];
        if (error['id'] == 'browser_location_change_required') {
          throw CustomException.locationChangeRequired(
              url: e.response?.data['redirect_browser_to']);
        }
        throw const CustomException.unknown();
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  /// Get login flow with [flowId]
  Future<LoginFlow> getLoginFlow({required String flowId}) async {
    try {
      final response = await _ory.getLoginFlow(id: flowId);

      if (response.data != null) {
        // return flow
        return response.data!;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw _handleUnknownException(e.response?.data);
    }
  }

  /// Get registration flow with [flowId]
  Future<RegistrationFlow> getRegistrationFlow({required String flowId}) async {
    try {
      final response = await _ory.getRegistrationFlow(id: flowId);

      if (response.data != null) {
        // return flow
        return response.data!;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw _handleUnknownException(e.response?.data);
    }
  }

  /// When using oidc flow with [flowId], excange [initCode] and [returnToCode] for a session token
  Future<Session> exchangeCodesForSessionToken(
      {required String flowId,
      required String initCode,
      required String returnToCode}) async {
    try {
      final response = await _ory.exchangeSessionToken(
          initCode: initCode, returnToCode: returnToCode);

      if (response.data?.session != null) {
        // save session token after successful login
        await storage.persistToken(response.data!.sessionToken!);
        return response.data!.session;
      } else {
        throw const CustomException.unknown();
      }
    } on DioException catch (e) {
      throw _handleUnknownException(e.response?.data);
    }
  }

  /// Update registration flow with [flowId] for [group] with [value]
  Future<Session> updateRegistrationFlow(
      {required String flowId,
      required UiNodeGroupEnum group,
      required Map value}) async {
    try {
      final OneOf oneOf;

      // create update body depending on method
      switch (group) {
        case UiNodeGroupEnum.password:
          oneOf = OneOf.fromValue1(
              value: UpdateRegistrationFlowWithPasswordMethod((b) => b
                ..method = group.name
                ..traits = JsonObject(value['traits'])
                ..password = value['password']));
        case UiNodeGroupEnum.oidc:
          oneOf = OneOf.fromValue1(
              value: UpdateRegistrationFlowWithOidcMethod((b) => b
                ..method = group.name
                ..provider = value['provider']
                ..idToken = value['id_token']
                ..idTokenNonce = value['nonce']));

        // if method is not implemented, throw exception
        default:
          throw const CustomException.unknown();
      }

      final response = await _ory.updateRegistrationFlow(
          flow: flowId,
          updateRegistrationFlowBody:
              UpdateRegistrationFlowBody((b) => b..oneOf = oneOf));

      if (response.data?.session != null) {
        // save session token after successful login
        await storage.persistToken(response.data!.sessionToken!);
        return response.data!.session!;
      } else {
        throw const CustomException.unknown();
      }
      // dio throws exception 200 when logging in with google
    } on DioException catch (e) {
      // user tried to register with social sign in using already existing account
      if (e.response?.statusCode == 200) {
        final successfulLogin = standardSerializers.deserializeWith(
            SuccessfulNativeLogin.serializer, e.response?.data);
        if (successfulLogin?.session != null) {
          // save session token after successful login
          await storage.persistToken(successfulLogin!.sessionToken!);
          return successfulLogin.session;
        } else {
          throw const CustomException.unknown();
        }
      } else if (e.response?.statusCode == 400) {
        final registrationFlow = standardSerializers.deserializeWith(
            RegistrationFlow.serializer, e.response?.data);
        if (registrationFlow != null) {
          throw CustomException<RegistrationFlow>.badRequest(
              flow: registrationFlow);
        } else {
          throw const CustomException.unknown();
        }
      } else if (e.response?.statusCode == 410) {
        // settings flow expired, use new flow id and add error message
        throw CustomException.flowExpired(
            flowId: e.response?.data['use_flow_id']);
      } else if (e.response?.statusCode == 422) {
        final error = e.response?.data['error'];
        if (error['id'] == 'browser_location_change_required') {
          throw CustomException.locationChangeRequired(
              url: e.response?.data['redirect_browser_to']);
        }
        throw const CustomException.unknown();
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    } catch (e) {
      throw const CustomException.unknown();
    }
  }

  Future<void> logout() async {
    try {
      final token = await storage.getToken();

      final PerformNativeLogoutBody logoutBody =
          PerformNativeLogoutBody((b) => b..sessionToken = token);
      final response =
          await _ory.performNativeLogout(performNativeLogoutBody: logoutBody);
      if (response.statusCode == 204) {
        await storage.deleteToken();
        return;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await storage.deleteToken();
        throw const CustomException.unauthorized();
      } else {
        throw _handleUnknownException(e.response?.data);
      }
    }
  }

  CustomException _handleUnknownException(Map? response) {
    // use error message if response contains it, otherwise use default value
    if (response != null && response.containsKey('error')) {
      return CustomException.unknown(message: response['error']['message']);
    } else {
      return const CustomException.unknown();
    }
  }
}
