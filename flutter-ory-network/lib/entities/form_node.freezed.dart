// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FormNode _$FormNodeFromJson(Map<String, dynamic> json) {
  return _FormNode.fromJson(json);
}

/// @nodoc
mixin _$FormNode {
  NodeAttribute get attributes => throw _privateConstructorUsedError;
  List<NodeMessage> get messages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormNodeCopyWith<FormNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormNodeCopyWith<$Res> {
  factory $FormNodeCopyWith(FormNode value, $Res Function(FormNode) then) =
      _$FormNodeCopyWithImpl<$Res, FormNode>;
  @useResult
  $Res call({NodeAttribute attributes, List<NodeMessage> messages});

  $NodeAttributeCopyWith<$Res> get attributes;
}

/// @nodoc
class _$FormNodeCopyWithImpl<$Res, $Val extends FormNode>
    implements $FormNodeCopyWith<$Res> {
  _$FormNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attributes = null,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as NodeAttribute,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<NodeMessage>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NodeAttributeCopyWith<$Res> get attributes {
    return $NodeAttributeCopyWith<$Res>(_value.attributes, (value) {
      return _then(_value.copyWith(attributes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_FormNodeCopyWith<$Res> implements $FormNodeCopyWith<$Res> {
  factory _$$_FormNodeCopyWith(
          _$_FormNode value, $Res Function(_$_FormNode) then) =
      __$$_FormNodeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({NodeAttribute attributes, List<NodeMessage> messages});

  @override
  $NodeAttributeCopyWith<$Res> get attributes;
}

/// @nodoc
class __$$_FormNodeCopyWithImpl<$Res>
    extends _$FormNodeCopyWithImpl<$Res, _$_FormNode>
    implements _$$_FormNodeCopyWith<$Res> {
  __$$_FormNodeCopyWithImpl(
      _$_FormNode _value, $Res Function(_$_FormNode) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attributes = null,
    Object? messages = null,
  }) {
    return _then(_$_FormNode(
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as NodeAttribute,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<NodeMessage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FormNode implements _FormNode {
  const _$_FormNode(
      {required this.attributes, required final List<NodeMessage> messages})
      : _messages = messages;

  factory _$_FormNode.fromJson(Map<String, dynamic> json) =>
      _$$_FormNodeFromJson(json);

  @override
  final NodeAttribute attributes;
  final List<NodeMessage> _messages;
  @override
  List<NodeMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'FormNode(attributes: $attributes, messages: $messages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FormNode &&
            (identical(other.attributes, attributes) ||
                other.attributes == attributes) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, attributes, const DeepCollectionEquality().hash(_messages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FormNodeCopyWith<_$_FormNode> get copyWith =>
      __$$_FormNodeCopyWithImpl<_$_FormNode>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FormNodeToJson(
      this,
    );
  }
}

abstract class _FormNode implements FormNode {
  const factory _FormNode(
      {required final NodeAttribute attributes,
      required final List<NodeMessage> messages}) = _$_FormNode;

  factory _FormNode.fromJson(Map<String, dynamic> json) = _$_FormNode.fromJson;

  @override
  NodeAttribute get attributes;
  @override
  List<NodeMessage> get messages;
  @override
  @JsonKey(ignore: true)
  _$$_FormNodeCopyWith<_$_FormNode> get copyWith =>
      throw _privateConstructorUsedError;
}
