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

class _ScoreBarState extends State<ScoreBar> with SingleTickerProviderStateMixin {
  final double barHeight = 400;
  int currentScore = 0;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // NOTE: changing state internally since we want to have inner animation
  late final BattleBloc battleBloc;
  late final StreamSubscription battleListener;

  @override
  void initState() {
    super.initState();
    battleBloc = context.read<BattleBloc>();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleAnsweredState) {
        if (state.playerAnswered && widget.isPlayer) {
          setState(() {
            currentScore = state.playerScore!;
          });
          _glowController.forward().then((_) => _glowController.reverse());
        } else if (!state.playerAnswered && !widget.isPlayer) {
          setState(() {
            currentScore = state.opponentScore!;
          });
          _glowController.forward().then((_) => _glowController.reverse());
        }
      }
    });
  }

  @override
  void dispose() {
    battleListener.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Add score text above the bar
        SizedBox(
          width: 45,
          child: Text(
            currentScore.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          height: barHeight,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(108, 158, 158, 158),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  curve: Curves.elasticOut,
                  duration: const Duration(milliseconds: 1500),
                  height: barHeight * currentScore / widget.maxScore,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
