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
  static const Color initialColor = Color.fromARGB(129, 145, 145, 145);
  Color color = initialColor;

  late BattleBloc battleBloc;
  late StreamSubscription<BattleState> battleListener;
  bool isTapped = false;

  void initialize() {
    setState(() {
      isTapped = false;
      color = initialColor;
    });
  }

  @override
  void initState() {
    battleBloc = context.read<BattleBloc>();
    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleAnsweredState) {
        if (state.playerAnswered && isTapped) {
          bool isCorrect = state.isCorrect;
          setState(() {
            color = isCorrect ? const Color.fromARGB(164, 80, 139, 82) : const Color.fromARGB(190, 134, 48, 42);
          });
        } else if (!state.playerAnswered) {
          // opponent answered
          debugPrint("on BattleAnsweredState | opponent answered with index: ${state.answerIndex}");
          // TODO: show opponent answer when problem end, probably need another state
        }
      } else if (state is BattleNewProblemReadyState) {
        initialize();
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
      child: Container(
        alignment: Alignment.center,
        height: 70,
        width: MediaQuery.of(context).size.width * 0.8 - 20,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Text(
          widget.optionTitle,
          style: GoogleFonts.notoSansMono(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
