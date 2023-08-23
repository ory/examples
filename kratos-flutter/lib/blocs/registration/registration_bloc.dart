import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:collection/collection.dart';

import '../../entities/formfield.dart';
import '../../repositories/auth.dart';
import '../../services/exceptions.dart';
import '../auth/auth_bloc.dart';

part 'registration_event.dart';
part 'registration_state.dart';
part 'registration_bloc.freezed.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthBloc authBloc;
  final AuthRepository repository;
  RegistrationBloc({required this.authBloc, required this.repository})
      : super(RegistrationState()) {
    on<CreateRegistrationFlow>(_onCreateRegistrationFlow);
    on<ChangeEmail>(_onChangeEmail);
    on<ChangePassword>(_onChangePassword);
    on<RegisterWithEmailAndPassword>(_onRegisterWithEmailAndPassword);
  }

  Future<void> _onCreateRegistrationFlow(
      CreateRegistrationFlow event, Emitter<RegistrationState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final flowId = await repository.createRegistrationFlow();
      emit(state.copyWith(flowId: flowId, isLoading: false));
    } on CustomException catch (e) {
      if (e case UnknownException _) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  _onChangeEmail(ChangeEmail event, Emitter<RegistrationState> emit) {
    // remove email and general error when changing email
    emit(state.copyWith
        .email(value: event.value, errorMessage: null)
        .copyWith(errorMessage: null));
  }

  _onChangePassword(ChangePassword event, Emitter<RegistrationState> emit) {
    // remove password and general error when changing email
    emit(state.copyWith
        .password(value: event.value, errorMessage: null)
        .copyWith(errorMessage: null));
  }

  Future<void> _onRegisterWithEmailAndPassword(
      RegisterWithEmailAndPassword event,
      Emitter<RegistrationState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      await repository.registerWithEmailAndPassword(
          flowId: event.flowId, email: event.email, password: event.password);

      authBloc.add(ChangeAuthStatus(status: AuthStatus.authenticated));
    } on CustomException catch (e) {
      if (e case BadRequestException _) {
        // get credential errors
        final emailMessage = e.messages
            ?.firstWhereOrNull((element) => element.attr == 'traits.email');
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
        // use new flow id to log in user
        add(RegisterWithEmailAndPassword(
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
