part of 'registration_bloc.dart';

@immutable
sealed class RegistrationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//create registration flow
final class CreateRegistrationFlow extends RegistrationEvent {}

final class ChangeEmail extends RegistrationEvent {
  final String value;

  ChangeEmail({required this.value});

  @override
  List<Object> get props => [value];
}

final class ChangePassword extends RegistrationEvent {
  final String value;

  ChangePassword({required this.value});

  @override
  List<Object> get props => [value];
}

//log in
final class RegisterWithEmailAndPassword extends RegistrationEvent {
  final String flowId;
  final String email;
  final String password;

  RegisterWithEmailAndPassword(
      {required this.flowId, required this.email, required this.password});

  @override
  List<Object> get props => [flowId, email, password];
}
