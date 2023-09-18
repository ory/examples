// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'formfield.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FormField<T> {
  T? get value => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FormFieldCopyWith<T, FormField<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormFieldCopyWith<T, $Res> {
  factory $FormFieldCopyWith(
          FormField<T> value, $Res Function(FormField<T>) then) =
      _$FormFieldCopyWithImpl<T, $Res, FormField<T>>;
  @useResult
  $Res call({T? value, String? errorMessage});
}

/// @nodoc
class _$FormFieldCopyWithImpl<T, $Res, $Val extends FormField<T>>
    implements $FormFieldCopyWith<T, $Res> {
  _$FormFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FormFieldCopyWith<T, $Res>
    implements $FormFieldCopyWith<T, $Res> {
  factory _$$_FormFieldCopyWith(
          _$_FormField<T> value, $Res Function(_$_FormField<T>) then) =
      __$$_FormFieldCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? value, String? errorMessage});
}

/// @nodoc
class __$$_FormFieldCopyWithImpl<T, $Res>
    extends _$FormFieldCopyWithImpl<T, $Res, _$_FormField<T>>
    implements _$$_FormFieldCopyWith<T, $Res> {
  __$$_FormFieldCopyWithImpl(
      _$_FormField<T> _value, $Res Function(_$_FormField<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$_FormField<T>(
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_FormField<T> implements _FormField<T> {
  const _$_FormField({this.value, this.errorMessage});

  @override
  final T? value;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'FormField<$T>(value: $value, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FormField<T> &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(value), errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FormFieldCopyWith<T, _$_FormField<T>> get copyWith =>
      __$$_FormFieldCopyWithImpl<T, _$_FormField<T>>(this, _$identity);
}

abstract class _FormField<T> implements FormField<T> {
  const factory _FormField({final T? value, final String? errorMessage}) =
      _$_FormField<T>;

  @override
  T? get value;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$_FormFieldCopyWith<T, _$_FormField<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
