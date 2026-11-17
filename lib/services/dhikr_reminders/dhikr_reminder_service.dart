import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../l10n/app_localizations.dart';
import '../notifications/app_notification_coordinator.dart';

class DhikrReminderService {
  DhikrReminderService(this.coordinator);
  final AppNotificationCoordinator coordinator;

  bool get supported =>
      !kIsWeb &&
      {
        TargetPlatform.android,
        TargetPlatform.iOS,
      }.contains(defaultTargetPlatform);

  Future<void> cancel(DhikrReminderKind kind) async {
    if (!supported) return;
    await coordinator.initialize();
    await coordinator.plugin.cancel(id: kind.notificationId);
    await coordinator.plugin.cancel(id: kind.testNotificationId);
  }

  /// Two native repeating requests survive app termination and are restored by
  /// the existing Android boot receiver. No Dart timer or background polling.
  Future<void> schedule(
    DhikrReminderKind kind,
    DhikrReminder reminder,
    AppLocalizations strings,
  ) async {
    if (!supported) throw UnsupportedError('Dhikr reminder platform');
    if (reminder.intervalMinutes < DhikrReminder.minIntervalMinutes ||
        reminder.intervalMinutes > DhikrReminder.maxIntervalMinutes) {
      throw ArgumentError.value(reminder.intervalMinutes, 'intervalMinutes');
    }
    await coordinator.initialize();
    await coordinator.plugin.periodicallyShowWithDuration(
      id: kind.notificationId,
      title: _title(kind, strings),
      body: _body(kind, strings),
      repeatDurationInterval: Duration(minutes: reminder.intervalMinutes),
      notificationDetails: details(kind, reminder.sound, strings),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload(kind, reminder, strings),
    );
  }

  Future<void> test(
    DhikrReminderKind kind,
    DhikrReminder reminder,
    AppLocalizations strings,
  ) async {
    await coordinator.initialize();
    await coordinator.plugin.show(
      id: kind.testNotificationId,
      title: _title(kind, strings),
      body: _body(kind, strings),
      notificationDetails: details(kind, reminder.sound, strings),
      payload: jsonEncode({'feature': 'dhikrReminders', 'kind': kind.name}),
    );
  }

  String payload(
    DhikrReminderKind kind,
    DhikrReminder reminder,
    AppLocalizations strings,
  ) => jsonEncode({
    'feature': 'dhikrReminders',
    'kind': kind.name,
    'minutes': reminder.intervalMinutes,
    'sound': reminder.sound.name,
    'locale': strings.localeName,
    'version': 1,
  });

  NotificationDetails details(
    DhikrReminderKind kind,
    DhikrReminderSound sound,
    AppLocalizations strings,
  ) {
    // Android keeps a channel's first sound. Separate stable channels make
    // sound changes effective without deleting the user's channel settings.
    final channel = 'dhikr_${kind.name}_${sound.name}_v1';
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel,
        '${_title(kind, strings)} · ${sound.name}',
        channelDescription: strings.dhikrRemindersSubtitle,
        icon: 'ic_dhikr_notification',
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(sound.resource),
        playSound: true,
        onlyAlertOnce: false,
      ),
      iOS: DarwinNotificationDetails(
        sound: sound.filename,
        presentSound: true,
        presentAlert: true,
        threadIdentifier: 'dhikr_${kind.name}',
      ),
    );
  }

  String _title(DhikrReminderKind kind, AppLocalizations strings) =>
      switch (kind) {
        DhikrReminderKind.durud => strings.dhikrDurudTitle,
        DhikrReminderKind.istighfar => strings.dhikrIstighfarTitle,
      };

  String _body(DhikrReminderKind kind, AppLocalizations strings) =>
      switch (kind) {
        DhikrReminderKind.durud => strings.dhikrDurudNotification,
        DhikrReminderKind.istighfar => strings.dhikrIstighfarNotification,
      };
}
