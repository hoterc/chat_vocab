import 'package:chat_vocab/core/storage/app_perfs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  Future<void> load() async {
    state = await AppPrefs.getNotifications();
  }

  Future<void> toggle() async {
    await AppPrefs.setNotifications(!state);
    state = !state;
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, bool>(
  () => NotificationNotifier(),
);
