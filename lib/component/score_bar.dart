import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:examKing/blocs/battle/battle_bloc.dart';

class ScoreBar extends StatefulWidget {
  final int maxScore;
  final bool isPlayer;
  const ScoreBar({super.key, required this.maxScore, required this.isPlayer});

  @override
  State<ScoreBar> createState() => _ScoreBarState();
}

class _ScoreBarState extends State<ScoreBar> {
  final double barHeight = 400;
  int currentScore = 0;

  // NOTE: changing state internally sincce we want to have inner animation
  late final BattleBloc battleBloc;
  late final StreamSubscription battleListener;

  @override
  void initState() {
    super.initState();
    battleBloc = context.read<BattleBloc>();
    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleAnsweredState) {
        if (state.playerAnswered && widget.isPlayer) {
          setState(() {
            debugPrint("player score: ${state.playerScore}");
            currentScore = state.playerScore!;
          });
        } else if (!state.playerAnswered && !widget.isPlayer) {
          setState(() {
            currentScore = state.opponentScore!;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    battleListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: barHeight,
        width: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(111, 255, 236, 236),
        ),
        clipBehavior: Clip.hardEdge,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            curve: Curves.bounceOut,
            duration: const Duration(milliseconds: 700),
            height: barHeight * currentScore / widget.maxScore,
            color: const Color.fromARGB(255, 255, 218, 243),
          ),
        ));
  }
}
