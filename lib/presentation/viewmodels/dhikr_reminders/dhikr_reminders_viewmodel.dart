import 'package:flutter/foundation.dart';

import '../../../data/datasources/local/dhikr_reminders_store.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/dhikr_reminders/dhikr_reminder_service.dart';
import '../../../services/notifications/app_notification_coordinator.dart';

enum DhikrReminderError { load, save, permission, unsupported, test }

class DhikrRemindersViewModel extends ChangeNotifier {
  DhikrRemindersViewModel(this.service, {DhikrRemindersStore? store})
    : _store = store ?? DhikrRemindersStore();

  final DhikrReminderService service;
  final DhikrRemindersStore _store;
  Map<DhikrReminderKind, DhikrReminder> _reminders = {
    for (final kind in DhikrReminderKind.values) kind: const DhikrReminder(),
  };
  bool ready = false, busy = false;
  bool _disposed = false;
  AppNotificationPermission permission = AppNotificationPermission.unknown;
  DhikrReminderError? error;
  AppLocalizations? _strings;
  Future<void>? _tail;

  DhikrReminder reminder(DhikrReminderKind kind) => _reminders[kind]!;
  bool get supported => service.supported;

  Future<void> configure(
    AppLocalizations strings, {
    bool checkPermission = false,
  }) => _enqueue(() async {
    _strings = strings;
    try {
      if (!ready) {
        _reminders = await _store.load();
        ready = true;
      }
      // The first app frame only reads tiny preferences. Native work is
      // needed here solely for previously enabled reminders.
      if (_reminders.values.any((item) => item.enabled) || checkPermission) {
        await _reconcile();
      }
    } catch (_) {
      error = ready ? DhikrReminderError.save : DhikrReminderError.load;
    }
  });

  Future<void> _reconcile() async {
    if (!supported) {
      permission = AppNotificationPermission.unsupported;
      return;
    }
    await service.coordinator.initialize();
    permission = await service.coordinator.permissionStatus();
    final pending = await service.coordinator.plugin
        .pendingNotificationRequests();
    for (final kind in DhikrReminderKind.values) {
      final setting = reminder(kind);
      final existing = pending
          .where((item) => item.id == kind.notificationId)
          .firstOrNull;
      if (!setting.enabled || permission != AppNotificationPermission.granted) {
        if (existing != null) await service.cancel(kind);
      } else if (existing?.payload !=
          service.payload(kind, setting, _strings!)) {
        // Preserve the current countdown unless settings/locale changed or
        // the native schedule was removed. Opening the app never resets it.
        await service.schedule(kind, setting, _strings!);
      }
    }
  }

  Future<bool> _authorize() async {
    if (!supported) {
      error = DhikrReminderError.unsupported;
      return false;
    }
    await service.coordinator.initialize();
    permission = await service.coordinator.permissionStatus();
    if (permission != AppNotificationPermission.granted) {
      permission = await service.coordinator.requestPermission();
    }
    if (permission != AppNotificationPermission.granted) {
      error = DhikrReminderError.permission;
      return false;
    }
    return true;
  }

  Future<void> update(DhikrReminderKind kind, DhikrReminder next) =>
      _enqueue(() async {
        if (!ready || _strings == null) return;
        final previous = reminder(kind);
        try {
          if (next.enabled && !await _authorize()) return;
          if (next.enabled) {
            await service.schedule(kind, next, _strings!);
          } else {
            await service.cancel(kind);
          }
          final updated = {..._reminders, kind: next};
          await _store.save(updated);
          _reminders = updated;
        } catch (_) {
          error = DhikrReminderError.save;
          // Roll back a partially applied native update if persistence fails.
          try {
            if (previous.enabled &&
                permission == AppNotificationPermission.granted) {
              await service.schedule(kind, previous, _strings!);
            } else {
              await service.cancel(kind);
            }
          } catch (_) {
            // A later configure retries from the persisted settings.
          }
        }
      });

  Future<bool> test(DhikrReminderKind kind) async {
    var sent = false;
    await _enqueue(() async {
      try {
        if (!await _authorize()) return;
        await service.test(kind, reminder(kind), _strings!);
        sent = true;
      } catch (_) {
        error = DhikrReminderError.test;
      }
    });
    return sent;
  }

  Future<void> openNotificationSettings() async {
    try {
      await service.coordinator.plugin.openAppNotificationSettings();
    } catch (_) {
      error = DhikrReminderError.permission;
      _notify();
    }
  }

  Future<void> _enqueue(Future<void> Function() action) {
    final operation = (_tail ?? Future<void>.value()).then((_) async {
      if (_disposed) return;
      busy = true;
      error = null;
      _notify();
      try {
        await action();
      } finally {
        busy = false;
        _notify();
      }
    });
    _tail = operation.catchError((Object _) {});
    return operation;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
