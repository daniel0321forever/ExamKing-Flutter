part of 'battle_bloc.dart';

@immutable
sealed class BattleState {}

final class BattleInitial extends BattleState {}

class BattleRoundFinishState extends BattleState {
  final Problem problem;
  BattleRoundFinishState({required this.problem});
}

class BattleNewProblemReadyState extends BattleState {}

class BattleStartBattleState extends BattleState {}

class BattleWaitingState extends BattleState {}

class BattleAnsweredState extends BattleState {
  final bool playerAnswered;
  final int? playerScore;
  final int? opponentScore;
  final bool isCorrect;
  final int? answerIndex;

  BattleAnsweredState({
    required this.playerAnswered,
    this.playerScore,
    this.opponentScore,
    required this.isCorrect,
    required this.answerIndex,
  }) {
    if (playerAnswered && playerScore == null) {
      throw Exception("player score should not be null when player answered");
    } else if (!playerAnswered && opponentScore == null) {
      throw Exception("opponent score should not be null when opponent answered");
    }
  }
}

class BattleTimesUpState extends BattleState {}

class BattleSwitchingState extends BattleState {}

class BattleLossConnectionState extends BattleState {}

class BattleErrorState extends BattleState {}

class BattleEndGameState extends BattleState {
  final bool playerWin;
  final int playerScore;
  final int opponentScore;
  final int moneyAdded;
  final String? opponentName;

  BattleEndGameState({
    required this.playerWin,
    required this.playerScore,
    required this.opponentScore,
    required this.moneyAdded,
    this.opponentName,
  });
}
