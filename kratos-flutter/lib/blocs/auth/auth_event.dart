part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ChangeAuthStatus extends AuthEvent {
  final AuthStatus status;

  ChangeAuthStatus({required this.status});
  @override
  List<Object> get props => [status];
}

//get current session information
final class GetCurrentSessionInformation extends AuthEvent {}

//log out
final class LogOut extends AuthEvent {}
