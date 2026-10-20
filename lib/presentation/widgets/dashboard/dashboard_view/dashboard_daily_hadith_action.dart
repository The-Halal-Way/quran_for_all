import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/daily_reminders/daily_hadith_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../views/daily_reminders/daily_hadith_view.dart';
import 'dashboard_daily_reminder_button.dart';
import 'dashboard_navigation.dart';

/// Loads the badge after the dashboard renders, independently of the reader.
class DashboardDailyHadithAction extends StatefulWidget {
  const DashboardDailyHadithAction({super.key});

  @override
  State<DashboardDailyHadithAction> createState() =>
      _DashboardDailyHadithActionState();
}

class _DashboardDailyHadithActionState
    extends State<DashboardDailyHadithAction> {
  bool _queued = false;
  ValueListenable<bool>? _scrolling;

  void _queueLoad() {
    _queued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // A second frame lets the dashboard reach the screen before asset work.
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final activity = Scrollable.maybeOf(
        context,
      )?.position.isScrollingNotifier;
      if (activity != null && activity.value) {
        _scrolling = activity;
        activity.addListener(_onScrollActivityChanged);
      } else {
        _load();
      }
    });
  }

  void _onScrollActivityChanged() {
    if (_scrolling?.value ?? false) return;
    _scrolling?.removeListener(_onScrollActivityChanged);
    _scrolling = null;
    // Scroll activity can change during layout; notify the view model later.
    unawaited(Future<void>.delayed(Duration.zero, _load));
  }

  void _load() {
    if (!mounted) return;
    final vm = context.read<DailyHadithViewModel>();
    if (vm.pack == null && !vm.isLoading) {
      unawaited(vm.initialize(Localizations.localeOf(context).toLanguageTag()));
    }
  }

  @override
  void dispose() {
    _scrolling?.removeListener(_onScrollActivityChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsReady = context.select(
      (SettingsViewModel vm) => !vm.isLoading,
    );
    final status = context.select(
      (DailyHadithViewModel vm) => (
        unread: vm.unreadCount,
        loading: vm.isLoading,
        failed: vm.error != null,
      ),
    );
    if (settingsReady && !_queued) _queueLoad();

    return RepaintBoundary(
      child: DashboardDailyHadithButton(
        label: status.failed
            ? context.l10n.dailyHadithLoadError
            : context.l10n.dailyHadithTitle,
        loadingLabel: context.l10n.dailyHadithLoading,
        unreadCount: status.unread,
        isLoading: status.loading,
        onTap: () => pushDashboardPage(context, const DailyHadithView()),
      ),
    );
  }
}
