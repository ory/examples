// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:freezed_annotation/freezed_annotation.dart';
part 'node_attribute.freezed.dart';
part 'node_attribute.g.dart';

@freezed
sealed class NodeAttribute with _$NodeAttribute {
  const factory NodeAttribute({required String name}) = _NodeAttribute;

  factory NodeAttribute.fromJson(Map<String, dynamic> json) =>
      _$NodeAttributeFromJson(json);
}
