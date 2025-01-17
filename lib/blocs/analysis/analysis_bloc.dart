import 'package:bloc/bloc.dart';
import 'package:examKing/models/stat.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:meta/meta.dart';
import 'package:examKing/service/analysis_service.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalysisService analysisService = AnalysisService();
  final GlobalProvider globalProvider;

  List<Stat>? stats;

  AnalysisBloc(this.globalProvider) : super(AnalysisInitial()) {
    on<AnalysisEventLoading>((event, emit) async {
      stats = await analysisService.getStats();

      if (globalProvider.wordProgress == null) {
        globalProvider.setWordProgress(await analysisService.getMonthlyWordProgress());
      }
      globalProvider.setCorrectRates(await analysisService.getSevenDaysCorrectRate());
      emit(AnalysisStateCompleteLoading());
    });

    on<AnalysisEventGetThisMonthWordProgress>((event, emit) async {
      if (globalProvider.wordProgress == null) {
        globalProvider.setWordProgress(await analysisService.getMonthlyWordProgress());
      }
      emit(AnalysisStateGetThisMonthWordProgress());
    });

    on<AnalysisEventGetSevenDaysCorrectRate>((event, emit) async {
      globalProvider.setCorrectRates(await analysisService.getSevenDaysCorrectRate());
      emit(AnalysisStateGetSevenDaysCorrectRate());
    });
  }
}
