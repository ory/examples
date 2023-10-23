// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CustomException<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T flow) badRequest,
    required TResult Function() unauthorized,
    required TResult Function(String flowId, String? message) flowExpired,
    required TResult Function(Session? session) twoFactorAuthRequired,
    required TResult Function(String url) locationChangeRequired,
    required TResult Function(String? message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T flow)? badRequest,
    TResult? Function()? unauthorized,
    TResult? Function(String flowId, String? message)? flowExpired,
    TResult? Function(Session? session)? twoFactorAuthRequired,
    TResult? Function(String url)? locationChangeRequired,
    TResult? Function(String? message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T flow)? badRequest,
    TResult Function()? unauthorized,
    TResult Function(String flowId, String? message)? flowExpired,
    TResult Function(Session? session)? twoFactorAuthRequired,
    TResult Function(String url)? locationChangeRequired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException<T> value) badRequest,
    required TResult Function(UnauthorizedException<T> value) unauthorized,
    required TResult Function(FlowExpiredException<T> value) flowExpired,
    required TResult Function(TwoFactorAuthRequiredException<T> value)
        twoFactorAuthRequired,
    required TResult Function(LocationChangeRequiredException<T> value)
        locationChangeRequired,
    required TResult Function(UnknownException<T> value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException<T> value)? badRequest,
    TResult? Function(UnauthorizedException<T> value)? unauthorized,
    TResult? Function(FlowExpiredException<T> value)? flowExpired,
    TResult? Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult? Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult? Function(UnknownException<T> value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException<T> value)? badRequest,
    TResult Function(UnauthorizedException<T> value)? unauthorized,
    TResult Function(FlowExpiredException<T> value)? flowExpired,
    TResult Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult Function(UnknownException<T> value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomExceptionCopyWith<T, $Res> {
  factory $CustomExceptionCopyWith(
          CustomException<T> value, $Res Function(CustomException<T>) then) =
      _$CustomExceptionCopyWithImpl<T, $Res, CustomException<T>>;
}

/// @nodoc
class _$CustomExceptionCopyWithImpl<T, $Res, $Val extends CustomException<T>>
    implements $CustomExceptionCopyWith<T, $Res> {
  _$CustomExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BadRequestExceptionCopyWith<T, $Res> {
  factory _$$BadRequestExceptionCopyWith(_$BadRequestException<T> value,
          $Res Function(_$BadRequestException<T>) then) =
      __$$BadRequestExceptionCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T flow});
}

