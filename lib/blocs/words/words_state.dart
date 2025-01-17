part of 'words_bloc.dart';

@immutable
sealed class WordsState {}

final class WordsInitial extends WordsState {}

final class WordsStateLoading extends WordsState {}

final class WordsStateGetWord extends WordsState {
  final Word word;
  WordsStateGetWord({required this.word});
}

final class WordsStateError extends WordsState {
  final Exception exception;
  WordsStateError({required this.exception});
}
