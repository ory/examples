import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart';

import '../../entities/formfield.dart';
import '../../repositories/auth.dart';
import '../../services/exceptions.dart';
import '../../services/message.dart';
import '../auth/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  final AuthRepository repository;
  LoginBloc({required this.authBloc, required this.repository})
      : super(const LoginState()) {
    on<CreateLoginFlow>(_onCreateLoginFlow);
    on<ChangeEmail>(_onChangeEmail);
    on<ChangePassword>(_onChangePassword);
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

  Future<void> _onLoginWithEmailAndPassword(
      LoginWithEmailAndPassword event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      await repository.loginWithEmailAndPassword(
          flowId: event.flowId, email: event.email, password: event.password);

      authBloc.add(ChangeAuthStatus(status: AuthStatus.authenticated));
    } on CustomException catch (e) {
      if (e case BadRequestException _) {
        // get credential errors
        final emailMessage = e.messages?.firstWhereOrNull(
            (element) => element.context.property == Property.identifier);
        final passwordMessage = e.messages?.firstWhereOrNull(
            (element) => element.context.property == Property.password);
        final generalMessage = e.messages?.firstWhereOrNull(
            (element) => element.context.property == Property.general);

        // update state to new one with errors
        emit(state
            .copyWith(isLoading: false, errorMessage: generalMessage?.text)
            .copyWith
            .email(errorMessage: emailMessage?.text)
            .copyWith
            .password(errorMessage: passwordMessage?.text));
      } else if (e case FlowExpiredException _) {
        // use new flow id to log in user
        add(LoginWithEmailAndPassword(
            flowId: e.flowId,
            email: state.email.value,
            password: state.password.value));
      } else if (e case UnknownException _) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }
}
