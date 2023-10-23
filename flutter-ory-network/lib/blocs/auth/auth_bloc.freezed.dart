// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthState {
  AuthStatus get status => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        uninitialized,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        unauthenticated,
    required TResult Function(AuthStatus status, Session session,
            bool isLoading, String? errorMessage)
        authenticated,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        aal2Requested,
    required TResult Function(
            AuthStatus status, String url, bool isLoading, String? errorMessage)
        locationChangeRequired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult? Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult? Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(Aal2Requested value) aal2Requested,
    required TResult Function(LocationChangeRequired value)
        locationChangeRequired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(Aal2Requested value)? aal2Requested,
    TResult? Function(LocationChangeRequired value)? locationChangeRequired,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(Aal2Requested value)? aal2Requested,
    TResult Function(LocationChangeRequired value)? locationChangeRequired,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({AuthStatus status, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
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
}

/// @nodoc
abstract class _$$AuthUninitializedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthUninitializedCopyWith(
          _$AuthUninitialized value, $Res Function(_$AuthUninitialized) then) =
      __$$AuthUninitializedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthStatus status, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$AuthUninitializedCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUninitialized>
    implements _$$AuthUninitializedCopyWith<$Res> {
  __$$AuthUninitializedCopyWithImpl(
      _$AuthUninitialized _value, $Res Function(_$AuthUninitialized) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$AuthUninitialized(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
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

class _$AuthUninitialized implements AuthUninitialized {
  const _$AuthUninitialized(
      {this.status = AuthStatus.uninitialized,
      this.isLoading = false,
      this.errorMessage});

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AuthState.uninitialized(status: $status, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUninitialized &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, isLoading, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUninitializedCopyWith<_$AuthUninitialized> get copyWith =>
      __$$AuthUninitializedCopyWithImpl<_$AuthUninitialized>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        uninitialized,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        unauthenticated,
    required TResult Function(AuthStatus status, Session session,
            bool isLoading, String? errorMessage)
        authenticated,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        aal2Requested,
    required TResult Function(
            AuthStatus status, String url, bool isLoading, String? errorMessage)
        locationChangeRequired,
  }) {
    return uninitialized(status, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult? Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult? Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
  }) {
    return uninitialized?.call(status, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
    required TResult orElse(),
  }) {
    if (uninitialized != null) {
      return uninitialized(status, isLoading, errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(Aal2Requested value) aal2Requested,
    required TResult Function(LocationChangeRequired value)
        locationChangeRequired,
  }) {
    return uninitialized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(Aal2Requested value)? aal2Requested,
    TResult? Function(LocationChangeRequired value)? locationChangeRequired,
  }) {
    return uninitialized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(Aal2Requested value)? aal2Requested,
    TResult Function(LocationChangeRequired value)? locationChangeRequired,
    required TResult orElse(),
  }) {
    if (uninitialized != null) {
      return uninitialized(this);
    }
    return orElse();
  }
}

abstract class AuthUninitialized implements AuthState {
  const factory AuthUninitialized(
      {final AuthStatus status,
      final bool isLoading,
      final String? errorMessage}) = _$AuthUninitialized;

  @override
  AuthStatus get status;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$AuthUninitializedCopyWith<_$AuthUninitialized> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUnauthenticatedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthUnauthenticatedCopyWith(_$AuthUnauthenticated value,
          $Res Function(_$AuthUnauthenticated) then) =
      __$$AuthUnauthenticatedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthStatus status, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$AuthUnauthenticatedCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUnauthenticated>
    implements _$$AuthUnauthenticatedCopyWith<$Res> {
  __$$AuthUnauthenticatedCopyWithImpl(
      _$AuthUnauthenticated _value, $Res Function(_$AuthUnauthenticated) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$AuthUnauthenticated(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
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

class _$AuthUnauthenticated implements AuthUnauthenticated {
  const _$AuthUnauthenticated(
      {this.status = AuthStatus.unauthenticated,
      this.isLoading = false,
      this.errorMessage});

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AuthState.unauthenticated(status: $status, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnauthenticated &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, isLoading, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUnauthenticatedCopyWith<_$AuthUnauthenticated> get copyWith =>
      __$$AuthUnauthenticatedCopyWithImpl<_$AuthUnauthenticated>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        uninitialized,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        unauthenticated,
    required TResult Function(AuthStatus status, Session session,
            bool isLoading, String? errorMessage)
        authenticated,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        aal2Requested,
    required TResult Function(
            AuthStatus status, String url, bool isLoading, String? errorMessage)
        locationChangeRequired,
  }) {
    return unauthenticated(status, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult? Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult? Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
  }) {
    return unauthenticated?.call(status, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(status, isLoading, errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(Aal2Requested value) aal2Requested,
    required TResult Function(LocationChangeRequired value)
        locationChangeRequired,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(Aal2Requested value)? aal2Requested,
    TResult? Function(LocationChangeRequired value)? locationChangeRequired,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(Aal2Requested value)? aal2Requested,
    TResult Function(LocationChangeRequired value)? locationChangeRequired,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class AuthUnauthenticated implements AuthState {
  const factory AuthUnauthenticated(
      {final AuthStatus status,
      final bool isLoading,
      final String? errorMessage}) = _$AuthUnauthenticated;

  @override
  AuthStatus get status;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$AuthUnauthenticatedCopyWith<_$AuthUnauthenticated> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAuthenticatedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthAuthenticatedCopyWith(
          _$AuthAuthenticated value, $Res Function(_$AuthAuthenticated) then) =
      __$$AuthAuthenticatedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthStatus status,
      Session session,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$AuthAuthenticatedCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAuthenticated>
    implements _$$AuthAuthenticatedCopyWith<$Res> {
  __$$AuthAuthenticatedCopyWithImpl(
      _$AuthAuthenticated _value, $Res Function(_$AuthAuthenticated) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? session = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$AuthAuthenticated(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
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

class _$AuthAuthenticated implements AuthAuthenticated {
  const _$AuthAuthenticated(
      {this.status = AuthStatus.authenticated,
      required this.session,
      this.isLoading = false,
      this.errorMessage});

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  final Session session;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AuthState.authenticated(status: $status, session: $session, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAuthenticated &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, session, isLoading, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAuthenticatedCopyWith<_$AuthAuthenticated> get copyWith =>
      __$$AuthAuthenticatedCopyWithImpl<_$AuthAuthenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        uninitialized,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        unauthenticated,
    required TResult Function(AuthStatus status, Session session,
            bool isLoading, String? errorMessage)
        authenticated,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        aal2Requested,
    required TResult Function(
            AuthStatus status, String url, bool isLoading, String? errorMessage)
        locationChangeRequired,
  }) {
    return authenticated(status, session, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult? Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult? Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
  }) {
    return authenticated?.call(status, session, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(status, session, isLoading, errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(Aal2Requested value) aal2Requested,
    required TResult Function(LocationChangeRequired value)
        locationChangeRequired,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(Aal2Requested value)? aal2Requested,
    TResult? Function(LocationChangeRequired value)? locationChangeRequired,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(Aal2Requested value)? aal2Requested,
    TResult Function(LocationChangeRequired value)? locationChangeRequired,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthAuthenticated implements AuthState {
  const factory AuthAuthenticated(
      {final AuthStatus status,
      required final Session session,
      final bool isLoading,
      final String? errorMessage}) = _$AuthAuthenticated;

  @override
  AuthStatus get status;
  Session get session;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$AuthAuthenticatedCopyWith<_$AuthAuthenticated> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Aal2RequestedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$Aal2RequestedCopyWith(
          _$Aal2Requested value, $Res Function(_$Aal2Requested) then) =
      __$$Aal2RequestedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthStatus status, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$Aal2RequestedCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$Aal2Requested>
    implements _$$Aal2RequestedCopyWith<$Res> {
  __$$Aal2RequestedCopyWithImpl(
      _$Aal2Requested _value, $Res Function(_$Aal2Requested) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$Aal2Requested(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
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

class _$Aal2Requested implements Aal2Requested {
  const _$Aal2Requested(
      {this.status = AuthStatus.aal2Requested,
      this.isLoading = false,
      this.errorMessage});

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AuthState.aal2Requested(status: $status, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Aal2Requested &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, isLoading, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Aal2RequestedCopyWith<_$Aal2Requested> get copyWith =>
      __$$Aal2RequestedCopyWithImpl<_$Aal2Requested>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        uninitialized,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        unauthenticated,
    required TResult Function(AuthStatus status, Session session,
            bool isLoading, String? errorMessage)
        authenticated,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        aal2Requested,
    required TResult Function(
            AuthStatus status, String url, bool isLoading, String? errorMessage)
        locationChangeRequired,
  }) {
    return aal2Requested(status, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult? Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult? Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
  }) {
    return aal2Requested?.call(status, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
    required TResult orElse(),
  }) {
    if (aal2Requested != null) {
      return aal2Requested(status, isLoading, errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(Aal2Requested value) aal2Requested,
    required TResult Function(LocationChangeRequired value)
        locationChangeRequired,
  }) {
    return aal2Requested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(Aal2Requested value)? aal2Requested,
    TResult? Function(LocationChangeRequired value)? locationChangeRequired,
  }) {
    return aal2Requested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(Aal2Requested value)? aal2Requested,
    TResult Function(LocationChangeRequired value)? locationChangeRequired,
    required TResult orElse(),
  }) {
    if (aal2Requested != null) {
      return aal2Requested(this);
    }
    return orElse();
  }
}

abstract class Aal2Requested implements AuthState {
  const factory Aal2Requested(
      {final AuthStatus status,
      final bool isLoading,
      final String? errorMessage}) = _$Aal2Requested;

  @override
  AuthStatus get status;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$Aal2RequestedCopyWith<_$Aal2Requested> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LocationChangeRequiredCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$LocationChangeRequiredCopyWith(_$LocationChangeRequired value,
          $Res Function(_$LocationChangeRequired) then) =
      __$$LocationChangeRequiredCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthStatus status, String url, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$LocationChangeRequiredCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$LocationChangeRequired>
    implements _$$LocationChangeRequiredCopyWith<$Res> {
  __$$LocationChangeRequiredCopyWithImpl(_$LocationChangeRequired _value,
      $Res Function(_$LocationChangeRequired) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? url = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$LocationChangeRequired(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AuthStatus,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$LocationChangeRequired implements LocationChangeRequired {
  const _$LocationChangeRequired(
      {this.status = AuthStatus.locationChangeRequired,
      required this.url,
      this.isLoading = false,
      this.errorMessage});

  @override
  @JsonKey()
  final AuthStatus status;
  @override
  final String url;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AuthState.locationChangeRequired(status: $status, url: $url, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationChangeRequired &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, url, isLoading, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationChangeRequiredCopyWith<_$LocationChangeRequired> get copyWith =>
      __$$LocationChangeRequiredCopyWithImpl<_$LocationChangeRequired>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        uninitialized,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        unauthenticated,
    required TResult Function(AuthStatus status, Session session,
            bool isLoading, String? errorMessage)
        authenticated,
    required TResult Function(
            AuthStatus status, bool isLoading, String? errorMessage)
        aal2Requested,
    required TResult Function(
            AuthStatus status, String url, bool isLoading, String? errorMessage)
        locationChangeRequired,
  }) {
    return locationChangeRequired(status, url, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult? Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult? Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult? Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
  }) {
    return locationChangeRequired?.call(status, url, isLoading, errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        uninitialized,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        unauthenticated,
    TResult Function(AuthStatus status, Session session, bool isLoading,
            String? errorMessage)?
        authenticated,
    TResult Function(AuthStatus status, bool isLoading, String? errorMessage)?
        aal2Requested,
    TResult Function(AuthStatus status, String url, bool isLoading,
            String? errorMessage)?
        locationChangeRequired,
    required TResult orElse(),
  }) {
    if (locationChangeRequired != null) {
      return locationChangeRequired(status, url, isLoading, errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthUninitialized value) uninitialized,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(Aal2Requested value) aal2Requested,
    required TResult Function(LocationChangeRequired value)
        locationChangeRequired,
  }) {
    return locationChangeRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthUninitialized value)? uninitialized,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(Aal2Requested value)? aal2Requested,
    TResult? Function(LocationChangeRequired value)? locationChangeRequired,
  }) {
    return locationChangeRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthUninitialized value)? uninitialized,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(Aal2Requested value)? aal2Requested,
    TResult Function(LocationChangeRequired value)? locationChangeRequired,
    required TResult orElse(),
  }) {
    if (locationChangeRequired != null) {
      return locationChangeRequired(this);
    }
    return orElse();
  }
}

abstract class LocationChangeRequired implements AuthState {
  const factory LocationChangeRequired(
      {final AuthStatus status,
      required final String url,
      final bool isLoading,
      final String? errorMessage}) = _$LocationChangeRequired;

  @override
  AuthStatus get status;
  String get url;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$LocationChangeRequiredCopyWith<_$LocationChangeRequired> get copyWith =>
      throw _privateConstructorUsedError;
}
