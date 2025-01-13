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
  late BattleBloc battleBloc;
  late StreamSubscription battleListener;

  @override
  void initState() {
    super.initState();
    battleBloc = context.read<BattleBloc>();

    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleTimerTickedState) {
        setState(() {});
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
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(60, 60),
          painter: TimerPainter(
            seconds: widget.seconds,
            repaint: ValueNotifier<int>(battleBloc.leftSec!),
          ),
        ),
        Text(
          battleBloc.leftSec.toString(),
          style: const TextStyle(
            color: Colors.black45,
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
      ..color = Colors.black26
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
