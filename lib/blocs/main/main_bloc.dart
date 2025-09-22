import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:examKing/models/level.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'package:examKing/global/keys.dart' as keys;
import 'package:examKing/global/config.dart' as config;
import 'package:examKing/service/analysis_service.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:examKing/service/word_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AnalysisService analysisService = AnalysisService();
  final GlobalProvider globalProvider;
  final WordService wordService = WordService();
  bool isWordInitialized = false;

  MainBloc(this.globalProvider) : super(MainInitial()) {
    on<MainEventGetDailyProgress>((event, emit) async {
      if (globalProvider.wordProgress == null) {
        globalProvider
            .setWordProgress(await analysisService.getMonthlyWordProgress());
      }
      emit(MainStateGetDailyProgress());
    });

    on<MainEventInitialize>((event, emit) async {
      await wordService.initializeWords();
      isWordInitialized = true;

      emit(MainStateInitialize());
    });
  }
}
