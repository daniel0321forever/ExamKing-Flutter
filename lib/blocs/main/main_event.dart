part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class MainEventGetRecord extends MainEvent {}

class MainEventUpdateUserName extends MainEvent {
  final String name;
  MainEventUpdateUserName({required this.name});
}
