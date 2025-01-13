import 'dart:async';

import 'package:examKing/blocs/words/words_bloc.dart';
import 'package:examKing/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WordCard extends StatefulWidget {
  final Word word;
  const WordCard({super.key, required this.word});

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  late final WordsBloc wordsBloc;
  late final StreamSubscription<WordsState> wordsStateSubscription;

  bool isFlipped = false;

  void flipCard() {
    if (isFlipped) return;
    setState(() {
      isFlipped = true;
    });
  }

  @override
  void initState() {
    super.initState();
    wordsBloc = context.read<WordsBloc>();
    wordsStateSubscription = wordsBloc.stream.listen((state) {
      if (state is WordsStateGetWord) {
        setState(() {
          isFlipped = false;
        });
      }
    });
  }

  @override
  void dispose() {
    wordsStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: Container(
        height: 350,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isFlipped
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.word.translation,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          widget.word.partOfSpeech,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.word.definition,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.word.example,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      WordCardActionButton(
                          label: "Unfamiliar",
                          icon: Icons.close,
                          color: const Color.fromARGB(255, 252, 152, 122),
                          onTap: () {
                            // TODO: trigger bloc event, where we
                            // 1) first update the word locally
                            // 2) then get a new word, and emit state that set isFlipped to false
                            // 3) finally send update to the server
                            wordsBloc.add(WordsEventResponded(isKnown: false, word: widget.word.word));
                            setState(() {
                              isFlipped = false;
                            });
                          }),
                      WordCardActionButton(
                          label: "Knew",
                          icon: Icons.check,
                          color: const Color.fromARGB(255, 122, 211, 20),
                          onTap: () {
                            // TODO: trigger bloc event, where we
                            // 1) first update the word locally
                            // 2) then get a new word, and emit state that set isFlipped to false
                            // 3) finally send update to the server
                            wordsBloc.add(WordsEventResponded(isKnown: true, word: widget.word.word));
                            setState(() {
                              isFlipped = false;
                            });
                          }),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: widget.word.isLearned ? const Color.fromARGB(255, 158, 199, 231) : const Color.fromARGB(255, 233, 158, 152),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        widget.word.isLearned ? "Learned" : "Reviewing",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.word.word,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tap to see definition",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color.fromARGB(216, 168, 168, 168),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
      ),
    );
  }
}

class WordCardActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const WordCardActionButton({super.key, required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
