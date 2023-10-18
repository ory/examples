// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegistrationState {
  RegistrationFlow? get registrationFlow => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegistrationStateCopyWith<RegistrationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationStateCopyWith<$Res> {
  factory $RegistrationStateCopyWith(
          RegistrationState value, $Res Function(RegistrationState) then) =
      _$RegistrationStateCopyWithImpl<$Res, RegistrationState>;
  @useResult
  $Res call(
      {RegistrationFlow? registrationFlow, bool isLoading, String? message});
}

/// @nodoc
class _$RegistrationStateCopyWithImpl<$Res, $Val extends RegistrationState>
    implements $RegistrationStateCopyWith<$Res> {
  _$RegistrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registrationFlow = freezed,
    Object? isLoading = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      registrationFlow: freezed == registrationFlow
          ? _value.registrationFlow
          : registrationFlow // ignore: cast_nullable_to_non_nullable
              as RegistrationFlow?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RegistrationStateCopyWith<$Res>
    implements $RegistrationStateCopyWith<$Res> {
  factory _$$_RegistrationStateCopyWith(_$_RegistrationState value,
          $Res Function(_$_RegistrationState) then) =
      __$$_RegistrationStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RegistrationFlow? registrationFlow, bool isLoading, String? message});
}

/// @nodoc
class __$$_RegistrationStateCopyWithImpl<$Res>
    extends _$RegistrationStateCopyWithImpl<$Res, _$_RegistrationState>
    implements _$$_RegistrationStateCopyWith<$Res> {
  __$$_RegistrationStateCopyWithImpl(
      _$_RegistrationState _value, $Res Function(_$_RegistrationState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registrationFlow = freezed,
    Object? isLoading = null,
    Object? message = freezed,
  }) {
    return _then(_$_RegistrationState(
      registrationFlow: freezed == registrationFlow
          ? _value.registrationFlow
          : registrationFlow // ignore: cast_nullable_to_non_nullable
              as RegistrationFlow?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_RegistrationState implements _RegistrationState {
  const _$_RegistrationState(
      {this.registrationFlow, this.isLoading = false, this.message});

  @override
  final RegistrationFlow? registrationFlow;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? message;

  @override
  String toString() {
    return 'RegistrationState(registrationFlow: $registrationFlow, isLoading: $isLoading, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegistrationState &&
            (identical(other.registrationFlow, registrationFlow) ||
                other.registrationFlow == registrationFlow) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, registrationFlow, isLoading, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RegistrationStateCopyWith<_$_RegistrationState> get copyWith =>
      __$$_RegistrationStateCopyWithImpl<_$_RegistrationState>(
          this, _$identity);
}

abstract class _RegistrationState implements RegistrationState {
  const factory _RegistrationState(
      {final RegistrationFlow? registrationFlow,
      final bool isLoading,
      final String? message}) = _$_RegistrationState;

  @override
  RegistrationFlow? get registrationFlow;
  @override
  bool get isLoading;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_RegistrationStateCopyWith<_$_RegistrationState> get copyWith =>
      throw _privateConstructorUsedError;
}
