import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:examKing/blocs/battle/battle_bloc.dart';

/// TimerWidget would add times up event as it reach the time limit
class TimerWidget extends StatefulWidget {
  final int seconds;
  const TimerWidget({super.key, required this.seconds});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with TickerProviderStateMixin {
  late BattleBloc battleBloc;
  late StreamSubscription battleListener;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  bool isShowingNextRoundAnimation = false;

  @override
  void initState() {
    super.initState();
    battleBloc = context.read<BattleBloc>();

    // Initialize animation controllers
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create animations
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    battleListener = battleBloc.stream.listen((state) {
      if (state is BattleTimerTickedState) {
        setState(() {});
      } else if (state is BattleShowNextRoundLabelState) {
        _startNextRoundAnimation();
      }
    });
  }

  void _startNextRoundAnimation() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
    _rotationController.forward().then((_) {
      _rotationController.reset();
    });
  }

  @override
  void dispose() {
    battleListener.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(60, 60),
                  painter: TimerPainter(
                    seconds: widget.seconds,
                    repaint: ValueNotifier<int>(battleBloc.leftSec!),
                  ),
                ),
                Transform.rotate(
                  angle: -_rotationAnimation
                      .value, // Counter-rotate the text to keep it upright
                  child: Text(
                    battleBloc.leftSec.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimerPainter extends CustomPainter {
  final ValueNotifier<int> repaint;
  final int seconds;

  TimerPainter({required this.repaint, required this.seconds})
      : super(repaint: repaint);

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
