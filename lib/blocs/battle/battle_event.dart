part of 'battle_bloc.dart';

@immutable
sealed class BattleEvent {}

class BattleWaitingEvent extends BattleEvent {}

class BattleStartBattleEvent extends BattleEvent {}

class BattleAnswerEvent extends BattleEvent {
  final int answerIndex;
  BattleAnswerEvent({required this.answerIndex});
}

class BattleGetAnsRespondedEvent extends BattleEvent {
  final bool isPlayer;
  final int addedScore;
  final int? answerIndex;
  BattleGetAnsRespondedEvent({required this.isPlayer, required this.addedScore, this.answerIndex});
}

/// The following behaviour is expected as the battle start
/// 1) Client connecting to socket server
/// 2) Define a stream listening to the server response
class BattleStartEvent extends BattleEvent {
  final Challenge challenge;
  BattleStartEvent({required this.challenge});
}

/// This event indicates that the animation is completed
/// and the UI could be updated for the next round
class BattleNextRoundReadyEvent extends BattleEvent {}

class BattleTimesUpEvent extends BattleEvent {}

/// The following behavior is expected as the event occurs
/// 1) The initialize() method should be triggered, which cancel the backend channel
class BattleCancelEvent extends BattleEvent {}
