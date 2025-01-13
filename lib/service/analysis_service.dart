import 'dart:math';

import 'package:examKing/blocs/words/words_bloc.dart';
import 'package:examKing/global/keys.dart' as keys;
import 'package:examKing/global/exception.dart';
import 'package:examKing/global/properties.dart';
import 'package:examKing/models/stat.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalysisService {
  AnalysisService();

  Future<List<Stat>> getStats() async {
    Map<String, dynamic> stats = {
      keys.statTypeCorrectRate: {
        keys.statValKey: 70.0,
        keys.statMaxValKey: 100.0,
      },
      keys.statTypeWinRate: {
        keys.statValKey: 44.0,
        keys.statMaxValKey: 100.0,
      },
      keys.statTypeAvgWords: {
        keys.statValKey: 25.0,
        keys.statMaxValKey: 100.0,
      },
    };

    List<Stat> statList = [];
    for (var key in stats.keys) {
      statList.add(
        Stat(
          key: key,
          title: statProperties[key]![keys.statTitleKey],
          val: stats[key]![keys.statValKey],
          maxVal: stats[key]![keys.statMaxValKey],
        ),
      );
    }
    return statList;
  }

  Future<List<int>> getMonthlyWordProgress() async {
    DateTime now = DateTime.now();
    int daysInMonth = now.day;
    List<int> wordProgress = [45, 10, 80, 23, 41, 19, 30];
    return wordProgress;
  }

  Future<List<int>> getPreviousMonthWordProgress(int month, int year) async {
    DateTime previousMonth = DateTime(year, month);
    int daysInMonth = DateTime(year, month + 1, 0).day;
    List<int> wordProgress = List<int>.generate(daysInMonth, (index) => (index + 1) * (previousMonth.millisecondsSinceEpoch % 100));
    return wordProgress;
  }

  Future<List<List<double>>> getSevenDaysCorrectRate() async {
    DateTime now = DateTime.now();

    List<List<double>> correctRate = List<List<double>>.generate(
      4,
      (index) => List<double>.generate(7, (index) => Random().nextDouble() * 100),
    );
    return correctRate;
  }

  Future<List<List<double>>> getPreviousDaysCorrectRate(int startDay, int endDay) async {
    DateTime now = DateTime.now();
    List<List<double>> correctRate = List<List<double>>.generate(
      4,
      (index) => List<double>.generate(endDay - startDay + 1, (index) => Random().nextDouble() * 100),
    );
    return correctRate;
  }
}
