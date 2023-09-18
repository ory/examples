// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NodeMessage _$NodeMessageFromJson(Map<String, dynamic> json) {
  return _NodeMessage.fromJson(json);
}

/// @nodoc
mixin _$NodeMessage {
  int? get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  MessageType get type =>
      throw _privateConstructorUsedError; // allows to differentiate between contexts
  String get attr => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NodeMessageCopyWith<NodeMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeMessageCopyWith<$Res> {
  factory $NodeMessageCopyWith(
          NodeMessage value, $Res Function(NodeMessage) then) =
      _$NodeMessageCopyWithImpl<$Res, NodeMessage>;
  @useResult
  $Res call({int? id, String text, MessageType type, String attr});
}

/// @nodoc
class _$NodeMessageCopyWithImpl<$Res, $Val extends NodeMessage>
    implements $NodeMessageCopyWith<$Res> {
  _$NodeMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = null,
    Object? type = null,
    Object? attr = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      attr: null == attr
          ? _value.attr
          : attr // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NodeMessageCopyWith<$Res>
    implements $NodeMessageCopyWith<$Res> {
  factory _$$_NodeMessageCopyWith(
          _$_NodeMessage value, $Res Function(_$_NodeMessage) then) =
      __$$_NodeMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String text, MessageType type, String attr});
}

/// @nodoc
class __$$_NodeMessageCopyWithImpl<$Res>
    extends _$NodeMessageCopyWithImpl<$Res, _$_NodeMessage>
    implements _$$_NodeMessageCopyWith<$Res> {
  __$$_NodeMessageCopyWithImpl(
      _$_NodeMessage _value, $Res Function(_$_NodeMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = null,
    Object? type = null,
    Object? attr = null,
  }) {
    return _then(_$_NodeMessage(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      attr: null == attr
          ? _value.attr
          : attr // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NodeMessage implements _NodeMessage {
  const _$_NodeMessage(
      {this.id, required this.text, required this.type, this.attr = 'general'});

  factory _$_NodeMessage.fromJson(Map<String, dynamic> json) =>
      _$$_NodeMessageFromJson(json);

  @override
  final int? id;
  @override
  final String text;
  @override
  final MessageType type;
// allows to differentiate between contexts
  @override
  @JsonKey()
  final String attr;

  @override
  String toString() {
    return 'NodeMessage(id: $id, text: $text, type: $type, attr: $attr)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NodeMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.attr, attr) || other.attr == attr));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, type, attr);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NodeMessageCopyWith<_$_NodeMessage> get copyWith =>
      __$$_NodeMessageCopyWithImpl<_$_NodeMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NodeMessageToJson(
      this,
    );
  }
}

abstract class _NodeMessage implements NodeMessage {
  const factory _NodeMessage(
      {final int? id,
      required final String text,
      required final MessageType type,
      final String attr}) = _$_NodeMessage;

  factory _NodeMessage.fromJson(Map<String, dynamic> json) =
      _$_NodeMessage.fromJson;

  @override
  int? get id;
  @override
  String get text;
  @override
  MessageType get type;
  @override // allows to differentiate between contexts
  String get attr;
  @override
  @JsonKey(ignore: true)
  _$$_NodeMessageCopyWith<_$_NodeMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
