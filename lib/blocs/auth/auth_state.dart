part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthStateLoggedOut extends AuthState {}

class AuthStateAuthenticated extends AuthState {}

class AuthStateFailed extends AuthState {}

class AuthStateNoConnection extends AuthState {}

class AuthStateError extends AuthState {
  final Exception exception;
  AuthStateError({required this.exception});
}

class AuthStateUsernameEmpty extends AuthState {}

class AuthStateUsernameNotAvailable extends AuthState {}

class AuthStateUsernameAvailable extends AuthState {}

class AuthStateEmailEmpty extends AuthState {}

class AuthStateEmailInvalid extends AuthState {}

class AuthStateEmailAvailable extends AuthState {}
