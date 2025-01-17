import 'package:flutter/material.dart';
import 'package:examKing/global/keys.dart' as keys;

class Stat {
  final String key;
  final String title;
  final double val;
  final double maxVal;
  Stat({required this.key, required this.title, required this.val, required this.maxVal});

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      key: map[keys.statKeyKey],
      title: map[keys.statTitleKey],
      val: map[keys.statValKey].toDouble(),
      maxVal: map[keys.statMaxValKey].toDouble(),
    );
  }
}
