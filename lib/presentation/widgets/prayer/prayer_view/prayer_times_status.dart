import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'prayer_state_card.dart';

class PrayerTimesStatus extends StatelessWidget {
  const PrayerTimesStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DashboardPrayerTimesViewModel>();
    if (model.isLoading && !model.hasData) {
      return const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.lg),
        child: PrayerStateCard.loading(),
      );
    }
    if (model.error.isEmpty || model.isLoading) return const SizedBox.shrink();

    final l10n = context.l10n;
    final (title, body) = switch (model.errorType) {
      PrayerTimesErrorType.permissionDenied => (
        l10n.prayerTimesPermissionDeniedTitle,
        l10n.prayerTimesPermissionDeniedBody,
      ),
      PrayerTimesErrorType.permissionDeniedForever => (
        l10n.prayerTimesPermissionDeniedForeverTitle,
        l10n.prayerTimesPermissionDeniedForeverBody,
      ),
      PrayerTimesErrorType.locationDisabled => (
        l10n.prayerTimesLocationDisabledTitle,
        l10n.prayerTimesLocationDisabledBody,
      ),
      PrayerTimesErrorType.unavailable || PrayerTimesErrorType.none => (
        l10n.prayerTimesNetworkErrorTitle,
        l10n.prayerTimesNetworkErrorBody,
      ),
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: PrayerStateCard.error(
        title: title,
        body: body,
        onRetry: () => unawaited(model.loadPrayerTimes(forceRefresh: true)),
      ),
    );
  }
}
