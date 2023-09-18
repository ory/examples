// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NodeMessage _$$_NodeMessageFromJson(Map<String, dynamic> json) =>
    _$_NodeMessage(
      id: json['id'] as int?,
      text: json['text'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      attr: json['attr'] as String? ?? 'general',
    );

Map<String, dynamic> _$$_NodeMessageToJson(_$_NodeMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'attr': instance.attr,
    };

const _$MessageTypeEnumMap = {
  MessageType.info: 'info',
  MessageType.error: 'error',
  MessageType.success: 'success',
};
