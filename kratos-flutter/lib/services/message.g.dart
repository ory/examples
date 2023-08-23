// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UiNodeMessage _$$_UiNodeMessageFromJson(Map<String, dynamic> json) =>
    _$_UiNodeMessage(
      id: json['id'] as int,
      text: json['text'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      context: Context.fromJson(json['context'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UiNodeMessageToJson(_$_UiNodeMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'context': instance.context,
    };

const _$MessageTypeEnumMap = {
  MessageType.info: 'info',
  MessageType.error: 'error',
  MessageType.success: 'success',
};

_$_Context _$$_ContextFromJson(Map<String, dynamic> json) => _$_Context(
      property: $enumDecodeNullable(_$PropertyEnumMap, json['property']) ??
          Property.general,
    );

Map<String, dynamic> _$$_ContextToJson(_$_Context instance) =>
    <String, dynamic>{
      'property': _$PropertyEnumMap[instance.property]!,
    };

const _$PropertyEnumMap = {
  Property.identifier: 'identifier',
  Property.password: 'password',
  Property.general: 'general',
};
