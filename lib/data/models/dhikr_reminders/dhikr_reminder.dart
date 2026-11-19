import 'dhikr_reminder_sound.dart';

export 'dhikr_reminder_sound.dart';

enum DhikrReminderKind {
  durud(1500000001),
  istighfar(1500000002);

  const DhikrReminderKind(this.notificationId);
  final int notificationId;
  int get testNotificationId => notificationId + 100;
}

class DhikrReminder {
  const DhikrReminder({
    this.enabled = false,
    this.intervalMinutes = 60,
    this.sound = DhikrReminderSound.arRahman,
  });

  static const minIntervalMinutes = 1;
  static const maxIntervalMinutes = 1440;
  final bool enabled;
  final int intervalMinutes;
  final DhikrReminderSound sound;

  factory DhikrReminder.fromJson(Map<String, dynamic> json) {
    final minutes = json['intervalMinutes'];
    return DhikrReminder(
      enabled: json['enabled'] == true,
      intervalMinutes:
          minutes is int &&
              minutes >= minIntervalMinutes &&
              minutes <= maxIntervalMinutes
          ? minutes
          : 60,
      sound: DhikrReminderSound.parse(json['sound']),
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'intervalMinutes': intervalMinutes,
    'sound': sound.name,
  };

  DhikrReminder copyWith({
    bool? enabled,
    int? intervalMinutes,
    DhikrReminderSound? sound,
  }) => DhikrReminder(
    enabled: enabled ?? this.enabled,
    intervalMinutes: intervalMinutes ?? this.intervalMinutes,
    sound: sound ?? this.sound,
  );
}
