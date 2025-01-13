import 'package:examKing/models/word.dart';

class WordService {
  Future<List<Word>> getWords(int level) async {
    return List<Word>.from([
      Word(
        word: "apple",
        definition: "a fruit",
        translation: "蘋果",
        partOfSpeech: "noun",
        example: "I ate an apple",
        level: 0,
        isLearned: true,
        seenCount: 1,
      ),
      Word(
          word: "banana",
          definition: "a yellow fruit",
          translation: "香蕉",
          partOfSpeech: "noun",
          example: "I ate a banana",
          level: 0,
          isLearned: false,
          seenCount: 0),
      Word(
          word: "orange",
          definition: "a juicy orange fruit",
          translation: "橘子",
          partOfSpeech: "noun",
          example: "I ate an orange",
          level: 0,
          isLearned: false,
          seenCount: 3),
      Word(
        word: "pear",
        definition: "a fruit",
        translation: "梨",
        partOfSpeech: "noun",
        example: "I ate a pear",
        level: 0,
        isLearned: false,
        seenCount: 0,
      ),
      Word(
        word: "pineapple",
        definition: "a fruit",
        translation: "鳳梨",
        partOfSpeech: "noun",
        example: "I ate a pineapple",
        level: 0,
        isLearned: false,
        seenCount: 0,
      ),
    ]);
  }

  Future<void> updateWord(Word word) async {
    // TODO: implement updateWord
  }
}
