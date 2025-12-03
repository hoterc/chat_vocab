import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  AppPrefs._();

  static SharedPreferences? _prefs;

  // Initialize once
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ---------------- PROFILE ----------------
  static Future<String?> getName() async => _prefs?.getString('profile_name');
  static Future<void> setName(String name) async =>
      await _prefs?.setString('profile_name', name);

  static Future<String?> getImage() async => _prefs?.getString('profile_image');
  static Future<void> setImage(String path) async =>
      await _prefs?.setString('profile_image', path);

  // ---------------- NOTIFICATIONS -----------
  static Future<bool> getNotifications() async =>
      _prefs?.getBool('notifications') ?? true;
  static Future<void> setNotifications(bool value) async =>
      await _prefs?.setBool('notifications', value);

  // ---------------- PRACTICE CALENDAR -------
  static Future<List<String>> getPracticeDays() async =>
      _prefs?.getStringList('practice_days') ?? [];
  static Future<void> setPracticeDays(List<String> days) async =>
      await _prefs?.setStringList('practice_days', days);

  // ---------------- FIRST OPEN DATE -----------
  static Future<DateTime?> getFirstOpenDate() async {
    final dateStr = _prefs?.getString('first_open_date');
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  static Future<void> setFirstOpenDate(DateTime date) async =>
      await _prefs?.setString('first_open_date', date.toIso8601String());

  static Future<void> saveFirstOpenDateIfNeeded() async {
    final existing = await getFirstOpenDate();
    if (existing == null) {
      await setFirstOpenDate(DateTime.now());
    }
  }
}
