part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthEventAppStart extends AuthEvent {}

class AuthEventGoogleSignUp extends AuthEvent {}

class AuthEventSignUp extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String name;

  AuthEventSignUp({required this.username, required this.password, required this.email, required this.name});
}

class AuthEventLogIn extends AuthEvent {
  final String username;
  final String password;

  AuthEventLogIn({required this.username, required this.password});
}

class AuthEventLogOut extends AuthEvent {}

class AuthEventCheckUsername extends AuthEvent {
  final String username;

  AuthEventCheckUsername({required this.username});
}

class AuthEventCheckEmail extends AuthEvent {
  final String email;

  AuthEventCheckEmail({required this.email});
}