/// @nodoc
class __$$BadRequestExceptionCopyWithImpl<T, $Res>
    extends _$CustomExceptionCopyWithImpl<T, $Res, _$BadRequestException<T>>
    implements _$$BadRequestExceptionCopyWith<T, $Res> {
  __$$BadRequestExceptionCopyWithImpl(_$BadRequestException<T> _value,
      $Res Function(_$BadRequestException<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flow = freezed,
  }) {
    return _then(_$BadRequestException<T>(
      flow: freezed == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$BadRequestException<T> extends BadRequestException<T>
    with DiagnosticableTreeMixin {
  const _$BadRequestException({required this.flow}) : super._();

  @override
  final T flow;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException<$T>.badRequest(flow: $flow)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CustomException<$T>.badRequest'))
      ..add(DiagnosticsProperty('flow', flow));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadRequestException<T> &&
            const DeepCollectionEquality().equals(other.flow, flow));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(flow));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BadRequestExceptionCopyWith<T, _$BadRequestException<T>> get copyWith =>
      __$$BadRequestExceptionCopyWithImpl<T, _$BadRequestException<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T flow) badRequest,
    required TResult Function() unauthorized,
    required TResult Function(String flowId, String? message) flowExpired,
    required TResult Function(Session? session) twoFactorAuthRequired,
    required TResult Function(String url) locationChangeRequired,
    required TResult Function(String? message) unknown,
  }) {
    return badRequest(flow);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T flow)? badRequest,
    TResult? Function()? unauthorized,
    TResult? Function(String flowId, String? message)? flowExpired,
    TResult? Function(Session? session)? twoFactorAuthRequired,
    TResult? Function(String url)? locationChangeRequired,
    TResult? Function(String? message)? unknown,
  }) {
    return badRequest?.call(flow);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T flow)? badRequest,
    TResult Function()? unauthorized,
    TResult Function(String flowId, String? message)? flowExpired,
    TResult Function(Session? session)? twoFactorAuthRequired,
    TResult Function(String url)? locationChangeRequired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(flow);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException<T> value) badRequest,
    required TResult Function(UnauthorizedException<T> value) unauthorized,
    required TResult Function(FlowExpiredException<T> value) flowExpired,
    required TResult Function(TwoFactorAuthRequiredException<T> value)
        twoFactorAuthRequired,
    required TResult Function(LocationChangeRequiredException<T> value)
        locationChangeRequired,
    required TResult Function(UnknownException<T> value) unknown,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException<T> value)? badRequest,
    TResult? Function(UnauthorizedException<T> value)? unauthorized,
    TResult? Function(FlowExpiredException<T> value)? flowExpired,
    TResult? Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult? Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult? Function(UnknownException<T> value)? unknown,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException<T> value)? badRequest,
    TResult Function(UnauthorizedException<T> value)? unauthorized,
    TResult Function(FlowExpiredException<T> value)? flowExpired,
    TResult Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult Function(UnknownException<T> value)? unknown,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class BadRequestException<T> extends CustomException<T> {
  const factory BadRequestException({required final T flow}) =
      _$BadRequestException<T>;
  const BadRequestException._() : super._();

  T get flow;
  @JsonKey(ignore: true)
  _$$BadRequestExceptionCopyWith<T, _$BadRequestException<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedExceptionCopyWith<T, $Res> {
  factory _$$UnauthorizedExceptionCopyWith(_$UnauthorizedException<T> value,
          $Res Function(_$UnauthorizedException<T>) then) =
      __$$UnauthorizedExceptionCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$UnauthorizedExceptionCopyWithImpl<T, $Res>
    extends _$CustomExceptionCopyWithImpl<T, $Res, _$UnauthorizedException<T>>
    implements _$$UnauthorizedExceptionCopyWith<T, $Res> {
  __$$UnauthorizedExceptionCopyWithImpl(_$UnauthorizedException<T> _value,
      $Res Function(_$UnauthorizedException<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UnauthorizedException<T> extends UnauthorizedException<T>
    with DiagnosticableTreeMixin {
  const _$UnauthorizedException() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException<$T>.unauthorized()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('type', 'CustomException<$T>.unauthorized'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedException<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T flow) badRequest,
    required TResult Function() unauthorized,
    required TResult Function(String flowId, String? message) flowExpired,
    required TResult Function(Session? session) twoFactorAuthRequired,
    required TResult Function(String url) locationChangeRequired,
    required TResult Function(String? message) unknown,
  }) {
    return unauthorized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T flow)? badRequest,
    TResult? Function()? unauthorized,
    TResult? Function(String flowId, String? message)? flowExpired,
    TResult? Function(Session? session)? twoFactorAuthRequired,
    TResult? Function(String url)? locationChangeRequired,
    TResult? Function(String? message)? unknown,
  }) {
    return unauthorized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T flow)? badRequest,
    TResult Function()? unauthorized,
    TResult Function(String flowId, String? message)? flowExpired,
    TResult Function(Session? session)? twoFactorAuthRequired,
    TResult Function(String url)? locationChangeRequired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException<T> value) badRequest,
    required TResult Function(UnauthorizedException<T> value) unauthorized,
    required TResult Function(FlowExpiredException<T> value) flowExpired,
    required TResult Function(TwoFactorAuthRequiredException<T> value)
        twoFactorAuthRequired,
    required TResult Function(LocationChangeRequiredException<T> value)
        locationChangeRequired,
    required TResult Function(UnknownException<T> value) unknown,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException<T> value)? badRequest,
    TResult? Function(UnauthorizedException<T> value)? unauthorized,
    TResult? Function(FlowExpiredException<T> value)? flowExpired,
    TResult? Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult? Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult? Function(UnknownException<T> value)? unknown,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException<T> value)? badRequest,
    TResult Function(UnauthorizedException<T> value)? unauthorized,
    TResult Function(FlowExpiredException<T> value)? flowExpired,
    TResult Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult Function(UnknownException<T> value)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedException<T> extends CustomException<T> {
  const factory UnauthorizedException() = _$UnauthorizedException<T>;
  const UnauthorizedException._() : super._();
}

