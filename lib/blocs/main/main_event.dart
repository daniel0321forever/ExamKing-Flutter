part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class MainEventGetDailyProgress extends MainEvent {}
