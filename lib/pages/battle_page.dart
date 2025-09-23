import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:examKing/blocs/battle/battle_bloc.dart';
import 'package:examKing/component/battle_avatar.dart';
import 'package:examKing/component/option_tile.dart';
import 'package:examKing/component/score_bar.dart';
import 'package:examKing/component/timer.dart';
import 'package:examKing/models/problem.dart';
import 'package:examKing/pages/battle_result_page.dart';
import 'package:google_fonts/google_fonts.dart';

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage>
    with SingleTickerProviderStateMixin {
  Problem? problem;
  late final BattleBloc battleBloc;
  late final StreamSubscription battleListener;
  late final AnimationController _animationController;
  bool _showCorrectOverlay = false;
  bool _showWrongOverlay = false;
  bool _showNextRoundText = false;

  @override
  void initState() {
    super.initState();
    battleBloc = context.read<BattleBloc>();
    problem = battleBloc.problems![0];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleAnsweredState) {
        // Only show overlay animations for the player's answers
        if (state.playerAnswered) {
          bool isCorrect = state.isCorrect;
          setState(() {
            _showCorrectOverlay = isCorrect;
            _showWrongOverlay = !isCorrect;
          });

          _animationController.forward(from: 0).then((_) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  _showCorrectOverlay = false;
                  _showWrongOverlay = false;
                });
              }
            });
          });
        }
      } else if (state is BattleShowNextRoundLabelState) {
        if (mounted) {
          setState(() {
            _showNextRoundText = true;
          });
        }
      } else if (state is BattleNextRoundState) {
        if (mounted) {
          setState(() {
            _showNextRoundText = false;
            problem = state.problem;
          });
        }
      } else if (state is BattleEndGameState) {
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const BattleResultPage()));
        }
      }
    });
  }

  @override
  void dispose() {
    battleListener.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (problem != null) {
            return Stack(
              children: [
                generalView(context),
                if (_showCorrectOverlay) correctAnimation(context),
                if (_showWrongOverlay) wrongAnimation(context),
                // if (_showNextRoundText) const NextRoundAnimation(),
              ],
            );
          }
          return loadingView(context);
        },
      ),
    );
  }

  Widget correctAnimation(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          color: const Color.fromARGB(255, 154, 194, 89)
              .withOpacity(0.3 * (1 - _animationController.value)),
          child: Center(
            child: Transform.scale(
              scale: 1 + _animationController.value,
              child: const Icon(Icons.check_circle,
                  color: Color.fromARGB(255, 157, 223, 96), size: 100),
            ),
          ),
        );
      },
    );
  }

  Widget wrongAnimation(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          color: const Color.fromARGB(255, 161, 66, 59)
              .withOpacity(0.6 * (1 - _animationController.value)),
          child: Center(
            child: Transform.scale(
              scale: 1 + _animationController.value * 0.3,
              child: Icon(
                Icons.close,
                color: Colors.white
                    .withOpacity(0.8 * (1 - _animationController.value)),
                size: 100,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loadingView(BuildContext context) {
    return const Center(
      child: Text("loading, which should not"),
    );
  }

  Widget generalView(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://i.pinimg.com/originals/62/f6/0e/62f60eb00055ce5a3580bd91559f9f94.gif'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Color.fromARGB(120, 50, 50, 50),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // avatars and timer
              const SizedBox(height: 20),
              const Row(
                children: [
                  BattleAvatar(image: AssetImage('assets/player1.webp')),
                  Spacer(),
                  TimerWidget(seconds: 10),
                  Spacer(),
                  BattleAvatar(image: AssetImage('assets/player2.webp')),
                ],
              ),

              // problem
              const Spacer(),
              if (!_showNextRoundText)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Text(
                    problem!.problem,
                    style: GoogleFonts.josefinSans(
                      fontSize: 21,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ),

              // score bar and options
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // player score bar
                  const ScoreBar(maxScore: 1000, isPlayer: true),

                  // option tiles
                  Column(
                    children: List.generate(
                      problem!.options.length,
                      (i) => OptionTile(
                          optionTitle: problem!.options[i].description,
                          optionIndex: i),
                    ),
                  ),

                  // opponent score bar
                  const ScoreBar(maxScore: 1000, isPlayer: false),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
