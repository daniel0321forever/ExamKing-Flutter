import 'dart:async';
import 'dart:math';

import 'package:examKing/blocs/analysis/analysis_bloc.dart';
import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/component/histogram.dart';
import 'package:examKing/component/radar_chart.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/stat.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:examKing/models/ability_record.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:examKing/global/keys.dart' as keys;
import 'package:examKing/global/enumerator.dart';
import 'package:examKing/component/trend_chart.dart';

class AbilityAnalysePage extends StatefulWidget {
  const AbilityAnalysePage({super.key});

  @override
  State<AbilityAnalysePage> createState() => _AbilityAnalysePageState();
}

class _AbilityAnalysePageState extends State<AbilityAnalysePage> {
  late final AnalysisBloc analysisBloc;
  late final StreamSubscription<AnalysisState> analysisSubscription;
  ChartType chartType = ChartType.dailyWords;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    analysisBloc = context.read<AnalysisBloc>();
    analysisSubscription = analysisBloc.stream.listen((state) {
      if (state is AnalysisStateCompleteLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
    analysisBloc.add(AnalysisEventLoading());
  }

  @override
  void dispose() {
    analysisSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? loadingPage(context)
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_left),
                        onPressed: () {
                          setState(() {
                            if (chartType == ChartType.dailyWords) {
                              chartType = ChartType.radar;
                            } else if (chartType == ChartType.correctRateTrend) {
                              chartType = ChartType.dailyWords;
                            } else if (chartType == ChartType.radar) {
                              chartType = ChartType.correctRateTrend;
                            }
                          });
                        },
                      ),
                      switch (chartType) {
                        ChartType.dailyWords => Text(
                            "Daily Words Progress",
                            style: GoogleFonts.barlowCondensed(color: Colors.black, fontSize: 27),
                          ),
                        ChartType.correctRateTrend => Text(
                            "Correct Rate Trend",
                            style: GoogleFonts.barlowCondensed(color: Colors.black, fontSize: 27),
                          ),
                        ChartType.radar => Text(
                            "Ability Radar",
                            style: GoogleFonts.barlowCondensed(color: Colors.black, fontSize: 27),
                          ),
                        _ => const SizedBox.shrink(),
                      },
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {
                          setState(() {
                            if (chartType == ChartType.dailyWords) {
                              chartType = ChartType.correctRateTrend;
                            } else if (chartType == ChartType.correctRateTrend) {
                              chartType = ChartType.radar;
                            } else if (chartType == ChartType.radar) {
                              chartType = ChartType.dailyWords;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // histogram
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: switch (chartType) {
                      ChartType.dailyWords => Histogram(),
                      ChartType.correctRateTrend => TrendChart(),
                      ChartType.radar => Container(),
                    },
                  ),

                  const SizedBox(height: 40),
                  _buildStatsGrid(),
                ],
              ),
            ),
    );
  }

  Widget loadingPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/exam_king_radar.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 5),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Calculating...',
                speed: const Duration(milliseconds: 30),
                textStyle: GoogleFonts.pressStart2p(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 104, 167, 106),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            isRepeatingAnimation: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: analysisBloc.stats!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: StatCard(
              stat: analysisBloc.stats![index],
            ),
          );
        },
      ),
    );
  }
}

class StatCard extends StatefulWidget {
  final Stat stat;
  const StatCard({super.key, required this.stat});

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
                style: GoogleFonts.barlowCondensed(color: Colors.black, fontSize: 19),
              ),
              const Spacer(),
              Text(
                "${widget.stat.val}",
                style: GoogleFonts.barlowCondensed(color: Colors.black, fontSize: 27),
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
                tween: Tween<double>(begin: 0.0, end: widget.stat.val / widget.stat.maxVal),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, double value, child) {
                  return FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 158, 199, 231),
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
