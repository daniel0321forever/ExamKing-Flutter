part of 'analysis_bloc.dart';

@immutable
sealed class AnalysisState {}

final class AnalysisInitial extends AnalysisState {}

class AnalysisStateCompleteLoading extends AnalysisState {}

class AnalysisStateGetThisMonthWordProgress extends AnalysisState {}

class AnalysisStateGetMonthlyWordProgress extends AnalysisState {}

class AnalysisStateGetSevenDaysCorrectRate extends AnalysisState {}

class AnalysisStateGetPreviousDaysCorrectRate extends AnalysisState {}
