// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:built_value/json_object.dart';
import 'package:deep_collection/deep_collection.dart';
import 'package:one_of/one_of.dart';
import 'package:ory_client/ory_client.dart';
import 'package:ory_network_flutter/entities/message.dart';
import 'package:collection/collection.dart';

import '../services/auth.dart';

class SettingsRepository {
  final AuthService service;

  SettingsRepository({required this.service});

  Future<SettingsFlow> createSettingsFlow() async {
    final settingsFlow = await service.createSettingsFlow();
    return settingsFlow;
  }

  Future<List<NodeMessage>?> submitNewPassword(
      {required String flowId, required String password}) async {
    final messages =
        await service.submitNewPassword(flowId: flowId, password: password);
    return messages;
  }

  Future<SettingsFlow?> submitNewSettings(
      {required String flowId,
      required UiNodeGroupEnum group,
      List<UiNode>? nodes}) async {
    // get input nodes of the same group
    final inputNodes = nodes?.where((p0) {
      if (p0.attributes.oneOf.isType(UiNodeInputAttributes)) {
        final type = (p0.attributes.oneOf.value as UiNodeInputAttributes).type;
        return p0.group == group &&
            type != UiNodeInputAttributesTypeEnum.button;
      } else {
        return false;
      }
    });

// create maps from attribute names and their values
    final nestedMaps = inputNodes?.map((e) {
      final attributes = e.attributes.oneOf.value as UiNodeInputAttributes;

      return generateNestedMap(attributes.name, attributes.value!.asString);
    }).toList();

    // merge nested maps into one
    final mergedMap =
        nestedMaps?.reduce((value, element) => value.deepMerge(element));
    print('mergedMap ${mergedMap}');

    final updatedSettings = await service.submitNewSettings(
        flowId: flowId, group: group, value: mergedMap!);
    return updatedSettings;
  }

  SettingsFlow? changeNodeValue<T>(
      {SettingsFlow? settings, required String name, required T value}) {
    // get edited node
    if (settings != null) {
      final node = settings.ui.nodes.firstWhereOrNull((element) {
        if (element.attributes.oneOf.isType(UiNodeInputAttributes)) {
          return (element.attributes.oneOf.value as UiNodeInputAttributes)
                  .name ==
              name;
        } else {
          return false;
        }
      });

      final updatedNode = node?.rebuild((p0) => p0
        ..attributes.update((b) {
          final oldValue = b.oneOf?.value as UiNodeInputAttributes;
          final newValue =
              oldValue.rebuild((p0) => p0.value = JsonObject(value));
          b.oneOf = OneOf1(value: newValue);
        }));

      final nodeIndex = settings.ui.nodes.indexOf(node!);

      final newList = settings.ui.nodes.rebuild((p0) => p0
        ..removeAt(nodeIndex)
        ..insert(nodeIndex, updatedNode!));
      final newSettings =
          settings.rebuild((p0) => p0..ui.nodes.replace(newList));
      return newSettings;
    } else {
      return settings;
    }
  }

  /// Generate nested map from  [path] with [value]
  Map<dynamic, dynamic> generateNestedMap(String path, String value) {
    var steps = path.split('.');
    Object result = value;
    for (var step in steps.reversed) {
      result = {step: result};
    }
    return result as Map<dynamic, dynamic>;
  }
}
