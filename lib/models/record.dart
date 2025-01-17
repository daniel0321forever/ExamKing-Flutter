import 'package:examKing/global/keys.dart' as keys;

class AnswerRecord {
  final String problemID;
  final bool correct;

  AnswerRecord({required this.problemID, required this.correct});

  Map<String, dynamic> toMap() {
    return {
      keys.recordProblemIDKey: problemID,
      keys.recordCorrectKey: correct,
    };
  }
}

class BattleRecord {
  final String challengeKey;
  final String opponentID;
  bool victory = false;
  List<AnswerRecord> answerRecords = [];

  BattleRecord({required this.challengeKey, required this.opponentID});

  Map<String, dynamic> toMap() {
    return {
      keys.recordChallengeKey: challengeKey,
      keys.recordOpponentIDKey: opponentID,
      keys.recordVictoryKey: victory,
      keys.recordAnswerRecordsKey: answerRecords.map((e) => e.toMap()).toList(),
    };
  }
}
