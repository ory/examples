// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FormNode _$$_FormNodeFromJson(Map<String, dynamic> json) => _$_FormNode(
      attributes:
          NodeAttribute.fromJson(json['attributes'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => NodeMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_FormNodeToJson(_$_FormNode instance) =>
    <String, dynamic>{
      'attributes': instance.attributes,
      'messages': instance.messages,
    };
