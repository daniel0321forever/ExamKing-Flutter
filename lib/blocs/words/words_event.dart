part of 'words_bloc.dart';

@immutable
sealed class WordsEvent {}

class WordsEventLoad extends WordsEvent {}

class WordsEventInitialize extends WordsEvent {}

class WordsEventResponded extends WordsEvent {
  final String word;
  final bool isKnown;
  WordsEventResponded({required this.word, required this.isKnown});
}
