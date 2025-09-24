import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/record.dart';
import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:examKing/models/challenge.dart';
import 'package:examKing/models/problem.dart';
import 'package:examKing/service/backend.dart';
import 'package:examKing/global/keys.dart' as keys;

part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  final GlobalProvider userProvider;

  static const Duration battlePrepareStartDuration =
      Duration(milliseconds: 1000);
  static const Duration showOpponentAnswerDuration =
      Duration(milliseconds: 1000);
  static const Duration showCorrectAnswerDuration =
      Duration(milliseconds: 1300);
  static const Duration showNextRoundLabelDuration =
      Duration(milliseconds: 1900);
  static const Duration battlePrepareDuration = Duration(milliseconds: 5000);
  static const Duration battleNavPageDuration = Duration(milliseconds: 500);

  static const Duration roundDuration = Duration(milliseconds: 10000);
  static const String computerID = "Adjff13026887732F1";
  static const int maxWaitingSecs = 6;

  BackendService backendService = BackendService();
  Stream? battleStream;
  StreamSubscription? battleBlocListener;

  Timer? waitingTimer;
  Timer? roundTimer;

  int waitingTime = 0;
  int? leftSec;

  int playerScore = 0;
  int playerCombo = 0;
  int playerMaxCombo = 0;
  int opponentScore = 0;
  int opponentCombo = 0;
  int opponentMaxCombo = 0;
  String? opponentName;
  String? opponentID;

  bool startGameClicked = false;
  String? challengeKey;
  int? challengeLevel;
  List<Problem>? problems;
  int round = 0;
  bool isOppnComputer = false;
  BattleRecord? record;

  bool hasResponded = false;
  bool opnHasResponded = false;

  void initialize() {
    debugPrint("initializing battle bloc");
    startGameClicked = false;

    record = null;

    waitingTime = 0;
    waitingTimer?.cancel();
    waitingTimer = null;
    cancelRoundTimer();

    leftSec = null;
    playerScore = 0;
    playerCombo = 0;
    playerMaxCombo = 0;

    opponentScore = 0;
    opponentCombo = 0;
    opponentMaxCombo = 0;
    opponentName = null;
    opponentID = null;
    challengeKey = null;
    challengeLevel = null;
    problems = null;
    round = 0;
    isOppnComputer = false;
    hasResponded = false;
    opnHasResponded = false;

    battleStream = null;
    battleBlocListener?.cancel();
    battleBlocListener = null;
    backendService.closeConnection();
  }

  void cancelRoundTimer() {
    debugPrint("canceling round timer");
    roundTimer?.cancel();
    roundTimer = null;
  }

  Future<void> endRound(BattleEvent event, Emitter<BattleState> emit) async {
    {
      emit(BattleShowCorrectAnswerState());
      await Future.delayed(showCorrectAnswerDuration);
      emit(BattleShowNextRoundLabelState());

      await Future.delayed(showNextRoundLabelDuration);

      hasResponded = false;
      opnHasResponded = false;
      debugPrint(
          "on BattleGetAnsRespondedEvent | triggering BattleRoundStartEvent");
      add(BattleRoundStartEvent());
    }
  }

  Future<void> endGame(BattleEvent event, Emitter<BattleState> emit) async {
    {
      hasResponded = false;
      opnHasResponded = false;

      int moneyAdded = playerScore - opponentScore;

      if (playerScore > opponentScore) {
        userProvider.userData!.winRecord += 1;
        record!.victory = true;
      } else {
        userProvider.userData!.loseRecord += 1;
        record!.victory = false;
      }

      emit(BattleShowCorrectAnswerState());
      await Future.delayed(showCorrectAnswerDuration);

      await backendService.updatedBattleRecord(record: record!);

      emit(BattleEndGameState(
        playerWin: playerScore > opponentScore,
        playerScore: playerScore,
        opponentScore: opponentScore,
        moneyAdded: moneyAdded,
        opponentName: opponentName,
      ));
    }
  }

  Future<void> startGame(BattleEvent event, Emitter<BattleState> emit,
      {required Map decoded}) async {
    {
      waitingTimer?.cancel();
      waitingTimer = null;

      String userID = userProvider.userData!.username ??
          userProvider.userData!.googleUsername!;

      debugPrint("on BattleStartEvent | get start game message: $decoded");

      for (int i = 0; i < 2; i++) {
        if (decoded[keys.battleUsernamesKey][i] != userID) {
          opponentID = decoded[keys.battleUsernamesKey][i];
          opponentName = decoded[keys.battleNamesKey][i];
          break;
        }
      }

      if (isOppnComputer && opponentID != computerID) {
        backendService.closeComputerConnection();
        isOppnComputer = false;
      }

      problems = List<Problem>.generate(
        decoded['problems'].length, // TODO: change here
        (i) => Problem.fromMap(decoded['problems'][i]),
      );

      record =
          BattleRecord(challengeKey: challengeKey!, opponentID: opponentID!);
      add(BattleStartBattleEvent());
    }
  }

  int calculateAddedScore(int leftSec) {
    return 200 * ((leftSec ~/ 2 + 1) * 2) ~/ roundDuration.inSeconds;
  }

  BattleBloc({required this.userProvider}) : super(BattleWaitingState()) {
    /// The following behaviour is expected as the battle start
    /// 1) Client connecting to socket server
    /// 2) Define a stream listening to the server response
    on<BattleStartEvent>((event, emit) async {
      try {
        debugPrint("on BattleStartEvent | triggered");

        // initialize
        initialize();
        startGameClicked = true;

        // connect to server
        await backendService.connectToBattle(
          event.challenge.key,
          username: userProvider.userData!.username ??
              userProvider.userData!.googleUsername!,
          level: event.level,
        );

        // set up variables
        challengeKey = event.challenge.key;
        challengeLevel = event.level;
        // start waiting
        add(BattleWaitingEvent());

        // define stream which listen to wait, start_game, answer and end-game type message
        battleStream = backendService.channel!.stream.asBroadcastStream();
        battleBlocListener = battleStream!.listen((message) async {
          Map decoded = json.decode(utf8.decode(message.codeUnits));

          // NOTE: Triggered state based on answer type
          switch (decoded['type'] ?? 'noTypeDefault') {
            case 'wait':
              break;
            case 'start_game':
              await startGame(event, emit, decoded: decoded);
              break;
            case 'answer':
              add(BattleGetAnsRespondedEvent(
                isPlayer: decoded['answered_user'] ==
                    (userProvider.userData!.username ??
                        userProvider.userData!.googleUsername!),
                addedScore: int.parse(decoded['added_score'].toString()),
                answerIndex: decoded['option_index'],
              ));
              break;

            default:
              debugPrint(
                  "on BattleStartEvent | error: cannot recognize return type ${decoded['type']}");
              throw Exception();
          }
        });
      } on Exception catch (e) {
        emit(BattleErrorState());
        initialize();
        debugPrint("on BattleStartEvent | Unexcepted exception occurs: $e");
      }
    });

    /// The following behavior is expected as the event occurs
    /// 1) The initialize() method should be triggered, which cancel the backend channel
    on<BattleCancelEvent>((event, emit) {
      initialize();
    });

    /// The following behaviour is expected as the answerring event occurs
    /// 1) Compare answer to correctAns and emit either correct or wrong state
    /// 2) The combo and the score of the user are calculated
    /// 3) Send message to server
    on<BattleAnswerEvent>((event, emit) {
      try {
        // compare answer to correctAns and emit either correct or wrong state
        debugPrint("on BattleAnswerEvent | event triggered");
        hasResponded = true;
        int addedScore = 0;

        if (problems![round].options[event.answerIndex].correct) {
          addedScore = calculateAddedScore(leftSec!);
          playerScore += addedScore;
          record!.answerRecords.add(AnswerRecord(
              problemID: problems![round].problemID, correct: true));
        } else {
          record!.answerRecords.add(AnswerRecord(
              problemID: problems![round].problemID, correct: false));
        }

        emit(BattleAnsweredState(
          playerAnswered: true,
          playerScore: playerScore,
          isCorrect: addedScore > 0,
          answerIndex: event.answerIndex,
        ));

        // send message to server
        backendService.answer(addedScore,
            optionIndex: event.answerIndex,
            userId: userProvider.userData!.username ??
                userProvider.userData!.googleUsername!);
      } on Exception catch (e) {
        emit(BattleErrorState());
        initialize();
        debugPrint("on BattleAnsweEvent | Unexcepted exception occurs: $e");
      }
    });

    /// The following behavior is expected as the event occurs
    /// 1) Update opponent score and emit BattleAnsweredState
    /// 2) Check going to next round
    /// 3) End game if the round is the last round
    on<BattleGetAnsRespondedEvent>((event, emit) async {
      try {
        // if the answer response is from the opponent
        if (!event.isPlayer) {
          debugPrint(
              "on BattleGetAnsRespondedEvent | get opponent answer response");

          // update opponent record
          opnHasResponded = true;
          opponentScore += event.addedScore;

          debugPrint(
              "on BattleGetAnsRespondedEvent | emitting BattleAnsweredState for opponent");
          emit(BattleAnsweredState(
            playerAnswered: false,
            opponentScore: opponentScore,
            isCorrect: event.addedScore > 0,
            answerIndex: event.answerIndex,
          ));
          // TODO: add combo
        }

        // check going to next round
        if (hasResponded && opnHasResponded) {
          debugPrint(
              "on BattleGetAnsRespondedEvent | going to next round from round $round");
          cancelRoundTimer();
          round += 1;

          emit(BattleShowOpponentAnswerState());
          await Future.delayed(showOpponentAnswerDuration);

          // case: end game
          if (round >= (problems?.length ?? round + 1)) {
            await endGame(event, emit);
          }

          // case: not ending, going to next round
          else {
            await endRound(event, emit);
          }
        }
      } on Exception catch (e) {
        emit(BattleErrorState());
        initialize();
        debugPrint(
            "on BattleGetAnsRespondedEvent | Unexcepted exception occurs: $e");
      }
    });

    /// The following behavior is expected as the event occurs
    /// 1) Emit the BattleWaitingState to the UI code
    /// 2) Start waiting timer
    /// 3) Connect to computer agent if the waiting time is the max waiting time
    on<BattleWaitingEvent>((event, emit) {
      debugPrint("on BattleWaitingEvent | emitting BattleWaitingEvent");
      emit(BattleWaitingState());

      waitingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        waitingTime++;

        if (waitingTime < maxWaitingSecs) return;
        if (!startGameClicked || opponentID != null) return;
        if (waitingTime == maxWaitingSecs) {
          debugPrint("on BattleWaitingEvent | connecting computer agent");
          isOppnComputer = true;
          backendService.connectToComputerSocket(challengeKey!,
              username: computerID, level: challengeLevel);
          waitingTimer?.cancel();
          waitingTimer = null;
        }

        if (waitingTime > maxWaitingSecs) {
          waitingTimer?.cancel();
          waitingTimer = null;
        }
      });
    });

    /// The following behavior is expected as the event occurs
    /// 1) Wait a few seconds just for the UI effect
    /// 2) Emit the BattleStartBattleState
    /// 3) Trigger the BattleRoundStartEvent
    on<BattleStartBattleEvent>((event, emit) async {
      // NOTE: the 'problems' would be decoded in the listener, to save me from passing the decoded data as parameter
      debugPrint(
          "on BattleStartBattleEvent | emitting battle BattleStartBattleState");

      await Future.delayed(
          battlePrepareStartDuration); // wait a few seconds just for the UI effect

      debugPrint("on BattleStartBattleEvent | emitting BattleStartBattleState");
      emit(BattleStartBattleState());

      await Future.delayed(battlePrepareDuration + battleNavPageDuration);

      debugPrint(
          "on BattleStartBattleEvent | triggering BattleRoundStartEvent");
      add(BattleRoundStartEvent());
    });

    /// The following behavior is expected as the event occurs
    /// 1) Emit the BattleNextRoundState
    /// 2) Restart the round timer
    /// 3) Calculate the added score for the computer opponent
    on<BattleRoundStartEvent>((event, emit) async {
      debugPrint("on BattleRoundStartEvent | emitting BattleNextRoundState");

      debugPrint("on BattleRoundStartEvent | round: $round");

      if (round >= 0) emit(BattleNextRoundState(problem: problems![round]));

      var random = Random();
      int oppAnsTime = random.nextInt(10) + 1;

      debugPrint("on BattleRoundStartEvent | restarting round timer");

      leftSec = roundDuration.inSeconds;
      emit(BattleTimerTickedState());

      roundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        leftSec = leftSec! - 1;
        add(BattleTimerTickedEvent());

        if (leftSec == 0) {
          add(BattleTimesUpEvent());
          return;
        }

        // calculate the added score for the computer opponent
        if (leftSec! == oppAnsTime && isOppnComputer) {
          int computerAddedScore =
              (random.nextInt(4) % 4 == 0 ? 0 : calculateAddedScore(leftSec!))
                  .toInt();
          backendService.answer(computerAddedScore, userId: opponentID!);
          return;
        }
      });
    });

    /// The following behavior is expected as the event occurs
    /// 1) Emit the BattleTimerTickedState to the UI code
    on<BattleTimerTickedEvent>((event, emit) {
      debugPrint("on BattleTimerTickedEvent | leftSec: $leftSec");
      emit(BattleTimerTickedState());
    });

    /// The following behavior is expected as the event occurs
    /// 1) Send answer type data with zero score while emitting times up state to the UI code
    on<BattleTimesUpEvent>((event, emit) {
      try {
        debugPrint("on BattleTimesUpEvent | emitting BattleTimesUpEvent");

        cancelRoundTimer();

        if (!hasResponded) {
          hasResponded = true;

          // send message to server
          backendService.answer(0,
              userId: userProvider.userData!.username ??
                  userProvider.userData!.googleUsername!);

          emit(BattleAnsweredState(
            playerAnswered: true,
            playerScore: playerScore,
            isCorrect: false,
            answerIndex: null,
          ));
        }

        if (!opnHasResponded && isOppnComputer) {
          backendService.answer(0, userId: opponentID!);
        }

        // // send message to server
        // backendService.answer(0, null);
      } on Exception catch (e) {
        emit(BattleErrorState());
        initialize();
        debugPrint("on BattleTimesUpEvent | Unexcepted exception occurs: $e");
      }
    });
  }
}
