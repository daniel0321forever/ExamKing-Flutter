import 'package:examKing/global/keys.dart' as keys;

class ProblemOption {
  final String description;
  final bool correct;

  ProblemOption({required this.description, required this.correct});
}

class Problem {
  final String problemID;
  final String problem;
  final List<ProblemOption> options;

  Problem({required this.problemID, required this.problem, required this.options});

  factory Problem.fromMap(Map map) {
    List<ProblemOption> optionList = [];
    for (int i = 0; i < map[keys.problemOptionsKey].length; i++) {
      optionList.add(ProblemOption(description: map[keys.problemOptionsKey][i], correct: i == map[keys.problemAnswerKey]));
    }

    return Problem(
      problemID: map[keys.problemIDKey],
      problem: map[keys.problemProblemKey],
      options: optionList,
    );
  }
}
