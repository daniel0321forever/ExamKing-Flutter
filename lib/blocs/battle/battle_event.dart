part of 'battle_bloc.dart';

@immutable
sealed class BattleEvent {}

/// The following behavior is expected as the event occurs
/// 1) Emit the BattleWaitingState to the UI code
class BattleWaitingEvent extends BattleEvent {}

/// The following behavior is expected as the event occurs
/// 1) Emit the BattleStartBattleState to the UI code
class BattleStartBattleEvent extends BattleEvent {}

/// The event is triggered when the player answers the problem
/// The following behavior is expected as the event occurs
/// 1) Send answer type data with the answer index to the server
class BattleAnswerEvent extends BattleEvent {
  final int answerIndex;
  BattleAnswerEvent({required this.answerIndex});
}

/// The event is triggered when the opponent answers the problem
/// The following behavior is expected as the event occurs
/// 1) Send answer type data with the answer index to the server
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
  final int? level;
  BattleStartEvent({required this.challenge, this.level});
}

/// The event is triggered when the player times up
/// The following behavior is expected as the event occurs
/// 1) Send answer type data with zero score while emitting times up state to the UI code
class BattleTimesUpEvent extends BattleEvent {}

/// The following behavior is expected as the event occurs
/// 1) The initialize() method should be triggered, which cancel the backend channel
class BattleCancelEvent extends BattleEvent {}

/// The following behavior is expected as the event occurs
/// 1) Emit the BattleNextRoundState to the UI code
/// 2) Restart computer aggent if the opponent is the computer
class BattleRoundStartEvent extends BattleEvent {}

/// The following behavior is expected as the event occurs
/// 1) Emit the BattleTimerTickedState to the UI code
class BattleTimerTickedEvent extends BattleEvent {}
