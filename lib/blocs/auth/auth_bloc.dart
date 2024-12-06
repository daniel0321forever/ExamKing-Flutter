import 'package:bloc/bloc.dart';
import 'package:examKing/global/exception.dart';
import 'package:examKing/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:examKing/service/backend.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserProvider userProvider;
  BackendService backendService = BackendService();

  AuthBloc({required this.userProvider}) : super(AuthInitial()) {
    on<AuthEventSignUp>((event, emit) async {
      try {
        debugPrint("AuthEventSignUp triggered");
        userProvider.userData = await backendService.signInWithGoogle();
        debugPrint("on AuthEventSignUp | Google auth success, emitting authenticated state");
        emit(AuthStateAuthenticated());
      } on GoogleAuthFailedException catch (e) {
        debugPrint("on AuthEventSignUp | Google auth failed");
        emit(AuthStateFailed());
      } on Exception catch (e) {
        emit(AuthStateError(exception: e));
      }
    });
    on<AuthEventLogIn>((event, emit) {
      // TODO: implement event handler
    });
  }
}
