import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../core/prayer_times/prayer_time_zone_helper.dart';
import '../../data/models/prayer/prayer_detail_models.dart';
import '../../domain/entities/prayer_times/prayer_solar_times.dart';
import '../../l10n/app_localizations.dart';

/// Precautionary windows, not an assertion of universally exact fiqh limits.
/// The durations are described alongside the schedule in both languages.
class PrayerForbiddenTimes {
  const PrayerForbiddenTimes._();

  static List<PrayerForbiddenTimeItem> items(
    AppLocalizations l10n, {
    PrayerSolarTimes? solar,
    String? timeZoneId,
  }) {
    String window(DateTime? from, DateTime? to) {
      if (from == null || to == null || timeZoneId == null) {
        return l10n.prayerForbiddenTimeFallback;
      }
      final zone = PrayerTimeZoneHelper.locationFor(timeZoneId);
      // Expand the minute labels outward so truncation cannot shorten a pause.
      final start = DateTime.fromMillisecondsSinceEpoch(
        (from.millisecondsSinceEpoch ~/ 60000) * 60000,
        isUtc: true,
      );
      final end = DateTime.fromMillisecondsSinceEpoch(
        ((to.millisecondsSinceEpoch + 59999) ~/ 60000) * 60000,
        isUtc: true,
      );
      final format = DateFormat('hh:mm a', l10n.localeName);
      return '${format.format(tz.TZDateTime.from(start, zone))} – '
          '${format.format(tz.TZDateTime.from(end, zone))}';
    }

    return [
      PrayerForbiddenTimeItem(
        title: l10n.prayerForbiddenSunriseTitle,
        timeLabel: window(
          solar?.sunriseUtc,
          solar?.sunriseUtc.add(const Duration(minutes: 20)),
        ),
        body: l10n.prayerForbiddenSunriseBody,
      ),
      PrayerForbiddenTimeItem(
        title: l10n.prayerForbiddenZenithTitle,
        timeLabel: window(
          solar?.noonUtc.subtract(const Duration(minutes: 5)),
          solar?.noonUtc.add(const Duration(minutes: 1)),
        ),
        body: l10n.prayerForbiddenZenithBody,
      ),
      PrayerForbiddenTimeItem(
        title: l10n.prayerForbiddenSunsetTitle,
        timeLabel: window(
          solar?.sunsetUtc.subtract(const Duration(minutes: 20)),
          solar?.sunsetUtc,
        ),
        body: l10n.prayerForbiddenSunsetBody,
      ),
    ];
  }
}
