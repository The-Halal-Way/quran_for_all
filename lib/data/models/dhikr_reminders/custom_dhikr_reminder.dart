import 'dhikr_reminder.dart';

class CustomDhikrReminder {
  CustomDhikrReminder({
    required this.id,
    required String title,
    String subtitle = '',
    required this.settings,
  }) : title = title.trim(),
       subtitle = subtitle.trim() {
    if (!isValidId(id) ||
        this.title.isEmpty ||
        settings.intervalMinutes < DhikrReminder.minIntervalMinutes ||
        settings.intervalMinutes > DhikrReminder.maxIntervalMinutes) {
      throw const FormatException('Invalid custom reminder');
    }
  }

  static const firstId = 1500100000;
  static const lastId = 1599999998;
  static const maxTitleLength = 80;
  static const maxSubtitleLength = 240;
  static bool isValidId(int id) => id >= firstId && id <= lastId && id.isEven;

  final int id;
  final String title, subtitle;
  final DhikrReminder settings;
  int get testNotificationId => id + 1;

  factory CustomDhikrReminder.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! int ||
        json['title'] is! String ||
        json['settings'] is! Map ||
        (json['subtitle'] != null && json['subtitle'] is! String)) {
      throw const FormatException('Invalid custom reminder fields');
    }
    return CustomDhikrReminder(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      settings: DhikrReminder.fromJson(
        Map<String, dynamic>.from(json['settings'] as Map),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'settings': settings.toJson(),
  };
}

/// The persisted counter prevents a deleted notification's ID being reused.
class CustomDhikrReminders {
  CustomDhikrReminders({
    this.nextId = CustomDhikrReminder.firstId,
    List<CustomDhikrReminder> items = const [],
  }) : items = List.unmodifiable(items) {
    if (nextId < CustomDhikrReminder.firstId ||
        nextId > CustomDhikrReminder.lastId + 2 ||
        nextId.isOdd ||
        items.map((item) => item.id).toSet().length != items.length ||
        items.any((item) => item.id >= nextId)) {
      throw const FormatException('Invalid custom reminder collection');
    }
  }
  final int nextId;
  final List<CustomDhikrReminder> items;

  factory CustomDhikrReminders.fromJson(Map<String, dynamic> json) {
    if (json['nextId'] is! int || json['items'] is! List) {
      throw const FormatException('Invalid custom reminder collection');
    }
    return CustomDhikrReminders(
      nextId: json['nextId'] as int,
      items: (json['items'] as List)
          .map(
            (item) => CustomDhikrReminder.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
  Map<String, dynamic> toJson() => {
    'nextId': nextId,
    'items': items.map((item) => item.toJson()).toList(),
  };
}
