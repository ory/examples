// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ory_client/ory_client.dart';

import '../../repositories/auth.dart';
import '../../services/exceptions.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  AuthBloc({required this.repository})
      : super(const AuthState(status: AuthStatus.uninitialized)) {
    on<GetCurrentSessionInformation>(_onGetCurrentSessionInformation);
    on<ChangeAuthStatus>(_changeAuthStatus);
    on<LogOut>(_logOut);
  }

  _changeAuthStatus(ChangeAuthStatus event, Emitter<AuthState> emit) {
    emit(state.copyWith(status: event.status, isLoading: false));
  }

  Future<void> _onGetCurrentSessionInformation(
      GetCurrentSessionInformation event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final session = await repository.getCurrentSessionInformation();

      emit(state.copyWith(
          isLoading: false,
          status: AuthStatus.authenticated,
          session: session));
    } on CustomException catch (e) {
      if (e case UnauthorizedException _) {
        emit(state.copyWith(
            status: AuthStatus.unauthenticated,
            session: null,
            isLoading: false));
      } else if (e case UnknownException _) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> _logOut(LogOut event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      await repository.logout();

      emit(state.copyWith(
          isLoading: false, status: AuthStatus.unauthenticated, session: null));
    } on CustomException catch (e) {
      if (e case UnauthorizedException _) {
        emit(state.copyWith(
            isLoading: false,
            status: AuthStatus.unauthenticated,
            session: null));
      } else if (e case UnknownException _) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }
}
