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
  String? get flowId => throw _privateConstructorUsedError;
  FormField<String> get email => throw _privateConstructorUsedError;
  FormField<String> get password => throw _privateConstructorUsedError;
  bool get isPasswordHidden => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

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
      {String? flowId,
      FormField<String> email,
      FormField<String> password,
      bool isPasswordHidden,
      bool isLoading,
      String? errorMessage});

  $FormFieldCopyWith<String, $Res> get email;
  $FormFieldCopyWith<String, $Res> get password;
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
    Object? flowId = freezed,
    Object? email = null,
    Object? password = null,
    Object? isPasswordHidden = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      flowId: freezed == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as FormField<String>,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as FormField<String>,
      isPasswordHidden: null == isPasswordHidden
          ? _value.isPasswordHidden
          : isPasswordHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FormFieldCopyWith<String, $Res> get email {
    return $FormFieldCopyWith<String, $Res>(_value.email, (value) {
      return _then(_value.copyWith(email: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FormFieldCopyWith<String, $Res> get password {
    return $FormFieldCopyWith<String, $Res>(_value.password, (value) {
      return _then(_value.copyWith(password: value) as $Val);
    });
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
      {String? flowId,
      FormField<String> email,
      FormField<String> password,
      bool isPasswordHidden,
      bool isLoading,
      String? errorMessage});

  @override
  $FormFieldCopyWith<String, $Res> get email;
  @override
  $FormFieldCopyWith<String, $Res> get password;
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
    Object? flowId = freezed,
    Object? email = null,
    Object? password = null,
    Object? isPasswordHidden = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$_RegistrationState(
      flowId: freezed == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as FormField<String>,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as FormField<String>,
      isPasswordHidden: null == isPasswordHidden
          ? _value.isPasswordHidden
          : isPasswordHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_RegistrationState implements _RegistrationState {
  const _$_RegistrationState(
      {this.flowId,
      this.email = const FormField<String>(value: ''),
      this.password = const FormField<String>(value: ''),
      this.isPasswordHidden = true,
      this.isLoading = false,
      this.errorMessage});

  @override
  final String? flowId;
  @override
  @JsonKey()
  final FormField<String> email;
  @override
  @JsonKey()
  final FormField<String> password;
  @override
  @JsonKey()
  final bool isPasswordHidden;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RegistrationState(flowId: $flowId, email: $email, password: $password, isPasswordHidden: $isPasswordHidden, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RegistrationState &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.isPasswordHidden, isPasswordHidden) ||
                other.isPasswordHidden == isPasswordHidden) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, flowId, email, password,
      isPasswordHidden, isLoading, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RegistrationStateCopyWith<_$_RegistrationState> get copyWith =>
      __$$_RegistrationStateCopyWithImpl<_$_RegistrationState>(
          this, _$identity);
}

abstract class _RegistrationState implements RegistrationState {
  const factory _RegistrationState(
      {final String? flowId,
      final FormField<String> email,
      final FormField<String> password,
      final bool isPasswordHidden,
      final bool isLoading,
      final String? errorMessage}) = _$_RegistrationState;

  @override
  String? get flowId;
  @override
  FormField<String> get email;
  @override
  FormField<String> get password;
  @override
  bool get isPasswordHidden;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$_RegistrationStateCopyWith<_$_RegistrationState> get copyWith =>
      throw _privateConstructorUsedError;
}
