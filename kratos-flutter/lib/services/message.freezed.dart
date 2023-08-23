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

UiNodeMessage _$UiNodeMessageFromJson(Map<String, dynamic> json) {
  return _UiNodeMessage.fromJson(json);
}

/// @nodoc
mixin _$UiNodeMessage {
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  Context get context => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UiNodeMessageCopyWith<UiNodeMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UiNodeMessageCopyWith<$Res> {
  factory $UiNodeMessageCopyWith(
          UiNodeMessage value, $Res Function(UiNodeMessage) then) =
      _$UiNodeMessageCopyWithImpl<$Res, UiNodeMessage>;
  @useResult
  $Res call({int id, String text, MessageType type, Context context});

  $ContextCopyWith<$Res> get context;
}

/// @nodoc
class _$UiNodeMessageCopyWithImpl<$Res, $Val extends UiNodeMessage>
    implements $UiNodeMessageCopyWith<$Res> {
  _$UiNodeMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? context = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as Context,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContextCopyWith<$Res> get context {
    return $ContextCopyWith<$Res>(_value.context, (value) {
      return _then(_value.copyWith(context: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UiNodeMessageCopyWith<$Res>
    implements $UiNodeMessageCopyWith<$Res> {
  factory _$$_UiNodeMessageCopyWith(
          _$_UiNodeMessage value, $Res Function(_$_UiNodeMessage) then) =
      __$$_UiNodeMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String text, MessageType type, Context context});

  @override
  $ContextCopyWith<$Res> get context;
}

/// @nodoc
class __$$_UiNodeMessageCopyWithImpl<$Res>
    extends _$UiNodeMessageCopyWithImpl<$Res, _$_UiNodeMessage>
    implements _$$_UiNodeMessageCopyWith<$Res> {
  __$$_UiNodeMessageCopyWithImpl(
      _$_UiNodeMessage _value, $Res Function(_$_UiNodeMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? context = null,
  }) {
    return _then(_$_UiNodeMessage(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      context: null == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as Context,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UiNodeMessage implements _UiNodeMessage {
  const _$_UiNodeMessage(
      {required this.id,
      required this.text,
      required this.type,
      required this.context});

  factory _$_UiNodeMessage.fromJson(Map<String, dynamic> json) =>
      _$$_UiNodeMessageFromJson(json);

  @override
  final int id;
  @override
  final String text;
  @override
  final MessageType type;
  @override
  final Context context;

  @override
  String toString() {
    return 'UiNodeMessage(id: $id, text: $text, type: $type, context: $context)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UiNodeMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.context, context) || other.context == context));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, type, context);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UiNodeMessageCopyWith<_$_UiNodeMessage> get copyWith =>
      __$$_UiNodeMessageCopyWithImpl<_$_UiNodeMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UiNodeMessageToJson(
      this,
    );
  }
}

abstract class _UiNodeMessage implements UiNodeMessage {
  const factory _UiNodeMessage(
      {required final int id,
      required final String text,
      required final MessageType type,
      required final Context context}) = _$_UiNodeMessage;

  factory _UiNodeMessage.fromJson(Map<String, dynamic> json) =
      _$_UiNodeMessage.fromJson;

  @override
  int get id;
  @override
  String get text;
  @override
  MessageType get type;
  @override
  Context get context;
  @override
  @JsonKey(ignore: true)
  _$$_UiNodeMessageCopyWith<_$_UiNodeMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

Context _$ContextFromJson(Map<String, dynamic> json) {
  return _Context.fromJson(json);
}

/// @nodoc
mixin _$Context {
  Property get property => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContextCopyWith<Context> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextCopyWith<$Res> {
  factory $ContextCopyWith(Context value, $Res Function(Context) then) =
      _$ContextCopyWithImpl<$Res, Context>;
  @useResult
  $Res call({Property property});
}

/// @nodoc
class _$ContextCopyWithImpl<$Res, $Val extends Context>
    implements $ContextCopyWith<$Res> {
  _$ContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? property = null,
  }) {
    return _then(_value.copyWith(
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as Property,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ContextCopyWith<$Res> implements $ContextCopyWith<$Res> {
  factory _$$_ContextCopyWith(
          _$_Context value, $Res Function(_$_Context) then) =
      __$$_ContextCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Property property});
}

/// @nodoc
class __$$_ContextCopyWithImpl<$Res>
    extends _$ContextCopyWithImpl<$Res, _$_Context>
    implements _$$_ContextCopyWith<$Res> {
  __$$_ContextCopyWithImpl(_$_Context _value, $Res Function(_$_Context) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? property = null,
  }) {
    return _then(_$_Context(
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as Property,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Context implements _Context {
  const _$_Context({this.property = Property.general});

  factory _$_Context.fromJson(Map<String, dynamic> json) =>
      _$$_ContextFromJson(json);

  @override
  @JsonKey()
  final Property property;

  @override
  String toString() {
    return 'Context(property: $property)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Context &&
            (identical(other.property, property) ||
                other.property == property));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, property);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ContextCopyWith<_$_Context> get copyWith =>
      __$$_ContextCopyWithImpl<_$_Context>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContextToJson(
      this,
    );
  }
}

abstract class _Context implements Context {
  const factory _Context({final Property property}) = _$_Context;

  factory _Context.fromJson(Map<String, dynamic> json) = _$_Context.fromJson;

  @override
  Property get property;
  @override
  @JsonKey(ignore: true)
  _$$_ContextCopyWith<_$_Context> get copyWith =>
      throw _privateConstructorUsedError;
}
