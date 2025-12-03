import 'package:chat_vocab/core/storage/app_perfs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PracticeNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    final list = await AppPrefs.getPracticeDays();
    return list.toSet();
  }

  Future<void> toggleDay(DateTime day) async {
    // Get current state safely
    final current = state.value ?? {};

    final key = day.toIso8601String().substring(0, 10);
    final updated = {...current};

    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }

    // Save to prefs
    await AppPrefs.setPracticeDays(updated.toList());

    // Update state
    state = AsyncValue.data(updated);
  }

  bool isPracticed(DateTime day) {
    final current = state.value ?? {};
    final key = day.toIso8601String().substring(0, 10);
    return current.contains(key);
  }
}

final practiceProvider = AsyncNotifierProvider<PracticeNotifier, Set<String>>(
  () => PracticeNotifier(),
);
