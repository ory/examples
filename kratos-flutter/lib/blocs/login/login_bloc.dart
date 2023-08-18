import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
      : super(const LoginState()) {
    on<CreateLoginFlow>(_onCreateLoginFlow);
  }

  Future<void> _onCreateLoginFlow(
      CreateLoginFlow event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final flowId = await repository.createLoginFlow();
      emit(state.copyWith(flowId: flowId, isLoading: false));
    } on CustomException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    }
  }
}
