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

class _ScoreBarState extends State<ScoreBar> with TickerProviderStateMixin {
  int currentScore = 0;
  int previousScore = 0;
  late AnimationController _scoreAnimationController;
  late AnimationController _correctAnimationController;
  late AnimationController _wrongAnimationController;

  late Animation<Color?> _correctColorAnimation;
  late Animation<Color?> _wrongColorAnimation;
  late Animation<Color?> _correctBackgroundColorAnimation;
  late Animation<Color?> _wrongBackgroundColorAnimation;

  // NOTE: changing state internally since we want to have inner animation
  late final BattleBloc battleBloc;
  late final StreamSubscription battleListener;

  @override
  void initState() {
    super.initState();

    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _correctAnimationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _wrongAnimationController = AnimationController(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Color animations
    _correctColorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 185, 211, 144),
      end: const Color.fromARGB(255, 228, 255, 232),
    ).animate(CurvedAnimation(
      parent: _correctAnimationController,
      curve: Curves.easeInOut,
    ));

    _wrongColorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 185, 211, 144),
      end: const Color.fromARGB(255, 161, 0, 0),
    ).animate(CurvedAnimation(
      parent: _wrongAnimationController,
      curve: Curves.easeInOut,
    ));

    _correctBackgroundColorAnimation = ColorTween(
      begin: const Color.fromARGB(108, 158, 158, 158),
      end: const Color.fromARGB(172, 199, 221, 202),
    ).animate(CurvedAnimation(
      parent: _correctAnimationController,
      curve: Curves.easeInOut,
    ));

    _wrongBackgroundColorAnimation = ColorTween(
      begin: const Color.fromARGB(108, 158, 158, 158),
      end: const Color.fromARGB(255, 161, 0, 0),
    ).animate(CurvedAnimation(
      parent: _wrongAnimationController,
      curve: Curves.easeInOut,
    ));

    battleBloc = context.read<BattleBloc>();
    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleAnsweredState) {
        // player score bar state when player answered
        if (state.playerAnswered && widget.isPlayer) {
          setState(() {
            previousScore = currentScore;
            currentScore = state.playerScore!;
          });
          _playAnswerAnimation(state.isCorrect);
        }
        // opponent score bar state when opponent answered
        else if (!state.playerAnswered && !widget.isPlayer) {
          setState(() {
            previousScore = currentScore;
            currentScore = state.opponentScore!;
          });
          _playAnswerAnimation(state.isCorrect);
        }
      }
    });
  }

  void _playAnswerAnimation(bool isCorrect) {
    if (isCorrect) {
      // Correct answer animation
      _correctAnimationController.forward().then((_) {
        _correctAnimationController.reverse();
      });
    } else {
      // Wrong answer animation (includes no answer)
      _wrongAnimationController.forward().then((_) {
        _wrongAnimationController.reverse();
      });
    }

    // Always play the score change animation
    _scoreAnimationController
        .forward()
        .then((_) => _scoreAnimationController.reverse());
  }

  @override
  void dispose() {
    battleListener.cancel();
    _scoreAnimationController.dispose();
    _correctAnimationController.dispose();
    _wrongAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double barHeight = MediaQuery.of(context).size.height * 0.5;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _scoreAnimationController,
        _correctAnimationController,
        _wrongAnimationController,
      ]),
      builder: (context, child) {
        // Determine which animation to use
        Color barColor = const Color.fromARGB(255, 185, 211, 144);
        Color barBackgroundColor = const Color.fromARGB(108, 158, 158, 158);

        if (_correctAnimationController.isAnimating) {
          barColor = _correctColorAnimation.value ?? barColor;
          barBackgroundColor =
              _correctBackgroundColorAnimation.value ?? barBackgroundColor;
        } else if (_wrongAnimationController.isAnimating) {
          barColor = _wrongColorAnimation.value ?? barColor;
          barBackgroundColor =
              _wrongBackgroundColorAnimation.value ?? barBackgroundColor;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add score text above the bar
            SizedBox(
              width: 50,
              child: Text(
                currentScore.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // score bar
            Container(
              height: barHeight,
              width: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: barBackgroundColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  curve: Curves.elasticOut,
                  duration: const Duration(milliseconds: 1500),
                  height: barHeight * currentScore / widget.maxScore,
                  color: barColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
