part of 'analysis_bloc.dart';

@immutable
sealed class AnalysisEvent {}

class AnalysisEventLoading extends AnalysisEvent {}

class AnalysisEventGetStats extends AnalysisEvent {}

class AnalysisEventGetThisMonthWordProgress extends AnalysisEvent {}

class AnalysisEventGetMonthlyWordProgress extends AnalysisEvent {
  final int month;
  final int year;

  AnalysisEventGetMonthlyWordProgress(this.month, this.year);
}

class AnalysisEventGetSevenDaysCorrectRate extends AnalysisEvent {}

class AnalysisEventGetPreviousDaysCorrectRate extends AnalysisEvent {}
