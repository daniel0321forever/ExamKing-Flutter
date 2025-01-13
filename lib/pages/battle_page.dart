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

// Add this new widget at the top level of the file, outside the BattlePage class
class NextRoundAnimation extends StatefulWidget {
  const NextRoundAnimation({super.key});

  @override
  State<NextRoundAnimation> createState() => _NextRoundAnimationState();
}

class _NextRoundAnimationState extends State<NextRoundAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: BattleBloc.showNextRoundLabelDuration,
    );

    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(-1.5, 0),
          end: const Offset(0, 0),
        ),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, 0),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(1.5, 0),
        ),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.7),
                  Colors.blue.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Next Round",
                  style: GoogleFonts.pressStart2p(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black.withOpacity(0.7),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BattlePage extends StatefulWidget {
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> with SingleTickerProviderStateMixin {
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
        bool isCorrect = state.isCorrect;
        setState(() {
          if (isCorrect) {
            _showCorrectOverlay = true;
            _showWrongOverlay = false;
          } else {
            _showCorrectOverlay = false;
            _showWrongOverlay = true;
          }
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BattleResultPage()));
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
                if (_showNextRoundText) const NextRoundAnimation(),
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
          color: Colors.green.withOpacity(0.3 * (1 - _animationController.value)),
          child: Center(
            child: Transform.scale(
              scale: 1 + _animationController.value,
              child: const Icon(Icons.check_circle, color: Colors.green, size: 100),
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
          color: Colors.red.withOpacity(0.3 * (1 - _animationController.value)),
          child: Center(
            child: Transform.scale(
              scale: 1 + _animationController.value * 0.3,
              child: Icon(
                Icons.close,
                color: Colors.white.withOpacity(0.8 * (1 - _animationController.value)),
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
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage('https://i.pinimg.com/originals/62/f6/0e/62f60eb00055ce5a3580bd91559f9f94.gif'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: Text(
                  problem!.problem,
                  style: GoogleFonts.notoSansMono(
                    fontSize: 15,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    // shadows: [
                    //   Shadow(
                    //     blurRadius: 3.0,
                    //     color: Colors.black.withOpacity(0.5),
                    //     offset: const Offset(1.0, 1.0),
                    //   ),
                    // ],
                  ),
                ),
              ),

              // score bar and options
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // player score bar
                  const ScoreBar(maxScore: 1000, isPlayer: true),

                  // option tiles
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      problem!.options.length,
                      (i) => OptionTile(optionTitle: problem!.options[i].description, optionIndex: i),
                    ),
                  ),

                  // opponent score bar
                  const ScoreBar(maxScore: 1000, isPlayer: false),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
