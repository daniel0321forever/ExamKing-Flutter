import 'dart:math';

import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Histogram extends StatefulWidget {
  const Histogram({super.key});

  @override
  State<Histogram> createState() => _HistogramState();
}

class _HistogramState extends State<Histogram> {
  final scrollController = ScrollController();
  late final GlobalProvider globalProvider;
  @override
  void initState() {
    super.initState();
    globalProvider = context.read<GlobalProvider>();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Consumer<GlobalProvider>(
            builder: (context, value, child) {
              if (value.wordProgress == null) {
                return buildShimmer();
              }
              return SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: globalProvider.wordProgress!.map((value) {
                    return BarWidget(
                        date: DateTime.now().subtract(Duration(days: globalProvider.wordProgress!.length - globalProvider.wordProgress!.indexOf(value))),
                        value: value);
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return Container(
                width: 50,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 50,
                    height: 150,
                    color: Colors.grey.shade300,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class BarWidget extends StatefulWidget {
  final DateTime date;
  final int value;
  const BarWidget({super.key, required this.date, required this.value});

  @override
  State<BarWidget> createState() => _BarWidgetState();
}

class _BarWidgetState extends State<BarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color color = Colors.black;
  bool _isHeld = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.value <= 10) {
      color = const Color.fromARGB(255, 228, 155, 150);
    } else if (widget.value >= 70) {
      color = const Color.fromARGB(255, 130, 206, 236);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isHeld = true;
    });
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isHeld = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // value
          Container(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.value.toString(),
              style: GoogleFonts.girassol(color: Colors.black, fontSize: 12),
            ),
          ),

          // bar
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 60,
              height: min(widget.value * 2, 100 * 2),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: color,
                gradient: widget.value >= 70
                    ? LinearGradient(
                        colors: [color, color.withOpacity(0.5)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // date
          const SizedBox(height: 4),
          Text(
            "${widget.date.month}/${widget.date.day}",
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
