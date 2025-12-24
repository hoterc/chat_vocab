final List<String> allWords = [
  "apple",
  "computer",
  "sunshine",
  "language",
  "beautiful",
  "mountain",
  "keyboard",
  "friendship",
  "practice",
  "memory",
];
List<Words> modfiayEnglishList() {
  List<Words> listwords = [];

  for (var value in allWords) {
    listwords.add(
      Words(
        words: value,
        type: "notPractice",
        seeingCount: 0,
        lastTimePractice: DateTime.now(),
        correctCount: 0,
        incorrectCount: 0,
      ),
    );
  }

  return listwords;
}

class Words {
  final String words;
  final String type;
  final int seeingCount;
  final DateTime lastTimePractice;
  final int correctCount;
  final int incorrectCount;

  Words({
    required this.words,
    required this.type,
    required this.seeingCount,
    required this.lastTimePractice,
    required this.correctCount,
    required this.incorrectCount,
  });
}
