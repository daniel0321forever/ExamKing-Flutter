import 'package:examKing/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class TrendChart extends StatefulWidget {
  const TrendChart({super.key});

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  late final GlobalProvider globalProvider;
  List<List<double>> correctRates = [
    List<double>.generate(7, (index) => 0),
  ];

  List<Color> lineColors = [
    const Color.fromARGB(255, 228, 170, 225),
    const Color.fromARGB(255, 105, 119, 156),
    const Color.fromARGB(255, 184, 228, 170),
    const Color.fromARGB(255, 228, 186, 132),
  ];

  Future<void> animateToData(List<List<double>> newCorrectRates) async {
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      correctRates = newCorrectRates;
    });
  }

  @override
  void initState() {
    super.initState();
    globalProvider = context.read<GlobalProvider>();

    if (globalProvider.correctRates != null) {
      animateToData(globalProvider.correctRates!);
    }

    globalProvider.addListener(globalProviderListener);
  }

  void globalProviderListener() {
    if (globalProvider.correctRates != null) {
      animateToData(globalProvider.correctRates!);
    }
  }

  @override
  void dispose() {
    globalProvider.removeListener(globalProviderListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: LineChart(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuad,
        LineChartData(
          minY: 0,
          maxY: 100,
          lineTouchData: const LineTouchData(
            // use the built-in behaviour (show a tooltip bubble and an indicator on touched spots)
            handleBuiltInTouches: true,
            // set the touched behaviour data
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Color.fromARGB(95, 214, 214, 214),
            ),
          ),
          lineBarsData: List<LineChartBarData>.generate(1, (i) {
            return LineChartBarData(
              color: lineColors[i],
              spots: correctRates[i].map((e) => FlSpot(correctRates[i].indexOf(e).toDouble(), e)).toList(),
              isCurved: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4.0,
                    color: lineColors[i],
                    strokeWidth: 3,
                    strokeColor: lineColors[i],
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: lineColors[i].withOpacity(0.2),
                gradient: LinearGradient(
                  colors: [lineColors[i].withOpacity(0.2), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              barWidth: 4,
              isStrokeCapRound: true,
            );
          }),
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
