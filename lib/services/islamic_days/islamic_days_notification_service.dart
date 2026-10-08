import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/islamic_days/islamic_day.dart';
import '../../data/models/islamic_days/islamic_days_preferences.dart';
import '../notifications/app_notification_coordinator.dart';
import 'islamic_day_notification_planner.dart';
import 'islamic_day_rule_evaluator.dart';

class IslamicDaysNotificationService {
  IslamicDaysNotificationService(this.coordinator);

  final AppNotificationCoordinator coordinator;
  static const _channelId = 'islamic_days_v1';

  void setOpenHandler(ValueChanged<Map<String, dynamic>> handler) =>
      coordinator.register('islamicDays', handler);

  void dispose() => coordinator.unregister('islamicDays');

  Future<Set<int>> reschedule({
    required List<IslamicDay> catalog,
    required IslamicDaysPreferences preferences,
    required IslamicDayRuleEvaluator evaluator,
    required Set<int> previousIds,
    required String locale,
    required int adjustment,
    required Future<void> Function(Set<int>) persistIds,
  }) async {
    await coordinator.initialize();
    final plugin = coordinator.plugin;
    // Cancel first: turning alerts off must not leave an old fasting prompt.
    for (final id in previousIds) {
      await plugin.cancel(id: id);
    }
    await persistIds({});
    if (!preferences.notificationsEnabled ||
        await coordinator.permissionStatus() !=
            AppNotificationPermission.granted) {
      return {};
    }
    if (kIsWeb ||
        !{
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.macOS,
        }.contains(defaultTargetPlatform)) {
      return {};
    }
    // A timezone failure is surfaced to the settings UI. UTC is not used as a
    // silent substitute for the user's local calendar.
    final zoneName = await FlutterTimezone.getLocalTimezone();
    tz_data.initializeTimeZones();
    final location = tz.getLocation(zoneName);
    final now = tz.TZDateTime.now(location);
    final plans = planIslamicDayNotifications(
      catalog: catalog,
      preferences: preferences,
      evaluator: evaluator,
      now: now,
      locale: locale,
      adjustment: adjustment,
    );
    final bn = locale.startsWith('bn');
    final name = bn ? 'ইসলামি দিন' : 'Islamic Days';
    final description = bn
        ? 'ইসলামি উপলক্ষ ও রোজার ঐচ্ছিক স্মরণবার্তা'
        : 'Optional reminders for Islamic occasions and fasting';
    if (defaultTargetPlatform == TargetPlatform.android) {
      await plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            AndroidNotificationChannel(
              _channelId,
              name,
              description: description,
              importance: Importance.defaultImportance,
            ),
          );
    }
    final scheduled = <int>{};
    try {
      for (final plan in plans) {
        final when = plan.when;
        await plugin.zonedSchedule(
          id: plan.id,
          title: plan.title,
          body: plan.body,
          scheduledDate: tz.TZDateTime(
            location,
            when.year,
            when.month,
            when.day,
            when.hour,
            when.minute,
          ),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              name,
              channelDescription: description,
            ),
            iOS: const DarwinNotificationDetails(threadIdentifier: _channelId),
            macOS: const DarwinNotificationDetails(
              threadIdentifier: _channelId,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: jsonEncode({
            'feature': 'islamicDays',
            'eventId': plan.target.event.id,
            'date': plan.target.date.toIso8601String(),
          }),
        );
        scheduled.add(plan.id);
      }
    } finally {
      // Retain IDs even after a partial native scheduling failure.
      await persistIds(scheduled);
    }
    return scheduled;
  }
}
