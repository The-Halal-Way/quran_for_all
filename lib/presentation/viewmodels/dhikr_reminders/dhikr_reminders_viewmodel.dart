import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../data/datasources/local/dhikr_reminders_store.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/dhikr_reminders/dhikr_reminder_service.dart';
import '../../../services/notifications/app_notification_coordinator.dart';

enum DhikrReminderError { load, save, permission, unsupported, test, capacity }

class DhikrRemindersViewModel extends ChangeNotifier {
  DhikrRemindersViewModel(this.service, {DhikrRemindersStore? store})
    : _store = store ?? DhikrRemindersStore();

  final DhikrReminderService service;
  final DhikrRemindersStore _store;
  Map<DhikrReminderKind, DhikrReminder> _reminders = {
    for (final kind in DhikrReminderKind.values) kind: const DhikrReminder(),
  };
  CustomDhikrReminders _custom = CustomDhikrReminders();
  List<CustomDhikrReminder> get customReminders => _custom.items;
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
        _custom = await _store.loadCustom();
        ready = true;
      }
      // The first app frame only reads tiny preferences. Native work is
      // needed here solely for previously enabled reminders.
      if (_reminders.values.any((item) => item.enabled) ||
          customReminders.any((item) => item.settings.enabled) ||
          checkPermission) {
        await _reconcile();
      }
    } catch (failure) {
      error = !ready ? DhikrReminderError.load : _saveError(failure);
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
    for (final item in customReminders) {
      final existing = pending
          .where((request) => request.id == item.id)
          .firstOrNull;
      if (!item.settings.enabled ||
          permission != AppNotificationPermission.granted) {
        if (existing != null) await service.cancelCustom(item);
      } else if (existing?.payload != service.customPayload(item)) {
        await service.scheduleCustom(item, _strings!);
      }
    }
    for (final request in pending) {
      if (!CustomDhikrReminder.isValidId(request.id) ||
          customReminders.any((item) => item.id == request.id)) {
        continue;
      }
      // Clean up only this feature's orphaned requests after a failed rollback.
      try {
        final data = jsonDecode(request.payload ?? '');
        if (data is Map &&
            data['feature'] == 'dhikrReminders' &&
            data['kind'] == 'custom') {
          await service.coordinator.plugin.cancel(id: request.id);
        }
      } on FormatException {
        continue;
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
        } catch (failure) {
          error = _saveError(failure);
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

  Future<bool> saveCustom({
    int? id,
    required String title,
    required String subtitle,
    required DhikrReminder settings,
  }) async {
    var saved = false;
    await _enqueue(() async {
      if (!ready || _strings == null) return;
      final previous = customReminders
          .where((item) => item.id == id)
          .firstOrNull;
      if (id != null && previous == null) {
        error = DhikrReminderError.save;
        return;
      }
      try {
        final next = CustomDhikrReminder(
          id: id ?? _custom.nextId,
          title: title,
          subtitle: subtitle,
          settings: settings,
        );
        final collection = CustomDhikrReminders(
          nextId: id == null ? _custom.nextId + 2 : _custom.nextId,
          items: id == null
              ? [...customReminders, next]
              : [
                  for (final item in customReminders)
                    item.id == id ? next : item,
                ],
        );
        saved = await _commitCustom(previous, next, collection);
      } catch (failure) {
        error = _saveError(failure);
      }
    });
    return saved;
  }

  Future<bool> deleteCustom(int id) async {
    var deleted = false;
    await _enqueue(() async {
      if (!ready || _strings == null) return;
      final previous = customReminders
          .where((item) => item.id == id)
          .firstOrNull;
      if (previous == null) return;
      deleted = await _commitCustom(
        previous,
        null,
        CustomDhikrReminders(
          nextId: _custom.nextId,
          items: customReminders.where((item) => item.id != id).toList(),
        ),
      );
    });
    return deleted;
  }

  Future<bool> _commitCustom(
    CustomDhikrReminder? previous,
    CustomDhikrReminder? next,
    CustomDhikrReminders collection,
  ) async {
    if (next != null && next.settings.enabled && !await _authorize()) {
      return false;
    }
    try {
      if (next != null && next.settings.enabled) {
        await service.scheduleCustom(next, _strings!);
      } else if (previous != null) {
        await service.cancelCustom(previous);
      }
      await _store.saveCustom(collection);
      _custom = collection;
      return true;
    } catch (failure) {
      error = _saveError(failure);
      try {
        if (previous != null &&
            previous.settings.enabled &&
            permission == AppNotificationPermission.granted) {
          await service.scheduleCustom(previous, _strings!);
        } else {
          await service.cancelCustom(next ?? previous!);
        }
      } catch (_) {
        /* Reconcile retries from persisted state on next opening. */
      }
      return false;
    }
  }

  Future<bool> testCustom(int id) async {
    var sent = false;
    await _enqueue(() async {
      final item = customReminders.where((item) => item.id == id).firstOrNull;
      if (item == null || _strings == null) return;
      try {
        if (!await _authorize()) return;
        await service.testCustom(item, _strings!);
        sent = true;
      } catch (_) {
        error = DhikrReminderError.test;
      }
    });
    return sent;
  }

  DhikrReminderError _saveError(Object failure) =>
      failure is DhikrReminderCapacityException
      ? DhikrReminderError.capacity
      : DhikrReminderError.save;

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
