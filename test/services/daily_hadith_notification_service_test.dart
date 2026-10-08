import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/services/daily_hadith_notification_service.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  late List<MethodCall> calls;
  late Map<String, dynamic> launchDetails;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    // Native plugins are registered by the app; tests supply the implementation.
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    calls = [];
    launchDetails = {'notificationLaunchedApp': false};
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call);
      switch (call.method) {
        case 'initialize':
          return true;
        case 'createNotificationChannel':
          return null;
        case 'getNotificationAppLaunchDetails':
          return launchDetails;
        default:
          throw MissingPluginException(call.method);
      }
    });
  });

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('keeps the existing channel ID with the Daily Hadith name', () async {
    final service = DailyHadithNotificationService();

    await service.initialize();
    await service.initialize();

    expect(calls.map((call) => call.method), [
      'initialize',
      'createNotificationChannel',
      'getNotificationAppLaunchDetails',
    ]);
    final arguments = calls[1].arguments as Map<dynamic, dynamic>;
    expect(arguments['id'], 'daily_reminders_release_v2');
    expect(arguments['name'], 'Daily Hadith');
    expect(
      arguments['description'],
      'Optional notifications for Daily Hadith readings',
    );
  });

  test(
    'opens content from a notification scheduled before the rename',
    () async {
      launchDetails = {
        'notificationLaunchedApp': true,
        'notificationResponse': {
          'notificationId': 101,
          'notificationResponseType': 0,
          'payload': jsonEncode({
            'contentId': 'dr-0001',
            'occurrenceId': 'dr-0001@2026-09-13',
          }),
        },
      };
      final openedIds = <String>[];
      final service = DailyHadithNotificationService()
        ..setOpenHandler(openedIds.add);

      await service.initialize();

      expect(openedIds, ['dr-0001']);
    },
  );
}
