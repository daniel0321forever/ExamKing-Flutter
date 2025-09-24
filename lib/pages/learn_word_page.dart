import 'dart:async';

import 'package:examKing/blocs/words/words_bloc.dart';
import 'package:examKing/component/back_to_main_button.dart';
import 'package:examKing/component/word_card.dart';
import 'package:examKing/models/level.dart';
import 'package:examKing/models/stat.dart';
import 'package:examKing/models/word.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class LearnWordPage extends StatefulWidget {
  final Level level;
  const LearnWordPage({super.key, required this.level});

  @override
  State<LearnWordPage> createState() => _LearnWordPageState();
}

class _LearnWordPageState extends State<LearnWordPage> {
  late final WordsBloc wordsBloc;
  late final StreamSubscription<WordsState> wordsStateSubscription;

  @override
  void initState() {
    super.initState();
    wordsBloc = BlocProvider.of<WordsBloc>(context);
    wordsStateSubscription = wordsBloc.stream.listen((state) {
      if (state is WordsStateGetWord) {
        setState(() {});
      }
    });

    wordsBloc.add(WordsEventLoad(level: widget.level));
  }

  @override
  void dispose() {
    wordsStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: wordsBloc.currentWord == null
              ? _buildShimmer()
              : Column(
                  children: [
                    // back button
                    const SizedBox(height: 20),
                    const AnimatedBackButton(),

                    // level title
                    const SizedBox(height: 20),
                    Text(
                      widget.level.title,
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 20,
                      ),
                    ),

                    // word card
                    const SizedBox(height: 20),
                    WordCard(word: wordsBloc.currentWord!),

                    // stat card
                    const SizedBox(height: 50),
                    StatCard(
                      stat: Stat(
                        key: "Reviewing",
                        title: "Reviewing",
                        val: wordsBloc.currentLearned.toDouble(),
                        maxVal: wordsBloc.words!.length.toDouble(),
                      ),
                    ),

                    // not remembered stat card
                    const SizedBox(height: 20),
                    StatCard(
                      stat: Stat(
                        key: "Learning",
                        title: "Learning",
                        val: wordsBloc.currentUnfamiliar.toDouble(),
                        maxVal: wordsBloc.words!.length.toDouble(),
                      ),
                      color: const Color.fromARGB(255, 233, 158, 152),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          // back button
          const SizedBox(height: 20),
          const AnimatedBackButton(),

          // level title
          const SizedBox(height: 20),
          Text(
            "Level ${widget.level.level + 1}",
            style: GoogleFonts.barlowCondensed(
              fontSize: 20,
            ),
          ),

          // word card
          const SizedBox(height: 40),
          SizedBox(
            height: 100,
            width: 100,
          ),

          // stat card
          const SizedBox(height: 50),
          StatCard(
            stat: Stat(
              key: "Reviewing",
              title: "Reviewing",
              val: 2,
              maxVal: 10,
            ),
          ),

          // not remembered stat card
          const SizedBox(height: 20),
          StatCard(
            stat: Stat(
              key: "Learning",
              title: "Learning",
              val: 2,
              maxVal: 10,
            ),
            color: const Color.fromARGB(255, 233, 158, 152),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatefulWidget {
  final Stat stat;
  final Color? color;
  const StatCard({super.key, required this.stat, this.color});

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.stat.title,
                style: GoogleFonts.barlowCondensed(
                    color: Colors.black, fontSize: 19),
              ),
              const Spacer(),
              Text(
                "${(widget.stat.val).toInt()}/${widget.stat.maxVal.toInt()}",
                style: GoogleFonts.barlowCondensed(
                    color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(79, 255, 255, 255),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(
                    begin: 0.0, end: widget.stat.val / widget.stat.maxVal),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, double value, child) {
                  return FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.color ??
                            const Color.fromARGB(255, 158, 199, 231),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(146, 158, 199, 231),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
