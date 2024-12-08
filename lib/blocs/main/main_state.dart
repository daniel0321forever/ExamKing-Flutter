part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

final class MainStateGetRecords extends MainState {}

final class MainStateUpdateUserName extends MainState {}

final class MainStateError extends MainState {
  final Exception exception;
  MainStateError({required this.exception});
}
