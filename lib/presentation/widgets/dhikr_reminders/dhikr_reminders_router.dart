import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_page_route.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/notifications/app_notification_coordinator.dart';
import '../../viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';
import '../../views/dashboard/dhikr_reminders/dhikr_reminders_view.dart';

class DhikrRemindersRouter extends StatefulWidget {
  const DhikrRemindersRouter({
    super.key,
    required this.navigatorKey,
    required this.locale,
    required this.settingsReady,
    required this.child,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final Locale locale;
  final bool settingsReady;
  final Widget child;

  @override
  State<DhikrRemindersRouter> createState() => _DhikrRemindersRouterState();
}

class _DhikrRemindersRouterState extends State<DhikrRemindersRouter>
    with WidgetsBindingObserver {
  late AppNotificationCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _coordinator = context.read<AppNotificationCoordinator>();
    _coordinator.register('dhikrReminders', _open);
    _configure();
  }

  void _open(Map<String, dynamic> payload) {
    final kind = DhikrReminderKind.values
        .where((kind) => kind.name == payload['kind'])
        .firstOrNull;
    final id = payload['kind'] == 'custom' && payload['id'] is int
        ? payload['id'] as int
        : null;
    if (kind == null && (id == null || !CustomDhikrReminder.isValidId(id))) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.navigatorKey.currentState?.push(
        AppPageRoute<void>(
          builder: (_) =>
              DhikrRemindersView(initialKind: kind, initialCustomId: id),
        ),
      );
    });
  }

  void _configure() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted || !widget.settingsReady) return;
    unawaited(
      context.read<DhikrRemindersViewModel>().configure(
        lookupAppLocalizations(widget.locale),
      ),
    );
  });

  @override
  void didUpdateWidget(covariant DhikrRemindersRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale ||
        oldWidget.settingsReady != widget.settingsReady) {
      _configure();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _configure();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _coordinator.unregister('dhikrReminders');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
