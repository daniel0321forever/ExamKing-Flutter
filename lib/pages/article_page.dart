import 'dart:async';

import 'package:examKing/blocs/article/article_bloc.dart';
import 'package:examKing/component/back_to_main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ArticlePage extends StatefulWidget {
  final int level;
  const ArticlePage({super.key, required this.level});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late final ArticleBloc articleBloc;
  late final StreamSubscription<ArticleState> articleStateSubscription;

  @override
  void initState() {
    super.initState();

    articleBloc = context.read<ArticleBloc>();
    articleStateSubscription = articleBloc.stream.listen((state) {
      if (state is ArticleStateGetArticle) {
        setState(() {});
      }
    });

    articleBloc.add(ArticleEventLoad(level: widget.level));
  }

  @override
  void dispose() {
    articleStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // back button
                const SizedBox(height: 20),
                AnimatedBackButton(
                  onBack: () {
                    articleBloc.add(ArticleEventLeave());
                    Navigator.pop(context);
                  },
                ),

                // level title
                const SizedBox(height: 20),
                Text(
                  "Reviewing Article",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 25,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "Level ${widget.level}",
                  style: GoogleFonts.barlowCondensed(fontSize: 18),
                ),

                // article
                const SizedBox(height: 20),
                articleBloc.article == null
                    ? _buildLoading()
                    : RichText(
                        text: TextSpan(
                          children: articleBloc.article!.map((part) {
                            return TextSpan(
                              text: part.content,
                              style: part.word == null
                                  ? GoogleFonts.crimsonPro(
                                      fontSize: 18,
                                      color: const Color.fromARGB(255, 37, 37, 37),
                                    )
                                  : GoogleFonts.crimsonPro(
                                      fontSize: 19,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                    ),
                            );
                          }).toList(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Lottie.asset(
        'assets/text_generation.json',
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
    );
  }
}
