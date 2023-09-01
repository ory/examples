part of 'registration_bloc.dart';

@freezed
sealed class RegistrationState with _$RegistrationState {
  const factory RegistrationState(
      {String? flowId,
      @Default(FormField<String>(value: '')) FormField<String> email,
      @Default(FormField<String>(value: '')) FormField<String> password,
      @Default(true) bool isPasswordHidden,
      @Default(false) bool isLoading,
      String? errorMessage}) = _RegistrationState;
}
