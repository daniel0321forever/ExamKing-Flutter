part of 'words_bloc.dart';

@immutable
sealed class WordsEvent {}

/// This event is emitted when the user loads the words
class WordsEventLoad extends WordsEvent {
  final Level level;
  WordsEventLoad({required this.level});
}

/// This event is emitted when the words bloc is initialized
class WordsEventInitialize extends WordsEvent {}

/// This event is emitted when the user reponds known or unfamiliar to the word
class WordsEventResponded extends WordsEvent {
  final String word;
  final bool isKnown;
  WordsEventResponded({required this.word, required this.isKnown});
}
