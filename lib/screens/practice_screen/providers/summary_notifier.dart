import 'package:chat_vocab/screens/practice_screen/models/summary_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SummaryNotifier extends Notifier<Summary> {
  @override
  Summary build() => Summary.initial();

  /// Increment correct count for a word
  void addCorrectWord(String word) {
    final updated = Map<String, int>.from(state.correctWordsCount);
    updated[word] = (updated[word] ?? 0) + 1;

    state = state.copyWith(correctWordsCount: updated);
  }

  /// Increment wrong count for a word
  void addWrongWord(String word) {
    final updated = Map<String, int>.from(state.wrongWordsCount);
    updated[word] = (updated[word] ?? 0) + 1;

    state = state.copyWith(wrongWordsCount: updated);
  }

  void updateStartPractice(DateTime start) {
    state = state.copyWith(startPractice: start);
  }

  void updateEndPractice(DateTime end) {
    state = state.copyWith(endPractice: end);
  }

  void reset() {
    state = Summary.initial();
  }
}

final summaryProvider = NotifierProvider<SummaryNotifier, Summary>(
  () => SummaryNotifier(),
);
