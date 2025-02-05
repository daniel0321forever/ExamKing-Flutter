import 'package:examKing/global/keys.dart' as keys;

class Word {
  final String word;
  final String definition;
  final String translation;
  final String partOfSpeech;
  final String example;
  final int level;
  bool isLearned;
  int seenCount;

  Word({
    required this.word,
    required this.definition,
    required this.translation,
    required this.partOfSpeech,
    required this.example,
    required this.level,
    this.isLearned = false,
    this.seenCount = 0,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map[keys.wordWordKey],
      definition: map[keys.wordDefinitionKey],
      translation: map[keys.wordTranslationKey],
      partOfSpeech: map[keys.wordPartOfSpeechKey],
      example: map[keys.wordExampleKey],
      level: map[keys.wordLevelKey],
      isLearned: map[keys.wordIsLearnedKey],
      seenCount: map[keys.wordSeenCountKey],
    );
  }
}
