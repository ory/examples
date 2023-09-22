// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/message.dart';

part 'exceptions.freezed.dart';

@freezed
sealed class CustomException with _$CustomException {
  const CustomException._();
  const factory CustomException.badRequest(
      {List<NodeMessage>? messages,
      @Default(400) int statusCode}) = BadRequestException;
  const factory CustomException.unauthorized({@Default(401) int statusCode}) =
      UnauthorizedException;
  const factory CustomException.sessionRefreshRequired(
      {@Default(403) int statusCode,
      String? message}) = SessionRefreshRequiredException;
  const factory CustomException.flowExpired(
      {@Default(410) int statusCode,
      required String flowId,
      String? message}) = FlowExpiredException;
  const factory CustomException.unknown(
      {@Default('An error occured. Please try again later.')
      String message}) = UnknownException;
}