/// @nodoc
abstract class _$$FlowExpiredExceptionCopyWith<T, $Res> {
  factory _$$FlowExpiredExceptionCopyWith(_$FlowExpiredException<T> value,
          $Res Function(_$FlowExpiredException<T>) then) =
      __$$FlowExpiredExceptionCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String flowId, String? message});
}

/// @nodoc
class __$$FlowExpiredExceptionCopyWithImpl<T, $Res>
    extends _$CustomExceptionCopyWithImpl<T, $Res, _$FlowExpiredException<T>>
    implements _$$FlowExpiredExceptionCopyWith<T, $Res> {
  __$$FlowExpiredExceptionCopyWithImpl(_$FlowExpiredException<T> _value,
      $Res Function(_$FlowExpiredException<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowId = null,
    Object? message = freezed,
  }) {
    return _then(_$FlowExpiredException<T>(
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FlowExpiredException<T> extends FlowExpiredException<T>
    with DiagnosticableTreeMixin {
  const _$FlowExpiredException({required this.flowId, this.message})
      : super._();

  @override
  final String flowId;
  @override
  final String? message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException<$T>.flowExpired(flowId: $flowId, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CustomException<$T>.flowExpired'))
      ..add(DiagnosticsProperty('flowId', flowId))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlowExpiredException<T> &&
            (identical(other.flowId, flowId) || other.flowId == flowId) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, flowId, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FlowExpiredExceptionCopyWith<T, _$FlowExpiredException<T>> get copyWith =>
      __$$FlowExpiredExceptionCopyWithImpl<T, _$FlowExpiredException<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T flow) badRequest,
    required TResult Function() unauthorized,
    required TResult Function(String flowId, String? message) flowExpired,
    required TResult Function(Session? session) twoFactorAuthRequired,
    required TResult Function(String url) locationChangeRequired,
    required TResult Function(String? message) unknown,
  }) {
    return flowExpired(flowId, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T flow)? badRequest,
    TResult? Function()? unauthorized,
    TResult? Function(String flowId, String? message)? flowExpired,
    TResult? Function(Session? session)? twoFactorAuthRequired,
    TResult? Function(String url)? locationChangeRequired,
    TResult? Function(String? message)? unknown,
  }) {
    return flowExpired?.call(flowId, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T flow)? badRequest,
    TResult Function()? unauthorized,
    TResult Function(String flowId, String? message)? flowExpired,
    TResult Function(Session? session)? twoFactorAuthRequired,
    TResult Function(String url)? locationChangeRequired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (flowExpired != null) {
      return flowExpired(flowId, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException<T> value) badRequest,
    required TResult Function(UnauthorizedException<T> value) unauthorized,
    required TResult Function(FlowExpiredException<T> value) flowExpired,
    required TResult Function(TwoFactorAuthRequiredException<T> value)
        twoFactorAuthRequired,
    required TResult Function(LocationChangeRequiredException<T> value)
        locationChangeRequired,
    required TResult Function(UnknownException<T> value) unknown,
  }) {
    return flowExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException<T> value)? badRequest,
    TResult? Function(UnauthorizedException<T> value)? unauthorized,
    TResult? Function(FlowExpiredException<T> value)? flowExpired,
    TResult? Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult? Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult? Function(UnknownException<T> value)? unknown,
  }) {
    return flowExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException<T> value)? badRequest,
    TResult Function(UnauthorizedException<T> value)? unauthorized,
    TResult Function(FlowExpiredException<T> value)? flowExpired,
    TResult Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult Function(UnknownException<T> value)? unknown,
    required TResult orElse(),
  }) {
    if (flowExpired != null) {
      return flowExpired(this);
    }
    return orElse();
  }
}

