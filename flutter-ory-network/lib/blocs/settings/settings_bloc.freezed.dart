// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SettingsState {
  SettingsFlow? get settingsFlow => throw _privateConstructorUsedError;
  bool get isPasswordHidden => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSessionRefreshRequired => throw _privateConstructorUsedError;
  NodeMessage? get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) then) =
      _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call(
      {SettingsFlow? settingsFlow,
      bool isPasswordHidden,
      bool isLoading,
      bool isSessionRefreshRequired,
      NodeMessage? message});

  $NodeMessageCopyWith<$Res>? get message;
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settingsFlow = freezed,
    Object? isPasswordHidden = null,
    Object? isLoading = null,
    Object? isSessionRefreshRequired = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      settingsFlow: freezed == settingsFlow
          ? _value.settingsFlow
          : settingsFlow // ignore: cast_nullable_to_non_nullable
              as SettingsFlow?,
      isPasswordHidden: null == isPasswordHidden
          ? _value.isPasswordHidden
          : isPasswordHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSessionRefreshRequired: null == isSessionRefreshRequired
          ? _value.isSessionRefreshRequired
          : isSessionRefreshRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as NodeMessage?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NodeMessageCopyWith<$Res>? get message {
    if (_value.message == null) {
      return null;
    }

    return $NodeMessageCopyWith<$Res>(_value.message!, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SettingsStateCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$_SettingsStateCopyWith(
          _$_SettingsState value, $Res Function(_$_SettingsState) then) =
      __$$_SettingsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SettingsFlow? settingsFlow,
      bool isPasswordHidden,
      bool isLoading,
      bool isSessionRefreshRequired,
      NodeMessage? message});

  @override
  $NodeMessageCopyWith<$Res>? get message;
}

/// @nodoc
class __$$_SettingsStateCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$_SettingsState>
    implements _$$_SettingsStateCopyWith<$Res> {
  __$$_SettingsStateCopyWithImpl(
      _$_SettingsState _value, $Res Function(_$_SettingsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settingsFlow = freezed,
    Object? isPasswordHidden = null,
    Object? isLoading = null,
    Object? isSessionRefreshRequired = null,
    Object? message = freezed,
  }) {
    return _then(_$_SettingsState(
      settingsFlow: freezed == settingsFlow
          ? _value.settingsFlow
          : settingsFlow // ignore: cast_nullable_to_non_nullable
              as SettingsFlow?,
      isPasswordHidden: null == isPasswordHidden
          ? _value.isPasswordHidden
          : isPasswordHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSessionRefreshRequired: null == isSessionRefreshRequired
          ? _value.isSessionRefreshRequired
          : isSessionRefreshRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as NodeMessage?,
    ));
  }
}

/// @nodoc

class _$_SettingsState implements _SettingsState {
  const _$_SettingsState(
      {this.settingsFlow,
      this.isPasswordHidden = true,
      this.isLoading = false,
      this.isSessionRefreshRequired = false,
      this.message});

  @override
  final SettingsFlow? settingsFlow;
  @override
  @JsonKey()
  final bool isPasswordHidden;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSessionRefreshRequired;
  @override
  final NodeMessage? message;

  @override
  String toString() {
    return 'SettingsState(settingsFlow: $settingsFlow, isPasswordHidden: $isPasswordHidden, isLoading: $isLoading, isSessionRefreshRequired: $isSessionRefreshRequired, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SettingsState &&
            (identical(other.settingsFlow, settingsFlow) ||
                other.settingsFlow == settingsFlow) &&
            (identical(other.isPasswordHidden, isPasswordHidden) ||
                other.isPasswordHidden == isPasswordHidden) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(
                    other.isSessionRefreshRequired, isSessionRefreshRequired) ||
                other.isSessionRefreshRequired == isSessionRefreshRequired) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settingsFlow, isPasswordHidden,
      isLoading, isSessionRefreshRequired, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingsStateCopyWith<_$_SettingsState> get copyWith =>
      __$$_SettingsStateCopyWithImpl<_$_SettingsState>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState(
      {final SettingsFlow? settingsFlow,
      final bool isPasswordHidden,
      final bool isLoading,
      final bool isSessionRefreshRequired,
      final NodeMessage? message}) = _$_SettingsState;

  @override
  SettingsFlow? get settingsFlow;
  @override
  bool get isPasswordHidden;
  @override
  bool get isLoading;
  @override
  bool get isSessionRefreshRequired;
  @override
  NodeMessage? get message;
  @override
  @JsonKey(ignore: true)
  _$$_SettingsStateCopyWith<_$_SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}
