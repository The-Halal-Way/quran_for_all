import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../data/models/daily_reminders/daily_reminder_pack.dart';
import 'daily_reminder_schedule_planner.dart';

enum DailyReminderPermissionStatus { granted, denied, unsupported, unknown }

abstract class DailyReminderNotificationGateway {
  void setOpenHandler(ValueChanged<String> handler);
  Future<void> initialize();
  Future<DailyReminderPermissionStatus> permissionStatus();
  Future<DailyReminderPermissionStatus> requestPermission();
  Future<void> reschedule({
    required DailyReminderPack pack,
    required DailyReminderPreferences preferences,
    required String locale,
    required Set<int> previouslyScheduledIds,
    required ValueChanged<Set<int>> persistScheduledIds,
    DateTime? now,
  });
  Future<void> cancelContent(
    DailyReminderPack pack,
    String contentId,
    Set<int> scheduledIds,
    ValueChanged<Set<int>> persistScheduledIds,
  );
}

class DailyReminderNotificationService
    implements DailyReminderNotificationGateway {
  DailyReminderNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'daily_reminders_release_v2';
  static const _channelName = 'Daily reminders';
  static const _channelDescription =
      'Optional daily reflection and action reminders';

  final FlutterLocalNotificationsPlugin _plugin;
  ValueChanged<String>? _openHandler;
  bool _initialized = false;
  String? _lastScheduleSignature;

  @override
  void setOpenHandler(ValueChanged<String> handler) => _openHandler = handler;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      linux: LinuxInitializationSettings(defaultActionName: 'Open reminder'),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final contentId = _contentIdFromPayload(response.payload);
        if (contentId != null) _openHandler?.call(contentId);
      },
    );
    _initialized = true;
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      final contentId = _contentIdFromPayload(
        launch?.notificationResponse?.payload,
      );
      if (contentId != null) _openHandler?.call(contentId);
    }
  }

  @override
  Future<DailyReminderPermissionStatus> permissionStatus() async {
    if (kIsWeb) return DailyReminderPermissionStatus.unsupported;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final enabled = await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();
        return enabled == null
            ? DailyReminderPermissionStatus.unknown
            : enabled
            ? DailyReminderPermissionStatus.granted
            : DailyReminderPermissionStatus.denied;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final options = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.checkPermissions();
        return options == null
            ? DailyReminderPermissionStatus.unknown
            : options.isEnabled
            ? DailyReminderPermissionStatus.granted
            : DailyReminderPermissionStatus.denied;
      }
      if (defaultTargetPlatform == TargetPlatform.macOS) {
        final options = await _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.checkPermissions();
        return options == null
            ? DailyReminderPermissionStatus.unknown
            : options.isEnabled
            ? DailyReminderPermissionStatus.granted
            : DailyReminderPermissionStatus.denied;
      }
      return DailyReminderPermissionStatus.unsupported;
    } catch (_) {
      return DailyReminderPermissionStatus.unknown;
    }
  }

  @override
  Future<DailyReminderPermissionStatus> requestPermission() async {
    if (kIsWeb) return DailyReminderPermissionStatus.unsupported;
    try {
      bool? granted;
      if (defaultTargetPlatform == TargetPlatform.android) {
        granted = await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        granted = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, sound: true, badge: true);
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        granted = await _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, sound: true, badge: true);
      } else {
        return DailyReminderPermissionStatus.unsupported;
      }
      return granted == true
          ? DailyReminderPermissionStatus.granted
          : DailyReminderPermissionStatus.denied;
    } catch (_) {
      return DailyReminderPermissionStatus.unknown;
    }
  }

  @override
  Future<void> reschedule({
    required DailyReminderPack pack,
    required DailyReminderPreferences preferences,
    required String locale,
    required Set<int> previouslyScheduledIds,
    required ValueChanged<Set<int>> persistScheduledIds,
    DateTime? now,
  }) async {
    await initialize();
    var timezoneName = 'UTC';
    try {
      timezoneName = await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      // UTC is a deterministic fallback for platforms without timezone access.
    }
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
    final localNow = now ?? tz.TZDateTime.now(tz.local);
    final permission = await permissionStatus();
    final signature = [
      pack.packId,
      pack.revision,
      locale,
      timezoneName,
      preferences.notificationsEnabled,
      preferences.hour,
      preferences.minute,
      permission.name,
      ...preferences.enabledKinds.toList()..sort(),
      LocalCalendarDate.fromDateTime(localNow),
    ].join('|');
    if (_lastScheduleSignature == signature) return;

    for (final id in previouslyScheduledIds) {
      await _plugin.cancel(id: id);
    }
    if (!preferences.notificationsEnabled ||
        permission != DailyReminderPermissionStatus.granted) {
      persistScheduledIds(<int>{});
      _lastScheduleSignature = signature;
      return;
    }
    final planned = planDailyReminderOccurrences(
      pack: pack,
      preferences: preferences,
      locale: locale,
      now: localNow,
    );
    final scheduled = <int>{};
    for (final occurrence in planned) {
      final when = occurrence.when;
      final zoned = tz.TZDateTime(
        tz.local,
        when.year,
        when.month,
        when.day,
        when.hour,
        when.minute,
      );
      await _plugin.zonedSchedule(
        id: occurrence.notificationId,
        title: occurrence.title,
        body: occurrence.body,
        scheduledDate: zoned,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(threadIdentifier: _channelId),
          macOS: DarwinNotificationDetails(threadIdentifier: _channelId),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: jsonEncode({
          'contentId': occurrence.contentId,
          'occurrenceId': occurrence.occurrenceId,
        }),
      );
      scheduled.add(occurrence.notificationId);
    }
    persistScheduledIds(scheduled);
    _lastScheduleSignature = signature;
  }

  @override
  Future<void> cancelContent(
    DailyReminderPack pack,
    String contentId,
    Set<int> scheduledIds,
    ValueChanged<Set<int>> persistScheduledIds,
  ) async {
    final schedule = pack.scheduleForContent(contentId);
    if (schedule == null) return;
    final occurrenceId = '${pack.packId}:${pack.revision}:${schedule.id}';
    final id = dailyReminderNotificationId(occurrenceId);
    if (!scheduledIds.contains(id)) return;
    await _plugin.cancel(id: id);
    persistScheduledIds({...scheduledIds}..remove(id));
  }

  String? _contentIdFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      return (jsonDecode(payload) as Map<String, dynamic>)['contentId']
          as String?;
    } catch (_) {
      return null;
    }
  }
}
