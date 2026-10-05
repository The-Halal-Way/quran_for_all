import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../domain/entities/prayer_times/prayer_times_models.dart';
import '../../services/hijri_calendar_service.dart';

/// Supplies both native widgets with the same adjusted Hijri dates as the app.
class PrayerWidgetCalendar {
  const PrayerWidgetCalendar._();

  static String hijriDateLabel(
    String localDateKey, {
    int adjustmentDays = 0,
    String localeIdentifier = 'en_US',
  }) {
    // Parse the prayer location's calendar day, independent of device timezone.
    final date = DateTime.parse(localDateKey);
    final hijri = const HijriCalendarService().fromGregorian(
      date,
      adjustmentDays: adjustmentDays.clamp(-1, 1),
    );
    final locale = localeIdentifier.toLowerCase().startsWith('bn')
        ? const Locale('bn')
        : const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    final months = [
      l10n.hijriMonthMuharram,
      l10n.hijriMonthSafar,
      l10n.hijriMonthRabiAlAwwal,
      l10n.hijriMonthRabiAlThani,
      l10n.hijriMonthJumadaAlAwwal,
      l10n.hijriMonthJumadaAlThani,
      l10n.hijriMonthRajab,
      l10n.hijriMonthShaban,
      l10n.hijriMonthRamadan,
      l10n.hijriMonthShawwal,
      l10n.hijriMonthDhulQadah,
      l10n.hijriMonthDhulHijjah,
    ];
    return l10n.hijriDateFull(
      '${hijri.day}',
      months[hijri.month - 1],
      '${hijri.year}',
    );
  }

  static PrayerWidgetSnapshot decorate(
    PrayerWidgetSnapshot snapshot, {
    required int adjustmentDays,
  }) {
    return PrayerWidgetSnapshot(
      profileSignature: snapshot.profileSignature,
      timeZoneId: snapshot.timeZoneId,
      locationLabel: snapshot.locationLabel,
      generatedAtUtcMillis: snapshot.generatedAtUtcMillis,
      lastSuccessfulSyncAtUtcMillis: snapshot.lastSuccessfulSyncAtUtcMillis,
      labels: snapshot.labels,
      days: snapshot.days
          .map(
            (day) => day.withHijriDateLabel(
              hijriDateLabel(
                day.localDateKey,
                adjustmentDays: adjustmentDays,
                localeIdentifier: snapshot.labels.localeIdentifier,
              ),
            ),
          )
          .toList(),
    );
  }
}
