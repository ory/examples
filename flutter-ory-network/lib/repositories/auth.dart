// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:deep_collection/deep_collection.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_client/ory_client.dart';
import 'package:collection/collection.dart';

import '../services/auth.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, aal2Requested }

class AuthRepository {
  final AuthService service;

  AuthRepository({required this.service});

  Future<Session> getCurrentSessionInformation() async {
    final session = await service.getCurrentSessionInformation();
    return session;
  }

  Future<LoginFlow> createLoginFlow({required String aal}) async {
    final flow = await service.createLoginFlow(aal: aal);
    return flow;
  }

  Future<RegistrationFlow> createRegistrationFlow() async {
    final flow = await service.createRegistrationFlow();
    return flow;
  }

  Future<LoginFlow> getLoginFlow({required String flowId}) async {
    final flow = await service.getLoginFlow(flowId: flowId);
    return flow;
  }

  Future<RegistrationFlow> getRegistrationFlow({required String flowId}) async {
    final flow = await service.getRegistrationFlow(flowId: flowId);
    return flow;
  }

  Future<void> logout() async {
    await service.logout();
  }

  Future<SuccessfulNativeRegistration?> updateRegistrationFlow(
      {required String flowId,
      required UiNodeGroupEnum group,
      required String name,
      required String value,
      required List<UiNode> nodes}) async {
    // create request body
    final body = _createRequestBody(
        group: group, name: name, value: value, nodes: nodes);
    // submit registration
    final registration = await service.updateRegistrationFlow(
        flowId: flowId, group: group, value: body);
    return registration;
  }

  Future<SuccessfulNativeLogin?> updateLoginFlow(
      {required String flowId,
      required UiNodeGroupEnum group,
      required String name,
      required String value,
      required List<UiNode> nodes}) async {
    // create request body
    final body = _createRequestBody(
        group: group, name: name, value: value, nodes: nodes);
    // submit login
    print(body);
    final login = await service.updateLoginFlow(
        flowId: flowId, group: group, value: body);
    return login;
  }

  Map _createRequestBody(
      {required UiNodeGroupEnum group,
      required String name,
      required String value,
      required List<UiNode> nodes}) {
    // if name of submitted node is method, find all nodes that belong to the group
    if (name == 'method') {
      // get input nodes of the same group
      final inputNodes = nodes.where((p0) {
        if (p0.attributes.oneOf.isType(UiNodeInputAttributes)) {
          final attributes = p0.attributes.oneOf.value as UiNodeInputAttributes;
          // if group is password, find identifier
          if (group == UiNodeGroupEnum.password &&
              p0.group == UiNodeGroupEnum.default_ &&
              attributes.name == 'identifier') {
            return true;
          }
          return p0.group == group &&
              attributes.type != UiNodeInputAttributesTypeEnum.button &&
              attributes.type != UiNodeInputAttributesTypeEnum.submit;
        } else {
          return false;
        }
      });
      // create maps from attribute names and their values
      final nestedMaps = inputNodes.map((e) {
        final attributes = e.attributes.oneOf.value as UiNodeInputAttributes;

        return generateNestedMap(
            attributes.name, attributes.value?.asString ?? '');
      }).toList();

      // merge nested maps into one
      final mergedMap =
          nestedMaps.reduce((value, element) => value.deepMerge(element));

      return mergedMap;
    } else {
      return {name: value};
    }
  }

  LoginFlow resetButtonValues({required LoginFlow loginFlow}) {
    final submitInputNodes = loginFlow.ui.nodes.where((p0) {
      if (p0.attributes.oneOf.isType(UiNodeInputAttributes)) {
        final attributes = p0.attributes.oneOf.value as UiNodeInputAttributes;
        final type = attributes.type;
        if ((type == UiNodeInputAttributesTypeEnum.button ||
                type == UiNodeInputAttributesTypeEnum.submit) &&
            attributes.value?.asString == 'true') {
          return true;
        }
      }
      return false;
    });
    for (var node in submitInputNodes) {
      final attributes = node.attributes.oneOf.value as UiNodeInputAttributes;
      // reset button value to false
      // to prevent submitting values that were not selected
      loginFlow = changeLoginNodeValue(
          settings: loginFlow, name: attributes.name, value: 'false');
    }
    return loginFlow;
  }

  RegistrationFlow changeRegistrationNodeValue(
      {required RegistrationFlow settings,
      required String name,
      required String value}) {
    // update node value
    final updatedNodes =
        updateNodes(nodes: settings.ui.nodes, name: name, value: value);
    // update settings' node
    final newFlow =
        settings.rebuild((p0) => p0..ui.nodes.replace(updatedNodes));
    return newFlow;
  }

  LoginFlow changeLoginNodeValue(
      {required LoginFlow settings,
      required String name,
      required String value}) {
    // update node value
    final updatedNodes =
        updateNodes(nodes: settings.ui.nodes, name: name, value: value);
    // update settings' node
    final newFlow =
        settings.rebuild((p0) => p0..ui.nodes.replace(updatedNodes));
    return newFlow;
  }

  BuiltList<UiNode> updateNodes(
      {required BuiltList<UiNode> nodes,
      required String name,
      required String value}) {
    // get edited node
    final node = nodes.firstWhereOrNull((element) {
      if (element.attributes.oneOf.isType(UiNodeInputAttributes)) {
        return (element.attributes.oneOf.value as UiNodeInputAttributes).name ==
            name;
      } else {
        return false;
      }
    });

    // udate value of edited node
    final updatedNode = node?.rebuild((p0) => p0
      ..attributes.update((b) {
        final oldValue = b.oneOf?.value as UiNodeInputAttributes;
        final newValue = oldValue.rebuild((p0) => p0.value = JsonObject(value));
        b.oneOf = OneOf1(value: newValue);
      }));
    // get index of to be updated node
    final nodeIndex = nodes.indexOf(node!);
    // update list of nodes to iclude updated node
    return nodes.rebuild((p0) => p0
      ..removeAt(nodeIndex)
      ..insert(nodeIndex, updatedNode!));
  }

  Map<dynamic, dynamic> generateNestedMap(String path, String value) {
    var steps = path.split('.');
    Object? result = value;
    for (var step in steps.reversed) {
      result = {step: result};
    }
    return result as Map<dynamic, dynamic>;
  }
}
