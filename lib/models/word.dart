import 'package:examKing/models/level.dart';

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
}
