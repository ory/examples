// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.uninitialized(
      {@Default(AuthStatus.uninitialized) final AuthStatus status,
      @Default(false) bool isLoading,
      String? errorMessage}) = AuthUninitialized;
  const factory AuthState.unauthenticated(
      {@Default(AuthStatus.unauthenticated) final AuthStatus status,
      @Default(false) bool isLoading,
      String? errorMessage}) = AuthUnauthenticated;
  const factory AuthState.authenticated(
      {@Default(AuthStatus.authenticated) final AuthStatus status,
      required Session session,
      @Default(false) bool isLoading,
      String? errorMessage}) = AuthAuthenticated;

  const factory AuthState.aal2Requested(
      {@Default(AuthStatus.aal2Requested) final AuthStatus status,
      @Default(false) bool isLoading,
      String? errorMessage}) = Aal2Requested;

  const factory AuthState.locationChangeRequired(
      {@Default(AuthStatus.locationChangeRequired) final AuthStatus status,
      required String url,
      @Default(false) bool isLoading,
      String? errorMessage}) = LocationChangeRequired;
}
