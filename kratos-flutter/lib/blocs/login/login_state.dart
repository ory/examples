part of 'login_bloc.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState(
      {String? flowId,
      @Default('') String email,
      @Default('') String password,
      @Default(false) bool isLoading,
      String? errorMessage}) = _LoginState;
}
