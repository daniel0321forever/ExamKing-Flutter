import 'package:flutter/material.dart';
import 'package:examKing/global/keys.dart' as keys;

class AbilityRecord {
  final String field;
  int totCorrect;
  int totWrong;
  double correctRate;

  AbilityRecord({
    required this.field,
    required this.totCorrect,
    required this.totWrong,
    required this.correctRate,
  });

  factory AbilityRecord.fromMap(Map map) {
    return AbilityRecord(
      field: map[keys.analysisFieldKey],
      totCorrect: map[keys.analysisTotCorrectKey],
      totWrong: map[keys.analysisTotWrongKey],
      correctRate: map[keys.analysisCorrectRatekey],
    );
  }
}
