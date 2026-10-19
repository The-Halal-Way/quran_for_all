import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../../views/islamic_days/islamic_day_details_view.dart';
import '../../../views/islamic_days/islamic_days_view.dart';

class IslamicDaysNotificationRouter extends StatefulWidget {
  const IslamicDaysNotificationRouter({
    super.key,
    required this.navigatorKey,
    required this.locale,
    required this.adjustment,
    required this.settingsReady,
    required this.child,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final String locale;
  final int adjustment;
  final bool settingsReady;
  final Widget child;

  @override
  State<IslamicDaysNotificationRouter> createState() =>
      _IslamicDaysNotificationRouterState();
}

class _IslamicDaysNotificationRouterState
    extends State<IslamicDaysNotificationRouter> {
  bool _handling = false;

  @override
  void initState() {
    super.initState();
    _configure();
  }

  @override
  void didUpdateWidget(covariant IslamicDaysNotificationRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locale != oldWidget.locale ||
        widget.adjustment != oldWidget.adjustment ||
        widget.settingsReady != oldWidget.settingsReady) {
      _configure();
    }
  }

  void _configure() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted || !widget.settingsReady) return;
    unawaited(
      context.read<IslamicDaysViewModel>().configure(
        widget.locale,
        widget.adjustment,
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    final state = context.select(
      (IslamicDaysViewModel vm) =>
          (pending: vm.pendingOpen, ready: vm.ready, loading: vm.isLoading),
    );
    if (widget.settingsReady && state.pending != null && !_handling) {
      _handling = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openPending());
    }
    return widget.child;
  }

  Future<void> _openPending() async {
    if (!mounted) return;
    final vm = context.read<IslamicDaysViewModel>();
    // Loading the catalog is reserved for opening a page or a notification.
    if (!vm.ready || vm.isLoading) {
      await vm.initialize(widget.locale, widget.adjustment);
    }
    if (!mounted) return;
    final navigator = widget.navigatorKey.currentState;
    final pending = navigator == null ? null : vm.takePendingOpen();
    if (pending != null) {
      navigator!.push(
        AppPageRoute<void>(
          builder: (_) => vm.ready
              ? IslamicDayDetailsView(
                  eventId: pending.eventId,
                  date: pending.date,
                )
              : const IslamicDaysView(),
        ),
      );
    }
    _handling = false;
  }
}
