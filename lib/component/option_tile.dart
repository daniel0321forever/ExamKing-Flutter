import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:examKing/blocs/battle/battle_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionTile extends StatefulWidget {
  final String optionTitle;
  final int optionIndex;
  const OptionTile({super.key, required this.optionTitle, required this.optionIndex});

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  static const Color initialColor = Color.fromARGB(129, 96, 94, 94);
  static const Color correctColor = Color.fromARGB(197, 108, 126, 92);
  static const Color wrongColor = Color.fromARGB(255, 154, 3, 0);
  Color color = initialColor;

  late BattleBloc battleBloc;
  late StreamSubscription<BattleState> battleListener;

  bool? opponentTappedCorrect;
  bool isTapped = false;

  Widget? _playerIcon;
  Widget? _opponentIcon;

  void initialize() {
    setState(() {
      isTapped = false;
      color = initialColor;
      opponentTappedCorrect = null;
      _playerIcon = null;
      _opponentIcon = null;
    });
  }

  void showAnswer() {
    if (opponentTappedCorrect != null) {
      setState(() {
        if (opponentTappedCorrect!) {
          color = correctColor;
          _opponentIcon = const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 24,
          );
        } else {
          color = wrongColor;
          _opponentIcon = const Icon(
            Icons.cancel,
            color: Colors.white,
            size: 24,
          );
        }
      });
    }

    if (battleBloc.problems![battleBloc.round - 1].options[widget.optionIndex].correct) {
      setState(() {
        color = correctColor;
      });
    }
  }

  @override
  void initState() {
    battleBloc = context.read<BattleBloc>();
    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleAnsweredState) {
        // NOTE: player tapped
        if (state.playerAnswered && isTapped) {
          setState(() {
            color = state.isCorrect ? correctColor : wrongColor;
            _playerIcon = Icon(
              state.isCorrect ? Icons.check_circle : Icons.cancel,
              color: Colors.white,
              size: 24,
            );
          });
        }

        // NOTE: opponent tapped
        else if (!state.playerAnswered && state.answerIndex == widget.optionIndex) {
          setState(() {
            opponentTappedCorrect = state.isCorrect;
          });
        }
      } else if (state is BattleRoundFinishState) {
        showAnswer();
      } else if (state is BattleNewProblemReadyState) {
        initialize();
      } else if (state is BattleEndGameState) {
        showAnswer();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    battleListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!battleBloc.hasResponded) {
          isTapped = true;
          battleBloc.add(BattleAnswerEvent(answerIndex: widget.optionIndex));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        height: 70,
        width: MediaQuery.of(context).size.width * 0.8 - 20,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Row(
          children: [
            SizedBox(width: 24, child: _playerIcon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.optionTitle,
                style: GoogleFonts.notoSansMono(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(width: 24, child: _opponentIcon),
          ],
        ),
      ),
    );
  }
}
