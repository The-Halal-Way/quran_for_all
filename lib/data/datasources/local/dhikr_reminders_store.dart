import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/dhikr_reminders/dhikr_reminder.dart';

class DhikrRemindersStore {
  static const key = 'dhikr_reminders_v1';

  Future<Map<DhikrReminderKind, DhikrReminder>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    final result = {
      for (final kind in DhikrReminderKind.values) kind: const DhikrReminder(),
    };
    if (raw == null) return result;
    final json = jsonDecode(raw);
    if (json is! Map) throw const FormatException('Invalid reminder settings');
    for (final kind in DhikrReminderKind.values) {
      final value = json[kind.name];
      if (value is Map) {
        result[kind] = DhikrReminder.fromJson(Map<String, dynamic>.from(value));
      }
    }
    return result;
  }

  Future<void> save(Map<DhikrReminderKind, DhikrReminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(
      key,
      jsonEncode({
        for (final item in reminders.entries)
          item.key.name: item.value.toJson(),
      }),
    );
    if (!saved) throw StateError('Could not save reminder settings');
  }
}
