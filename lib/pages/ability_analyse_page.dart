import 'dart:async';
import 'dart:math';

import 'package:examKing/blocs/main/main_bloc.dart';
import 'package:examKing/global/properties.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:examKing/models/ability_record.dart';
import 'package:google_fonts/google_fonts.dart';

class AbilityAnalysePage extends StatefulWidget {
  const AbilityAnalysePage({super.key});

  @override
  State<AbilityAnalysePage> createState() => _AbilityAnalysePageState();
}

class _AbilityAnalysePageState extends State<AbilityAnalysePage> {
  late final MainBloc mainBloc;
  late final StreamSubscription mainBlocListener;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    mainBloc = context.read<MainBloc>();
    mainBloc.add(MainEventGetRecord());

    mainBlocListener = mainBloc.stream.listen((state) {
      if (state is MainStateGetRecords) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    mainBlocListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return loadingPage(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '能力分析',
          style: GoogleFonts.yuseiMagic(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildRadarChart(),
            const SizedBox(height: 20),
            _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  Widget loadingPage(BuildContext context) {
    return Container();
  }

  Widget _buildRadarChart() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        child: RadarChart(
          RadarChartData(
            radarShape: RadarShape.circle,
            radarBackgroundColor: const Color.fromARGB(40, 76, 175, 80), // Light green background
            ticksTextStyle: const TextStyle(
              color: Colors.transparent,
            ),
            tickBorderData: const BorderSide(
              color: Color.fromARGB(255, 129, 199, 132), // Lighter green for ticks
              width: 0.5,
            ),
            gridBorderData: BorderSide(
              color: const Color.fromARGB(255, 0, 204, 10).withOpacity(0.5), // Darker green for grid
              width: 1.5,
            ),
            titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 11, 50, 22),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'PressStart2P',
              decoration: TextDecoration.none,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
            dataSets: [
              RadarDataSet(
                fillColor: const Color.fromARGB(172, 87, 255, 93).withOpacity(0.6), // Soft green fill
                borderColor: const Color.fromARGB(255, 125, 255, 166), // Strong green border
                entryRadius: 4,
                borderWidth: 2.5,
                dataEntries: List<RadarEntry>.from(mainBloc.abilityRecords!.map((e) => RadarEntry(value: e.correctRate))),
              ),
            ],
            getTitle: (index, angle) {
              String fieldKey = mainBloc.abilityRecords![index].field;
              return RadarChartTitle(text: challenges[fieldKey]!.name, angle: angle);
            },
            borderData: FlBorderData(
              show: false,
              border: Border.all(
                color: const Color.fromARGB(255, 27, 94, 32), // Dark green border
                width: 2,
              ),
            ),
            tickCount: 4, // Changed to 4 for more detailed gradations
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: mainBloc.abilityRecords!.length,
        itemBuilder: (context, index) {
          final record = mainBloc.abilityRecords![index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AbilityStatCard(record: record),
          );
        },
      ),
    );
  }
}

class AbilityStatCard extends StatelessWidget {
  final AbilityRecord record;

  const AbilityStatCard({
    super.key,
    required this.record,
  });

  Color _getEvaluationColor(double score) {
    if (score >= 0.9) return const Color.fromARGB(255, 171, 60, 202);
    if (score >= 0.7) return const Color.fromARGB(255, 124, 227, 113);
    if (score >= 0.5) return const Color.fromARGB(255, 240, 188, 105);
    if (score >= 0.35) return const Color.fromARGB(255, 94, 94, 94);
    return Colors.redAccent;
  }

  double _calculateScore() {
    // Weight: 70% correctRate, 30% normalized total correct count
    final normalizedTotalCorrect = min(1.0, record.totCorrect / 50); // Normalize with max 50 questions
    return (record.correctRate * 0.6) + (normalizedTotalCorrect * 0.4);
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    final totalAnswered = record.totCorrect + record.totWrong;

    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 143, 143, 143),
      shadowColor: const Color.fromARGB(137, 122, 122, 122),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    challenges[record.field]!.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: '${record.totCorrect}',
                          style: TextStyle(
                            color: _getEvaluationColor(score),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' / $totalAnswered',
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                  tween: Tween<double>(begin: 0.0, end: score),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, double value, child) {
                    return FractionallySizedBox(
                      widthFactor: value,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getEvaluationColor(score),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: _getEvaluationColor(score).withOpacity(0.6),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
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
      ),
    );
  }
}
