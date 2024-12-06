import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:examKing/styling/painters.dart';
import 'package:examKing/blocs/battle/battle_bloc.dart';

/// TimerWidget would add times up event as it reach the time limit
class TimerWidget extends StatefulWidget {
  final int seconds;
  const TimerWidget({super.key, required this.seconds});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int leftSec;
  late BattleBloc battleBloc;
  late StreamSubscription battleListener;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (leftSec == 0) {
          if (!battleBloc.hasResponded) battleBloc.add(BattleTimesUpEvent());
          timer.cancel();
          return;
        }
        setState(() {
          leftSec -= 1;
        });
      },
    );
    setState(() {
      leftSec = widget.seconds;
    });
  }

  @override
  void initState() {
    super.initState();

    leftSec = widget.seconds;
    battleBloc = context.read<BattleBloc>();

    startTimer();

    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleNewProblemState) {
        debugPrint("battle new problem in timer");
        timer?.cancel();
        timer = null;
      } else if (state is BattleNewProblemReadyState) {
        debugPrint("battle new problem in timer");
        startTimer();
      } else if (state is BattleEndGameState) {
        timer?.cancel();
        timer = null;
      }
    });
  }

  @override
  void dispose() {
    battleListener.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(60, 60),
          painter: TimerPainter(
            seconds: widget.seconds,
            repaint: ValueNotifier<int>(leftSec),
          ),
        ),
        Text(
          leftSec.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class TimerPainter extends CustomPainter {
  final ValueNotifier<int> repaint;
  final int seconds;

  TimerPainter({required this.repaint, required this.seconds}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * repaint.value / seconds, // Draw arc based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
