// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_attribute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NodeAttribute _$NodeAttributeFromJson(Map<String, dynamic> json) {
  return _NodeAttribute.fromJson(json);
}

/// @nodoc
mixin _$NodeAttribute {
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NodeAttributeCopyWith<NodeAttribute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeAttributeCopyWith<$Res> {
  factory $NodeAttributeCopyWith(
          NodeAttribute value, $Res Function(NodeAttribute) then) =
      _$NodeAttributeCopyWithImpl<$Res, NodeAttribute>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$NodeAttributeCopyWithImpl<$Res, $Val extends NodeAttribute>
    implements $NodeAttributeCopyWith<$Res> {
  _$NodeAttributeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NodeAttributeCopyWith<$Res>
    implements $NodeAttributeCopyWith<$Res> {
  factory _$$_NodeAttributeCopyWith(
          _$_NodeAttribute value, $Res Function(_$_NodeAttribute) then) =
      __$$_NodeAttributeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$_NodeAttributeCopyWithImpl<$Res>
    extends _$NodeAttributeCopyWithImpl<$Res, _$_NodeAttribute>
    implements _$$_NodeAttributeCopyWith<$Res> {
  __$$_NodeAttributeCopyWithImpl(
      _$_NodeAttribute _value, $Res Function(_$_NodeAttribute) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$_NodeAttribute(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NodeAttribute implements _NodeAttribute {
  const _$_NodeAttribute({required this.name});

  factory _$_NodeAttribute.fromJson(Map<String, dynamic> json) =>
      _$$_NodeAttributeFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'NodeAttribute(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NodeAttribute &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NodeAttributeCopyWith<_$_NodeAttribute> get copyWith =>
      __$$_NodeAttributeCopyWithImpl<_$_NodeAttribute>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NodeAttributeToJson(
      this,
    );
  }
}

abstract class _NodeAttribute implements NodeAttribute {
  const factory _NodeAttribute({required final String name}) = _$_NodeAttribute;

  factory _NodeAttribute.fromJson(Map<String, dynamic> json) =
      _$_NodeAttribute.fromJson;

  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_NodeAttributeCopyWith<_$_NodeAttribute> get copyWith =>
      throw _privateConstructorUsedError;
}