abstract class FlowExpiredException<T> extends CustomException<T> {
  const factory FlowExpiredException(
      {required final String flowId,
      final String? message}) = _$FlowExpiredException<T>;
  const FlowExpiredException._() : super._();

  String get flowId;
  String? get message;
  @JsonKey(ignore: true)
  _$$FlowExpiredExceptionCopyWith<T, _$FlowExpiredException<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TwoFactorAuthRequiredExceptionCopyWith<T, $Res> {
  factory _$$TwoFactorAuthRequiredExceptionCopyWith(
          _$TwoFactorAuthRequiredException<T> value,
          $Res Function(_$TwoFactorAuthRequiredException<T>) then) =
      __$$TwoFactorAuthRequiredExceptionCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Session? session});
}

/// @nodoc
class __$$TwoFactorAuthRequiredExceptionCopyWithImpl<T, $Res>
    extends _$CustomExceptionCopyWithImpl<T, $Res,
        _$TwoFactorAuthRequiredException<T>>
    implements _$$TwoFactorAuthRequiredExceptionCopyWith<T, $Res> {
  __$$TwoFactorAuthRequiredExceptionCopyWithImpl(
      _$TwoFactorAuthRequiredException<T> _value,
      $Res Function(_$TwoFactorAuthRequiredException<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = freezed,
  }) {
    return _then(_$TwoFactorAuthRequiredException<T>(
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session?,
    ));
  }
}

/// @nodoc

class _$TwoFactorAuthRequiredException<T>
    extends TwoFactorAuthRequiredException<T> with DiagnosticableTreeMixin {
  const _$TwoFactorAuthRequiredException({this.session}) : super._();

  @override
  final Session? session;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException<$T>.twoFactorAuthRequired(session: $session)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'CustomException<$T>.twoFactorAuthRequired'))
      ..add(DiagnosticsProperty('session', session));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwoFactorAuthRequiredException<T> &&
            (identical(other.session, session) || other.session == session));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TwoFactorAuthRequiredExceptionCopyWith<T,
          _$TwoFactorAuthRequiredException<T>>
      get copyWith => __$$TwoFactorAuthRequiredExceptionCopyWithImpl<T,
          _$TwoFactorAuthRequiredException<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T flow) badRequest,
    required TResult Function() unauthorized,
    required TResult Function(String flowId, String? message) flowExpired,
    required TResult Function(Session? session) twoFactorAuthRequired,
    required TResult Function(String url) locationChangeRequired,
    required TResult Function(String? message) unknown,
  }) {
    return twoFactorAuthRequired(session);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T flow)? badRequest,
    TResult? Function()? unauthorized,
    TResult? Function(String flowId, String? message)? flowExpired,
    TResult? Function(Session? session)? twoFactorAuthRequired,
    TResult? Function(String url)? locationChangeRequired,
    TResult? Function(String? message)? unknown,
  }) {
    return twoFactorAuthRequired?.call(session);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T flow)? badRequest,
    TResult Function()? unauthorized,
    TResult Function(String flowId, String? message)? flowExpired,
    TResult Function(Session? session)? twoFactorAuthRequired,
    TResult Function(String url)? locationChangeRequired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (twoFactorAuthRequired != null) {
      return twoFactorAuthRequired(session);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException<T> value) badRequest,
    required TResult Function(UnauthorizedException<T> value) unauthorized,
    required TResult Function(FlowExpiredException<T> value) flowExpired,
    required TResult Function(TwoFactorAuthRequiredException<T> value)
        twoFactorAuthRequired,
    required TResult Function(LocationChangeRequiredException<T> value)
        locationChangeRequired,
    required TResult Function(UnknownException<T> value) unknown,
  }) {
    return twoFactorAuthRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException<T> value)? badRequest,
    TResult? Function(UnauthorizedException<T> value)? unauthorized,
    TResult? Function(FlowExpiredException<T> value)? flowExpired,
    TResult? Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult? Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult? Function(UnknownException<T> value)? unknown,
  }) {
    return twoFactorAuthRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException<T> value)? badRequest,
    TResult Function(UnauthorizedException<T> value)? unauthorized,
    TResult Function(FlowExpiredException<T> value)? flowExpired,
    TResult Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult Function(UnknownException<T> value)? unknown,
    required TResult orElse(),
  }) {
    if (twoFactorAuthRequired != null) {
      return twoFactorAuthRequired(this);
    }
    return orElse();
  }
}

