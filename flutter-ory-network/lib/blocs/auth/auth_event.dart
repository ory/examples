// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ChangeAuthStatus extends AuthEvent {
  final AuthStatus status;
  final Session? session;

  ChangeAuthStatus({required this.status, this.session});
  @override
  List<Object?> get props => [status, session];
}

//get current session information
final class GetCurrentSessionInformation extends AuthEvent {}

//log out
final class LogOut extends AuthEvent {}
