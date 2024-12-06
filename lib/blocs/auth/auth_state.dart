part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthStateAuthenticated extends AuthState {}

class AuthStateFailed extends AuthState {}

class AuthStateNoConnection extends AuthState {}

class AuthStateError extends AuthState {
  final Exception exception;
  AuthStateError({required this.exception});
}
