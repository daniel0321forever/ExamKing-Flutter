class ProblemOption {
  final String description;
  final bool correct;

  ProblemOption({required this.description, required this.correct});
}

class Problem {
  final String problem;
  final List<ProblemOption> options;

  Problem({required this.problem, required this.options});

  factory Problem.fromMap(Map map) {
    List<ProblemOption> optionList = [];
    for (int i = 0; i < map['options'].length; i++) {
      optionList.add(ProblemOption(description: map['options'][i], correct: i == map['answer']));
    }

    return Problem(
      problem: map['problem'],
      options: optionList,
    );
  }
}