abstract class TwoFactorAuthRequiredException<T> extends CustomException<T> {
  const factory TwoFactorAuthRequiredException({final Session? session}) =
      _$TwoFactorAuthRequiredException<T>;
  const TwoFactorAuthRequiredException._() : super._();

  Session? get session;
  @JsonKey(ignore: true)
  _$$TwoFactorAuthRequiredExceptionCopyWith<T,
          _$TwoFactorAuthRequiredException<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LocationChangeRequiredExceptionCopyWith<T, $Res> {
  factory _$$LocationChangeRequiredExceptionCopyWith(
          _$LocationChangeRequiredException<T> value,
          $Res Function(_$LocationChangeRequiredException<T>) then) =
      __$$LocationChangeRequiredExceptionCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String url});
}

/// @nodoc
class __$$LocationChangeRequiredExceptionCopyWithImpl<T, $Res>
    extends _$CustomExceptionCopyWithImpl<T, $Res,
        _$LocationChangeRequiredException<T>>
    implements _$$LocationChangeRequiredExceptionCopyWith<T, $Res> {
  __$$LocationChangeRequiredExceptionCopyWithImpl(
      _$LocationChangeRequiredException<T> _value,
      $Res Function(_$LocationChangeRequiredException<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
  }) {
    return _then(_$LocationChangeRequiredException<T>(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LocationChangeRequiredException<T>
    extends LocationChangeRequiredException<T> with DiagnosticableTreeMixin {
  const _$LocationChangeRequiredException({required this.url}) : super._();

  @override
  final String url;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException<$T>.locationChangeRequired(url: $url)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'CustomException<$T>.locationChangeRequired'))
      ..add(DiagnosticsProperty('url', url));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationChangeRequiredException<T> &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationChangeRequiredExceptionCopyWith<T,
          _$LocationChangeRequiredException<T>>
      get copyWith => __$$LocationChangeRequiredExceptionCopyWithImpl<T,
          _$LocationChangeRequiredException<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T flow) badRequest,
    required TResult Function() unauthorized,
    required TResult Function(String flowId, String? message) flowExpired,
    required TResult Function(Session? session) twoFactorAuthRequired,
    required TResult Function(String url) locationChangeRequired,
    required TResult Function(String? message) unknown,
  }) {
    return locationChangeRequired(url);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T flow)? badRequest,
    TResult? Function()? unauthorized,
    TResult? Function(String flowId, String? message)? flowExpired,
    TResult? Function(Session? session)? twoFactorAuthRequired,
    TResult? Function(String url)? locationChangeRequired,
    TResult? Function(String? message)? unknown,
  }) {
    return locationChangeRequired?.call(url);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T flow)? badRequest,
    TResult Function()? unauthorized,
    TResult Function(String flowId, String? message)? flowExpired,
    TResult Function(Session? session)? twoFactorAuthRequired,
    TResult Function(String url)? locationChangeRequired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (locationChangeRequired != null) {
      return locationChangeRequired(url);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException<T> value) badRequest,
    required TResult Function(UnauthorizedException<T> value) unauthorized,
    required TResult Function(FlowExpiredException<T> value) flowExpired,
    required TResult Function(TwoFactorAuthRequiredException<T> value)
        twoFactorAuthRequired,
    required TResult Function(LocationChangeRequiredException<T> value)
        locationChangeRequired,
    required TResult Function(UnknownException<T> value) unknown,
  }) {
    return locationChangeRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException<T> value)? badRequest,
    TResult? Function(UnauthorizedException<T> value)? unauthorized,
    TResult? Function(FlowExpiredException<T> value)? flowExpired,
    TResult? Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult? Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult? Function(UnknownException<T> value)? unknown,
  }) {
    return locationChangeRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException<T> value)? badRequest,
    TResult Function(UnauthorizedException<T> value)? unauthorized,
    TResult Function(FlowExpiredException<T> value)? flowExpired,
    TResult Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult Function(UnknownException<T> value)? unknown,
    required TResult orElse(),
  }) {
    if (locationChangeRequired != null) {
      return locationChangeRequired(this);
    }
    return orElse();
  }
}

