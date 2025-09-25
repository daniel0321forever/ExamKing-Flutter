import 'dart:async';

import 'package:examKing/blocs/words/words_bloc.dart';
import 'package:examKing/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WordCard extends StatefulWidget {
  final Word word;
  final bool isFlipped;
  final VoidCallback onFlip;
  const WordCard({
    super.key,
    required this.word,
    required this.isFlipped,
    required this.onFlip,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  late final WordsBloc wordsBloc;
  late final StreamSubscription<WordsState> wordsStateSubscription;

  @override
  void initState() {
    super.initState();
    wordsBloc = context.read<WordsBloc>();
    wordsStateSubscription = wordsBloc.stream.listen((state) {});
  }

  @override
  void dispose() {
    wordsStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "the fucking word: ${widget.word.word} | is learned: ${widget.word.isLearned} | seen count: ${widget.word.seenCount}");

    return GestureDetector(
      onTap: widget.onFlip,
      child: Container(
        height: 400,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.isFlipped
            ?
            // flipped card
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // part of speech
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          '${widget.word.partOfSpeech}.',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(177, 77, 77, 77),
                          ),
                        ),
                      ),

                      // word
                      const SizedBox(width: 10),
                      Text(
                        widget.word.word,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(177, 77, 77, 77),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),

                  // translation
                  const SizedBox(height: 10),
                  Text(
                    widget.word.translation,
                    style: GoogleFonts.inter(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // example
                  const SizedBox(height: 20),
                  Text(
                    widget.word.example,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  // action buttons
                  const Spacer(),
                ],
              )
            :
            // unflipped card
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // level and word
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: widget.word.seenCount > 0
                            ? widget.word.isLearned
                                ? const Color.fromARGB(255, 158, 199, 231)
                                : const Color.fromARGB(255, 233, 158, 152)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        widget.word.seenCount > 0
                            ? widget.word.isLearned
                                ? "Reviewing"
                                : "Learning"
                            : "New",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // example
                  const SizedBox(height: 10),
                  Text(
                    widget.word.word,
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // tap to see definition
                  const SizedBox(height: 10),
                  Text(
                    "Tap to see definition",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color.fromARGB(216, 168, 168, 168),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
