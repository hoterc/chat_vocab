class Summary {
  final Map<String, int> correctWordsCount;
  final Map<String, int> wrongWordsCount;
  final DateTime startPractice;
  final DateTime endPractice;

  Summary({
    required this.correctWordsCount,
    required this.wrongWordsCount,
    required this.startPractice,
    required this.endPractice,
  });

  // --- Computed accuracy ---
  String get accuracy {
    final totalCorrect = correctWordsCount.values.fold(0, (a, b) => a + b);
    final totalWrong = wrongWordsCount.values.fold(0, (a, b) => a + b);
    final total = totalCorrect + totalWrong;

    if (total == 0) return "0%";

    final percent = (totalCorrect / total) * 100;
    return "${percent.toStringAsFixed(1)}%";
  }

  // --- Computed time ---
  String get time {
    final seconds = endPractice.difference(startPractice).inSeconds;
    return "$seconds sec";
  }

  Summary copyWith({
    Map<String, int>? correctWordsCount,
    Map<String, int>? wrongWordsCount,
    DateTime? startPractice,
    DateTime? endPractice,
  }) {
    return Summary(
      correctWordsCount: correctWordsCount ?? this.correctWordsCount,
      wrongWordsCount: wrongWordsCount ?? this.wrongWordsCount,
      startPractice: startPractice ?? this.startPractice,
      endPractice: endPractice ?? this.endPractice,
    );
  }

  factory Summary.initial() {
    final now = DateTime.now();
    return Summary(
      correctWordsCount: {},
      wrongWordsCount: {},
      startPractice: now,
      endPractice: now,
    );
  }
}
