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
mixin _$CustomException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<NodeMessage>? messages, int statusCode)
        badRequest,
    required TResult Function(int statusCode) unauthorized,
    required TResult Function(int statusCode, String flowId) flowExpired,
    required TResult Function(String? message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult? Function(int statusCode)? unauthorized,
    TResult? Function(int statusCode, String flowId)? flowExpired,
    TResult? Function(String? message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult Function(int statusCode)? unauthorized,
    TResult Function(int statusCode, String flowId)? flowExpired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(FlowExpiredException value) flowExpired,
    required TResult Function(UnknownException value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(FlowExpiredException value)? flowExpired,
    TResult? Function(UnknownException value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(FlowExpiredException value)? flowExpired,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomExceptionCopyWith<$Res> {
  factory $CustomExceptionCopyWith(
          CustomException value, $Res Function(CustomException) then) =
      _$CustomExceptionCopyWithImpl<$Res, CustomException>;
}

/// @nodoc
class _$CustomExceptionCopyWithImpl<$Res, $Val extends CustomException>
    implements $CustomExceptionCopyWith<$Res> {
  _$CustomExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BadRequestExceptionCopyWith<$Res> {
  factory _$$BadRequestExceptionCopyWith(_$BadRequestException value,
          $Res Function(_$BadRequestException) then) =
      __$$BadRequestExceptionCopyWithImpl<$Res>;
  @useResult
  $Res call({List<NodeMessage>? messages, int statusCode});
}

/// @nodoc
class __$$BadRequestExceptionCopyWithImpl<$Res>
    extends _$CustomExceptionCopyWithImpl<$Res, _$BadRequestException>
    implements _$$BadRequestExceptionCopyWith<$Res> {
  __$$BadRequestExceptionCopyWithImpl(
      _$BadRequestException _value, $Res Function(_$BadRequestException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = freezed,
    Object? statusCode = null,
  }) {
    return _then(_$BadRequestException(
      messages: freezed == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<NodeMessage>?,
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BadRequestException extends BadRequestException
    with DiagnosticableTreeMixin {
  const _$BadRequestException(
      {final List<NodeMessage>? messages, this.statusCode = 400})
      : _messages = messages,
        super._();

  final List<NodeMessage>? _messages;
  @override
  List<NodeMessage>? get messages {
    final value = _messages;
    if (value == null) return null;
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int statusCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException.badRequest(messages: $messages, statusCode: $statusCode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CustomException.badRequest'))
      ..add(DiagnosticsProperty('messages', messages))
      ..add(DiagnosticsProperty('statusCode', statusCode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadRequestException &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_messages), statusCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BadRequestExceptionCopyWith<_$BadRequestException> get copyWith =>
      __$$BadRequestExceptionCopyWithImpl<_$BadRequestException>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<NodeMessage>? messages, int statusCode)
        badRequest,
    required TResult Function(int statusCode) unauthorized,
    required TResult Function(int statusCode, String flowId) flowExpired,
    required TResult Function(String? message) unknown,
  }) {
    return badRequest(messages, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult? Function(int statusCode)? unauthorized,
    TResult? Function(int statusCode, String flowId)? flowExpired,
    TResult? Function(String? message)? unknown,
  }) {
    return badRequest?.call(messages, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult Function(int statusCode)? unauthorized,
    TResult Function(int statusCode, String flowId)? flowExpired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(messages, statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(FlowExpiredException value) flowExpired,
    required TResult Function(UnknownException value) unknown,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(FlowExpiredException value)? flowExpired,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(FlowExpiredException value)? flowExpired,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class BadRequestException extends CustomException {
  const factory BadRequestException(
      {final List<NodeMessage>? messages,
      final int statusCode}) = _$BadRequestException;
  const BadRequestException._() : super._();

  List<NodeMessage>? get messages;
  int get statusCode;
  @JsonKey(ignore: true)
  _$$BadRequestExceptionCopyWith<_$BadRequestException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedExceptionCopyWith<$Res> {
  factory _$$UnauthorizedExceptionCopyWith(_$UnauthorizedException value,
          $Res Function(_$UnauthorizedException) then) =
      __$$UnauthorizedExceptionCopyWithImpl<$Res>;
  @useResult
  $Res call({int statusCode});
}

/// @nodoc
class __$$UnauthorizedExceptionCopyWithImpl<$Res>
    extends _$CustomExceptionCopyWithImpl<$Res, _$UnauthorizedException>
    implements _$$UnauthorizedExceptionCopyWith<$Res> {
  __$$UnauthorizedExceptionCopyWithImpl(_$UnauthorizedException _value,
      $Res Function(_$UnauthorizedException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
  }) {
    return _then(_$UnauthorizedException(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$UnauthorizedException extends UnauthorizedException
    with DiagnosticableTreeMixin {
  const _$UnauthorizedException({this.statusCode = 401}) : super._();

  @override
  @JsonKey()
  final int statusCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException.unauthorized(statusCode: $statusCode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CustomException.unauthorized'))
      ..add(DiagnosticsProperty('statusCode', statusCode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedException &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnauthorizedExceptionCopyWith<_$UnauthorizedException> get copyWith =>
      __$$UnauthorizedExceptionCopyWithImpl<_$UnauthorizedException>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<NodeMessage>? messages, int statusCode)
        badRequest,
    required TResult Function(int statusCode) unauthorized,
    required TResult Function(int statusCode, String flowId) flowExpired,
    required TResult Function(String? message) unknown,
  }) {
    return unauthorized(statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult? Function(int statusCode)? unauthorized,
    TResult? Function(int statusCode, String flowId)? flowExpired,
    TResult? Function(String? message)? unknown,
  }) {
    return unauthorized?.call(statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult Function(int statusCode)? unauthorized,
    TResult Function(int statusCode, String flowId)? flowExpired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(FlowExpiredException value) flowExpired,
    required TResult Function(UnknownException value) unknown,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(FlowExpiredException value)? flowExpired,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(FlowExpiredException value)? flowExpired,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedException extends CustomException {
  const factory UnauthorizedException({final int statusCode}) =
      _$UnauthorizedException;
  const UnauthorizedException._() : super._();

  int get statusCode;
  @JsonKey(ignore: true)
  _$$UnauthorizedExceptionCopyWith<_$UnauthorizedException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FlowExpiredExceptionCopyWith<$Res> {
  factory _$$FlowExpiredExceptionCopyWith(_$FlowExpiredException value,
          $Res Function(_$FlowExpiredException) then) =
      __$$FlowExpiredExceptionCopyWithImpl<$Res>;
  @useResult
  $Res call({int statusCode, String flowId});
}

/// @nodoc
class __$$FlowExpiredExceptionCopyWithImpl<$Res>
    extends _$CustomExceptionCopyWithImpl<$Res, _$FlowExpiredException>
    implements _$$FlowExpiredExceptionCopyWith<$Res> {
  __$$FlowExpiredExceptionCopyWithImpl(_$FlowExpiredException _value,
      $Res Function(_$FlowExpiredException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? flowId = null,
  }) {
    return _then(_$FlowExpiredException(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      flowId: null == flowId
          ? _value.flowId
          : flowId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FlowExpiredException extends FlowExpiredException
    with DiagnosticableTreeMixin {
  const _$FlowExpiredException({this.statusCode = 410, required this.flowId})
      : super._();

  @override
  @JsonKey()
  final int statusCode;
  @override
  final String flowId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException.flowExpired(statusCode: $statusCode, flowId: $flowId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CustomException.flowExpired'))
      ..add(DiagnosticsProperty('statusCode', statusCode))
      ..add(DiagnosticsProperty('flowId', flowId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlowExpiredException &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.flowId, flowId) || other.flowId == flowId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, flowId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FlowExpiredExceptionCopyWith<_$FlowExpiredException> get copyWith =>
      __$$FlowExpiredExceptionCopyWithImpl<_$FlowExpiredException>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<NodeMessage>? messages, int statusCode)
        badRequest,
    required TResult Function(int statusCode) unauthorized,
    required TResult Function(int statusCode, String flowId) flowExpired,
    required TResult Function(String? message) unknown,
  }) {
    return flowExpired(statusCode, flowId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult? Function(int statusCode)? unauthorized,
    TResult? Function(int statusCode, String flowId)? flowExpired,
    TResult? Function(String? message)? unknown,
  }) {
    return flowExpired?.call(statusCode, flowId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult Function(int statusCode)? unauthorized,
    TResult Function(int statusCode, String flowId)? flowExpired,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (flowExpired != null) {
      return flowExpired(statusCode, flowId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(FlowExpiredException value) flowExpired,
    required TResult Function(UnknownException value) unknown,
  }) {
    return flowExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(FlowExpiredException value)? flowExpired,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return flowExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(FlowExpiredException value)? flowExpired,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (flowExpired != null) {
      return flowExpired(this);
    }
    return orElse();
  }
}

abstract class FlowExpiredException extends CustomException {
  const factory FlowExpiredException(
      {final int statusCode,
      required final String flowId}) = _$FlowExpiredException;
  const FlowExpiredException._() : super._();

  int get statusCode;
  String get flowId;
  @JsonKey(ignore: true)
  _$$FlowExpiredExceptionCopyWith<_$FlowExpiredException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownExceptionCopyWith<$Res> {
  factory _$$UnknownExceptionCopyWith(
          _$UnknownException value, $Res Function(_$UnknownException) then) =
      __$$UnknownExceptionCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$UnknownExceptionCopyWithImpl<$Res>
    extends _$CustomExceptionCopyWithImpl<$Res, _$UnknownException>
    implements _$$UnknownExceptionCopyWith<$Res> {
  __$$UnknownExceptionCopyWithImpl(
      _$UnknownException _value, $Res Function(_$UnknownException) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$UnknownException(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnknownException extends UnknownException with DiagnosticableTreeMixin {
  const _$UnknownException(
      {this.message = 'An error occured. Please try again later.'})
      : super._();

  @override
  @JsonKey()
  final String? message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CustomException.unknown(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CustomException.unknown'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownException &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownExceptionCopyWith<_$UnknownException> get copyWith =>
      __$$UnknownExceptionCopyWithImpl<_$UnknownException>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<NodeMessage>? messages, int statusCode)
        badRequest,
    required TResult Function(int statusCode) unauthorized,
    required TResult Function(int statusCode, String flowId) flowExpired,
    required TResult Function(String? message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult? Function(int statusCode)? unauthorized,
    TResult? Function(int statusCode, String flowId)? flowExpired,
    TResult? Function(String? message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<NodeMessage>? messages, int statusCode)? badRequest,
    TResult Function(int statusCode)? unauthorized,
    TResult Function(int statusCode, String flowId)? flowExpired,
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
    required TResult Function(BadRequestException value) badRequest,
    required TResult Function(UnauthorizedException value) unauthorized,
    required TResult Function(FlowExpiredException value) flowExpired,
    required TResult Function(UnknownException value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BadRequestException value)? badRequest,
    TResult? Function(UnauthorizedException value)? unauthorized,
    TResult? Function(FlowExpiredException value)? flowExpired,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BadRequestException value)? badRequest,
    TResult Function(UnauthorizedException value)? unauthorized,
    TResult Function(FlowExpiredException value)? flowExpired,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownException extends CustomException {
  const factory UnknownException({final String? message}) = _$UnknownException;
  const UnknownException._() : super._();

  String? get message;
  @JsonKey(ignore: true)
  _$$UnknownExceptionCopyWith<_$UnknownException> get copyWith =>
      throw _privateConstructorUsedError;
}
