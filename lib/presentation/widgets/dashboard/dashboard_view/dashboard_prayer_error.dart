import '../../../../l10n/app_localizations.dart';
import '../../../viewmodels/dashboard_prayer_times_viewmodel.dart';

(String, String) dashboardPrayerError(
  AppLocalizations l10n,
  PrayerTimesErrorType type,
) => switch (type) {
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
  _ => (l10n.prayerTimesNetworkErrorTitle, l10n.prayerTimesNetworkErrorBody),
};
