// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState(
      {required AuthStatus status,
      Session? session,
      @Default(false) bool isLoading,
      String? errorMessage}) = _AuthState;
}
