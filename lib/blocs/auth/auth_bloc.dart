import 'package:bloc/bloc.dart';
import 'package:examKing/global/exception.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:examKing/service/backend.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isKeepSignedIn = true;
  final GlobalProvider userProvider;
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

    on<AuthEventGoogleSignUp>((event, emit) async {
      try {
        debugPrint("AuthEventGoogleSignUp triggered");
        userProvider.userData = await backendService.signInWithGoogle();
        debugPrint("on AuthEventGoogleSignUp | Google auth success, emitting authenticated state");
        emit(AuthStateAuthenticated());
      } on GoogleAuthFailedException catch (e) {
        debugPrint("on AuthEventGoogleSignUp | Google auth failed");
        emit(AuthStateFailed());
      } on Exception catch (e) {
        emit(AuthStateError(exception: e));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      debugPrint("AuthEventLogIn triggered");
      try {
        userProvider.userData = await backendService.signIn(event.username, event.password);
        debugPrint("on AuthEventLogIn | sign in success");
        emit(AuthStateAuthenticated());
      } on UnAuthenticatedException catch (e) {
        debugPrint("on AuthEventLogIn | sign in failed");
        emit(AuthStateFailed());
      } on Exception catch (e) {
        emit(AuthStateError(exception: e));
      }
    });

    on<AuthEventSignUp>((event, emit) async {
      debugPrint("AuthEventSignUp triggered");
      try {
        userProvider.userData = await backendService.signUp(event.username, event.password, event.email, event.name);
        debugPrint("on AuthEventSignUp | sign up success");
        emit(AuthStateAuthenticated());
      } on Exception catch (e) {
        emit(AuthStateError(exception: e));
      }
    });

    on<AuthEventCheckUsername>((event, emit) async {
      debugPrint("AuthEventCheckUsername triggered");
      try {
        if (event.username.isEmpty) {
          debugPrint("on AuthEventCheckUsername | username is empty");
          emit(AuthStateUsernameEmpty());
          return;
        }

        await backendService.checkUsername(event.username);
        debugPrint("on AuthEventCheckUsername | username is available");
        emit(AuthStateUsernameAvailable());
        emit(AuthStateLoggedOut());
      } on UsernameAlreadyTakenException {
        debugPrint("on AuthEventCheckUsername | username is already taken");
        emit(AuthStateUsernameNotAvailable());
      } on Exception catch (e) {
        debugPrint("on AuthEventCheckUsername | error ${e.toString()}");
        emit(AuthStateError(exception: e));
      }
    });

    on<AuthEventCheckEmail>((event, emit) async {
      debugPrint("AuthEventCheckEmail triggered");
      try {
        if (event.email.isEmpty) {
          debugPrint("on AuthEventCheckEmail | email is empty");
          emit(AuthStateEmailEmpty());
          return;
        }

        debugPrint("on AuthEventCheckEmail | email is not empty");
        await backendService.checkEmail(event.email);
        debugPrint("on AuthEventCheckEmail | email is valid");
        emit(AuthStateEmailAvailable());
        emit(AuthStateLoggedOut());
      } on EmailInvalidException {
        debugPrint("on AuthEventCheckEmail | email is invalid");
        emit(AuthStateEmailInvalid());
      } on Exception catch (e) {
        emit(AuthStateError(exception: e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      debugPrint("AuthEventLogOut triggered");
      userProvider.userData = null;
      await backendService.logOut(isKeepSignedIn);
      emit(AuthStateLoggedOut());
    });

    on<AuthEventUpdateUserName>((event, emit) async {
      try {
        debugPrint("on AuthEventUpdateUserName | triggered with name: ${event.name}");
        userProvider.userData!.name = event.name;
        await backendService.updateUserInfo({"name": event.name});

        debugPrint("on AuthEventUpdateUserName | emitting AuthStateUpdateUserName");
        emit(AuthStateUpdateUserName());
      } on Exception catch (e) {
        emit(AuthStateError(exception: e));
        debugPrint("on AuthEventUpdateUserName | Unexcepted exception occurs: $e");
      }
    });
  }
}
