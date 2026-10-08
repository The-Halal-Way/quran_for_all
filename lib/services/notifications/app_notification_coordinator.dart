import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AppNotificationPermission { granted, denied, unsupported, unknown }

/// The native plugin has one response callback. Both features share this owner
/// so enabling Islamic Days cannot replace Daily Hadith notification routing.
class AppNotificationCoordinator {
  AppNotificationCoordinator({FlutterLocalNotificationsPlugin? plugin})
    : plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin plugin;
  final Map<String, ValueChanged<Map<String, dynamic>>> _handlers = {};
  final Map<String, Map<String, dynamic>> _pending = {};
  Future<void>? _initialization;

  void register(String feature, ValueChanged<Map<String, dynamic>> handler) {
    _handlers[feature] = handler;
    final pending = _pending.remove(feature);
    if (pending != null) handler(pending);
  }

  void unregister(String feature) => _handlers.remove(feature);

  Future<void> initialize() =>
      _initialization ??= _initialize().catchError((Object error) {
        _initialization = null;
        throw error;
      });

  Future<void> _initialize() async {
    if (kIsWeb ||
        !{
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.macOS,
        }.contains(defaultTargetPlatform)) {
      return;
    }
    await plugin.initialize(
      settings: const InitializationSettings(
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
      ),
      onDidReceiveNotificationResponse: (response) =>
          _dispatch(response.payload),
    );
    final launch = await plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _dispatch(launch?.notificationResponse?.payload);
    }
  }

  void _dispatch(String? raw) {
    if (raw == null || raw.isEmpty) return;
    try {
      final payload = jsonDecode(raw) as Map<String, dynamic>;
      // Existing scheduled notifications have no feature field.
      final feature = payload['feature'] as String? ?? 'dailyHadith';
      final handler = _handlers[feature];
      if (handler == null) {
        _pending[feature] = payload;
      } else {
        handler(payload);
      }
    } catch (_) {
      // Ignore malformed payloads rather than opening an unrelated page.
    }
  }

  Future<AppNotificationPermission> permissionStatus() async {
    if (kIsWeb) return AppNotificationPermission.unsupported;
    try {
      bool? enabled;
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          enabled = await plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.areNotificationsEnabled();
        case TargetPlatform.iOS:
          enabled =
              (await plugin
                      .resolvePlatformSpecificImplementation<
                        IOSFlutterLocalNotificationsPlugin
                      >()
                      ?.checkPermissions())
                  ?.isEnabled;
        case TargetPlatform.macOS:
          enabled =
              (await plugin
                      .resolvePlatformSpecificImplementation<
                        MacOSFlutterLocalNotificationsPlugin
                      >()
                      ?.checkPermissions())
                  ?.isEnabled;
        default:
          return AppNotificationPermission.unsupported;
      }
      return enabled == null
          ? AppNotificationPermission.unknown
          : enabled
          ? AppNotificationPermission.granted
          : AppNotificationPermission.denied;
    } catch (_) {
      return AppNotificationPermission.unknown;
    }
  }

  Future<AppNotificationPermission> requestPermission() async {
    await initialize();
    if (kIsWeb) return AppNotificationPermission.unsupported;
    try {
      bool? granted;
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          granted = await plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission();
        case TargetPlatform.iOS:
          granted = await plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, sound: true, badge: true);
        case TargetPlatform.macOS:
          granted = await plugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, sound: true, badge: true);
        default:
          return AppNotificationPermission.unsupported;
      }
      return granted == true
          ? AppNotificationPermission.granted
          : AppNotificationPermission.denied;
    } catch (_) {
      return AppNotificationPermission.unknown;
    }
  }
}
