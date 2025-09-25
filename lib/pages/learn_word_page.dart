import 'dart:async';

import 'package:examKing/blocs/words/words_bloc.dart';
import 'package:examKing/component/back_to_main_button.dart';
import 'package:examKing/component/word_card.dart';
import 'package:examKing/models/level.dart';
import 'package:examKing/models/stat.dart';
import 'package:examKing/models/word.dart';
import 'package:examKing/pages/article_page.dart';
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

  bool isFlipped = false;

  @override
  void initState() {
    super.initState();
    wordsBloc = BlocProvider.of<WordsBloc>(context);
    wordsStateSubscription = wordsBloc.stream.listen((state) {
      if (state is WordsStateGetWord) {
        setState(() {
          isFlipped = false;
        });
      }
    });

    wordsBloc.add(WordsEventLoad(level: widget.level));
  }

  @override
  void dispose() {
    wordsStateSubscription.cancel();
    super.dispose();
  }

  void flipCard() {
    if (isFlipped) return;
    setState(() {
      isFlipped = true;
    });
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
                    const SizedBox(height: 40),
                    Text(
                      widget.level.title,
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 20,
                      ),
                    ),

                    // word card
                    const SizedBox(height: 20),
                    WordCard(
                      word: wordsBloc.currentWord!,
                      isFlipped: isFlipped,
                      onFlip: flipCard,
                    ),

                    // stat card
                    const Spacer(),

                    Container(
                      height: 170,
                      alignment: Alignment.center,
                      child: !isFlipped
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ArticlePage(
                                          level: widget.level,
                                          currentWord:
                                              wordsBloc.currentWord!.word,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 13.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          121, 107, 204, 222),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.article_outlined),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Create Article",
                                          style: GoogleFonts.mandali(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
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
                                ),
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Row(
                                children: [
                                  WordCardActionButton(
                                      label: "Unfamiliar",
                                      icon: Icons.close,
                                      color: const Color.fromARGB(
                                          255, 252, 152, 122),
                                      onTap: () {
                                        wordsBloc.add(WordsEventResponded(
                                            isKnown: false,
                                            word: wordsBloc.currentWord!.word));
                                        setState(() {});
                                      }),
                                  const Spacer(),
                                  WordCardActionButton(
                                      label: "Knew",
                                      icon: Icons.check,
                                      color: const Color.fromARGB(
                                          255, 122, 211, 20),
                                      onTap: () {
                                        wordsBloc.add(WordsEventResponded(
                                            isKnown: true,
                                            word: wordsBloc.currentWord!.word));
                                        setState(() {});
                                      }),
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 20),
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
                            const Color.fromARGB(255, 56, 56, 56),
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

class WordCardActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const WordCardActionButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