abstract class LocationChangeRequiredException<T> extends CustomException<T> {
  const factory LocationChangeRequiredException({required final String url}) =
      _$LocationChangeRequiredException<T>;
  const LocationChangeRequiredException._() : super._();

  String get url;
  @JsonKey(ignore: true)
  _$$LocationChangeRequiredExceptionCopyWith<T,
          _$LocationChangeRequiredException<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownExceptionCopyWith<T, $Res> {
  factory _$$UnknownExceptionCopyWith(_$UnknownException<T> value,
          $Res Function(_$UnknownException<T>) then) =
      __$$UnknownExceptionCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$UnknownExceptionCopyWithImpl<T, $Res>
    extends _$CustomExceptionCopyWithImpl<T, $Res, _$UnknownException<T>>
    implements _$$UnknownExceptionCopyWith<T, $Res> {
  __$$UnknownExceptionCopyWithImpl(
      _$UnknownException<T> _value, $Res Function(_$UnknownException<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$UnknownException<T>(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnknownException<T> extends UnknownException<T>
    with DiagnosticableTreeMixin {
  const _$UnknownException(
      {this.message = 'An error occured. Please try again later.'})
      : super._();

  @override
  @JsonKey()
  final String? message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException<$T>.unknown(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CustomException<$T>.unknown'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownException<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownExceptionCopyWith<T, _$UnknownException<T>> get copyWith =>
      __$$UnknownExceptionCopyWithImpl<T, _$UnknownException<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T flow) badRequest,
    required TResult Function() unauthorized,
    required TResult Function(String flowId, String? message) flowExpired,
    required TResult Function(Session? session) twoFactorAuthRequired,
    required TResult Function(String url) locationChangeRequired,
    required TResult Function(String? message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T flow)? badRequest,
    TResult? Function()? unauthorized,
    TResult? Function(String flowId, String? message)? flowExpired,
    TResult? Function(Session? session)? twoFactorAuthRequired,
    TResult? Function(String url)? locationChangeRequired,
    TResult? Function(String? message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T flow)? badRequest,
    TResult Function()? unauthorized,
    TResult Function(String flowId, String? message)? flowExpired,
    TResult Function(Session? session)? twoFactorAuthRequired,
    TResult Function(String url)? locationChangeRequired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException<T> value) badRequest,
    required TResult Function(UnauthorizedException<T> value) unauthorized,
    required TResult Function(FlowExpiredException<T> value) flowExpired,
    required TResult Function(TwoFactorAuthRequiredException<T> value)
        twoFactorAuthRequired,
    required TResult Function(LocationChangeRequiredException<T> value)
        locationChangeRequired,
    required TResult Function(UnknownException<T> value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException<T> value)? badRequest,
    TResult? Function(UnauthorizedException<T> value)? unauthorized,
    TResult? Function(FlowExpiredException<T> value)? flowExpired,
    TResult? Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult? Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult? Function(UnknownException<T> value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException<T> value)? badRequest,
    TResult Function(UnauthorizedException<T> value)? unauthorized,
    TResult Function(FlowExpiredException<T> value)? flowExpired,
    TResult Function(TwoFactorAuthRequiredException<T> value)?
        twoFactorAuthRequired,
    TResult Function(LocationChangeRequiredException<T> value)?
        locationChangeRequired,
    TResult Function(UnknownException<T> value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownException<T> extends CustomException<T> {
  const factory UnknownException({final String? message}) =
      _$UnknownException<T>;
  const UnknownException._() : super._();

  String? get message;
  @JsonKey(ignore: true)
  _$$UnknownExceptionCopyWith<T, _$UnknownException<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
