import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../../viewmodels/splash_viewmodel.dart';
import '../../../views/islamic_days/islamic_day_details_view.dart';

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
    final starting = context.select((SplashViewModel vm) => vm.isLoading);
    if (!starting &&
        state.ready &&
        !state.loading &&
        state.pending != null &&
        !_handling) {
      _handling = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final navigator = widget.navigatorKey.currentState;
        if (navigator != null) {
          final pending = context
              .read<IslamicDaysViewModel>()
              .takePendingOpen();
          if (pending != null) {
            navigator.push(
              AppPageRoute<void>(
                builder: (_) => IslamicDayDetailsView(
                  eventId: pending.eventId,
                  date: pending.date,
                ),
              ),
            );
          }
        }
        _handling = false;
      });
    }
    return widget.child;
  }
}
