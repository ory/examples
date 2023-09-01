part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//create login flow
final class CreateLoginFlow extends LoginEvent {}

final class ChangeEmail extends LoginEvent {
  final String value;

  ChangeEmail({required this.value});

  @override
  List<Object> get props => [value];
}

final class ChangePassword extends LoginEvent {
  final String value;

  ChangePassword({required this.value});

  @override
  List<Object> get props => [value];
}

final class ChangePasswordVisibility extends LoginEvent {
  final bool value;

  ChangePasswordVisibility({required this.value});

  @override
  List<Object> get props => [value];
}

//log in
final class LoginWithEmailAndPassword extends LoginEvent {
  final String flowId;
  final String email;
  final String password;

  LoginWithEmailAndPassword(
      {required this.flowId, required this.email, required this.password});

  @override
  List<Object> get props => [flowId, email, password];
}
