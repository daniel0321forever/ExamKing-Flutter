part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthEventSignUp extends AuthEvent {}

class AuthEventLogIn extends AuthEvent {}
