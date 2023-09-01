part of 'login_bloc.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState(
      {String? flowId,
      @Default(FormField<String>(value: '')) FormField<String> email,
      @Default(FormField<String>(value: '')) FormField<String> password,
      @Default(true) bool isPasswordHidden,
      @Default(false) bool isLoading,
      String? errorMessage}) = _LoginState;
}
