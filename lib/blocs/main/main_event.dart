part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class MainEventGetDailyProgress extends MainEvent {}

class MainEventInitialize extends MainEvent {
  final bool force;
  MainEventInitialize({this.force = false});
}
