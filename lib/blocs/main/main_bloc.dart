import 'package:bloc/bloc.dart';
import 'package:examKing/models/ability_record.dart';
import 'package:examKing/service/analysis_service.dart';
import 'package:examKing/service/backend.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AnalysisService analysisService = AnalysisService();
  final GlobalProvider globalProvider;

  MainBloc(this.globalProvider) : super(MainInitial()) {
    on<MainEventGetDailyProgress>((event, emit) async {
      if (globalProvider.wordProgress == null) {
        globalProvider.setWordProgress(await analysisService.getMonthlyWordProgress());
      }
      emit(MainStateGetDailyProgress());
    });
  }
}
