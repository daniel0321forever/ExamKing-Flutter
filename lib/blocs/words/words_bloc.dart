import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:examKing/models/level.dart';
import 'package:examKing/models/word.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:examKing/service/backend.dart';
import 'package:examKing/service/word_service.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  List<Word>? words;
  Word? currentWord;
  int currentLearned = 0;
  int currentUnfamiliar = 0;

  final WordService wordService = WordService();
  final GlobalProvider globalProvider;

  void initialize() {
    words = [];
    currentWord = null;
  }

  WordsBloc(this.globalProvider) : super(WordsInitial()) {
    on<WordsEventInitialize>((event, emit) {
      initialize();
    });

    on<WordsEventLoad>((event, emit) async {
      words = await wordService.getWords(event.level);

      currentLearned = words!.where((word) => word.isLearned).length;
      currentUnfamiliar = words!
          .where((word) => (!word.isLearned && word.seenCount > 0))
          .length;

      currentWord = (words!..shuffle()).first;
      emit(WordsStateGetWord(word: currentWord!));
    });

    on<WordsEventResponded>((event, emit) async {
      globalProvider.pushProgress();
      if (event.isKnown && !currentWord!.isLearned) {
        currentWord!.isLearned = true;
        currentLearned++;
        currentUnfamiliar -= currentWord!.seenCount == 0 ? 0 : 1;
      } else if (!event.isKnown && currentWord!.isLearned) {
        currentWord!.isLearned = false;
        currentLearned--;
        currentUnfamiliar++;
      } else if (!event.isKnown && currentWord!.seenCount == 0) {
        currentUnfamiliar++;
      }

      currentWord!.seenCount++;

      Word previousWord = currentWord!;

      // iterate to find the next word until the word is not the same as the previous word
      do {
        final random = Random();
        int randomIndex = random.nextInt(words!.length);
        currentWord = words![randomIndex];
      } while (currentWord!.word == previousWord.word);

      emit(WordsStateGetWord(word: currentWord!));

      await wordService.updateWord(previousWord);
    });
  }
}
