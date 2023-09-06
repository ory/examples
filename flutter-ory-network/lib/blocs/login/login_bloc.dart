// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart';

import '../../entities/formfield.dart';
import '../../repositories/auth.dart';
import '../../services/exceptions.dart';
import '../auth/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  final AuthRepository repository;
  LoginBloc({required this.authBloc, required this.repository})
      : super(LoginState()) {
    on<CreateLoginFlow>(_onCreateLoginFlow);
    on<ChangeEmail>(_onChangeEmail);
    on<ChangePassword>(_onChangePassword);
    on<ChangePasswordVisibility>(_onChangePasswordVisibility);
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
  }

  Future<void> _onCreateLoginFlow(
      CreateLoginFlow event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final flowId = await repository.createLoginFlow();
      emit(state.copyWith(flowId: flowId, isLoading: false));
    } on CustomException catch (e) {
      if (e case UnknownException _) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  _onChangeEmail(ChangeEmail event, Emitter<LoginState> emit) {
    // remove email and general error when changing email
    emit(state.copyWith
        .email(value: event.value, errorMessage: null)
        .copyWith(errorMessage: null));
  }

  _onChangePassword(ChangePassword event, Emitter<LoginState> emit) {
    // remove password and general error when changing email
    emit(state.copyWith
        .password(value: event.value, errorMessage: null)
        .copyWith(errorMessage: null));
  }

  _onChangePasswordVisibility(
      ChangePasswordVisibility event, Emitter<LoginState> emit) {
    emit(state.copyWith(isPasswordHidden: event.value));
  }

  Future<void> _onLoginWithEmailAndPassword(
      LoginWithEmailAndPassword event, Emitter<LoginState> emit) async {
    try {
      // remove error messages when performing login
      emit(state
          .copyWith(isLoading: true, errorMessage: null)
          .copyWith
          .email(errorMessage: null)
          .copyWith
          .password(errorMessage: null));

      final session = await repository.loginWithEmailAndPassword(
          flowId: event.flowId, email: event.email, password: event.password);

      authBloc.add(
          ChangeAuthStatus(status: AuthStatus.authenticated, session: session));
    } on CustomException catch (e) {
      if (e case BadRequestException _) {
        final emailMessage = e.messages
            ?.firstWhereOrNull((element) => element.attr == 'identifier');
        final passwordMessage = e.messages
            ?.firstWhereOrNull((element) => element.attr == 'password');
        final generalMessage = e.messages
            ?.firstWhereOrNull((element) => element.attr == 'general');

        // update state to new one with errors
        emit(state
            .copyWith(isLoading: false, errorMessage: generalMessage?.text)
            .copyWith
            .email(errorMessage: emailMessage?.text)
            .copyWith
            .password(errorMessage: passwordMessage?.text));
      } else if (e case FlowExpiredException _) {
        // use new flow id, reset fields and show error
        emit(state
            .copyWith(
                flowId: e.flowId, errorMessage: e.message, isLoading: false)
            .copyWith
            .email(value: '')
            .copyWith
            .password(value: ''));
      } else if (e case UnknownException _) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }
}
