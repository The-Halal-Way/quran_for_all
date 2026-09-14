import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/daily_reminders/daily_reminders_viewmodel.dart';
import '../../../views/daily_reminders/daily_reminder_reader_view.dart';

class DailyReminderNotificationRouter extends StatefulWidget {
  const DailyReminderNotificationRouter({
    super.key,
    required this.navigatorKey,
    required this.locale,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String locale;
  final Widget child;

  @override
  State<DailyReminderNotificationRouter> createState() =>
      _DailyReminderNotificationRouterState();
}

class _DailyReminderNotificationRouterState
    extends State<DailyReminderNotificationRouter> {
  String? _handling;

  @override
  void didUpdateWidget(covariant DailyReminderNotificationRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      unawaited(
        context.read<DailyRemindersViewModel>().localeChanged(widget.locale),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select(
      (DailyRemindersViewModel vm) =>
          (pending: vm.pendingOpenContentId, loading: vm.isLoading),
    );
    final pending = state.pending;
    if (pending != null && !state.loading && _handling != pending) {
      _handling = pending;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final vm = context.read<DailyRemindersViewModel>();
        final id = vm.takePendingOpenContentId();
        final record = id == null ? null : vm.recordForContentId(id);
        if (record != null) {
          widget.navigatorKey.currentState?.push(
            AppPageRoute<void>(
              builder: (_) => DailyReminderReaderView(record: record),
            ),
          );
        }
        _handling = null;
      });
    }
    return widget.child;
  }
}
