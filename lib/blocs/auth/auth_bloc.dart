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
    on<AuthEventAppStart>((event, emit) async {
      debugPrint("on AuthEventAppStart | triggered");
      try {
        userProvider.userData = await backendService.signInWithToken();
        debugPrint("on AuthEventAppStart | get user data");
        emit(AuthStateAuthenticated());
      } on UnAuthenticatedException {
        debugPrint("on AuthEventAppStart | failed logging in with token");
      } on Exception catch (e) {
        emit(AuthStateError(exception: e));
      }
    });

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
