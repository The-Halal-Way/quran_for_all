import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_hadith_viewmodel.dart';
import 'package:quran_for_all/presentation/views/daily_reminders/daily_hadith_reader_view.dart';

import '../../../../core/utils/app_page_route.dart';

class DailyHadithNotificationRouter extends StatefulWidget {
  const DailyHadithNotificationRouter({
    super.key,
    required this.navigatorKey,
    required this.locale,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String locale;
  final Widget child;

  @override
  State<DailyHadithNotificationRouter> createState() =>
      _DailyHadithNotificationRouterState();
}

class _DailyHadithNotificationRouterState
    extends State<DailyHadithNotificationRouter> {
  String? _handling;

  @override
  void initState() {
    super.initState();
    _syncLocale(initializeIfNeeded: true);
  }

  @override
  void didUpdateWidget(covariant DailyHadithNotificationRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale != widget.locale) {
      _syncLocale();
    }
  }

  void _syncLocale({bool initializeIfNeeded = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<DailyHadithViewModel>();
      if (initializeIfNeeded && vm.pack == null && !vm.isLoading) {
        unawaited(vm.initialize(widget.locale));
      } else {
        unawaited(vm.localeChanged(widget.locale));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select(
      (DailyHadithViewModel vm) =>
          (pending: vm.pendingOpenContentId, loading: vm.isLoading),
    );
    final pending = state.pending;
    if (pending != null && !state.loading && _handling != pending) {
      _handling = pending;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final vm = context.read<DailyHadithViewModel>();
        final id = vm.takePendingOpenContentId();
        final record = id == null ? null : vm.recordForContentId(id);
        if (record != null) {
          widget.navigatorKey.currentState?.push(
            AppPageRoute<void>(
              builder: (_) => DailyHadithReaderView(record: record),
            ),
          );
        }
        _handling = null;
      });
    }
    return widget.child;
  }
}
