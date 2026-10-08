import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'daily_hadith_schedule_planner.dart';

enum DailyHadithPermissionStatus { granted, denied, unsupported, unknown }

abstract class DailyHadithNotificationGateway {
  void setOpenHandler(ValueChanged<String> handler);
  Future<void> initialize();
  Future<DailyHadithPermissionStatus> permissionStatus();
  Future<DailyHadithPermissionStatus> requestPermission();
  Future<void> reschedule({
    required DailyHadithPack pack,
    required DailyHadithPreferences preferences,
    required String locale,
    required Set<int> previouslyScheduledIds,
    required ValueChanged<Set<int>> persistScheduledIds,
    DateTime? now,
  });
  Future<void> cancelContent(
    DailyHadithPack pack,
    String contentId,
    Set<int> scheduledIds,
    ValueChanged<Set<int>> persistScheduledIds,
  );
}

class DailyHadithNotificationService implements DailyHadithNotificationGateway {
  DailyHadithNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  // Retain the channel ID so existing device notification settings survive.
  static const _channelId = 'daily_reminders_release_v2';
  static const _channelName = 'Daily Hadith';
  static const _channelDescription =
      'Optional notifications for Daily Hadith readings';

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
      linux: LinuxInitializationSettings(
        defaultActionName: 'Open Daily Hadith',
      ),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final contentId = _contentIdFromPayload(response.payload);
        if (contentId != null) _openHandler?.call(contentId);
      },
    );
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      // Creating the same channel updates its display name and description
      // while Android keeps the user's existing sound and permission choices.
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: _channelDescription,
              importance: Importance.high,
            ),
          );
    }
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
  Future<DailyHadithPermissionStatus> permissionStatus() async {
    if (kIsWeb) return DailyHadithPermissionStatus.unsupported;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final enabled = await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();
        return enabled == null
            ? DailyHadithPermissionStatus.unknown
            : enabled
            ? DailyHadithPermissionStatus.granted
            : DailyHadithPermissionStatus.denied;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final options = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.checkPermissions();
        return options == null
            ? DailyHadithPermissionStatus.unknown
            : options.isEnabled
            ? DailyHadithPermissionStatus.granted
            : DailyHadithPermissionStatus.denied;
      }
      if (defaultTargetPlatform == TargetPlatform.macOS) {
        final options = await _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.checkPermissions();
        return options == null
            ? DailyHadithPermissionStatus.unknown
            : options.isEnabled
            ? DailyHadithPermissionStatus.granted
            : DailyHadithPermissionStatus.denied;
      }
      return DailyHadithPermissionStatus.unsupported;
    } catch (_) {
      return DailyHadithPermissionStatus.unknown;
    }
  }

  @override
  Future<DailyHadithPermissionStatus> requestPermission() async {
    if (kIsWeb) return DailyHadithPermissionStatus.unsupported;
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
        return DailyHadithPermissionStatus.unsupported;
      }
      return granted == true
          ? DailyHadithPermissionStatus.granted
          : DailyHadithPermissionStatus.denied;
    } catch (_) {
      return DailyHadithPermissionStatus.unknown;
    }
  }

  @override
  Future<void> reschedule({
    required DailyHadithPack pack,
    required DailyHadithPreferences preferences,
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
        permission != DailyHadithPermissionStatus.granted) {
      persistScheduledIds(<int>{});
      _lastScheduleSignature = signature;
      return;
    }
    final planned = planDailyHadithOccurrences(
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
    DailyHadithPack pack,
    String contentId,
    Set<int> scheduledIds,
    ValueChanged<Set<int>> persistScheduledIds,
  ) async {
    final schedule = pack.scheduleForContent(contentId);
    if (schedule == null) return;
    final occurrenceId = '${pack.packId}:${pack.revision}:${schedule.id}';
    final id = dailyHadithNotificationId(occurrenceId);
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
