import '../../domain/entities/prayer_times/prayer_times_models.dart';
import '../../services/hijri_calendar_service.dart';

/// Supplies both native widgets with the same adjusted Hijri dates as the app.
class PrayerWidgetCalendar {
  const PrayerWidgetCalendar._();

  static const _months = [
    'Muharram',
    'Safar',
    "Rabi' al-Awwal",
    "Rabi' al-Thani",
    'Jumada al-Ula',
    'Jumada al-Akhirah',
    'Rajab',
    "Sha'ban",
    'Ramadan',
    'Shawwal',
    "Dhu al-Qi'dah",
    'Dhu al-Hijjah',
  ];

  static String hijriDateLabel(String localDateKey, {int adjustmentDays = 0}) {
    // Parse the prayer location's calendar day, independent of device timezone.
    final date = DateTime.parse(localDateKey);
    final hijri = const HijriCalendarService().fromGregorian(
      date,
      adjustmentDays: adjustmentDays.clamp(-1, 1),
    );
    return '${hijri.day} ${_months[hijri.month - 1]} ${hijri.year} AH';
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
      days: snapshot.days
          .map(
            (day) => day.withHijriDateLabel(
              hijriDateLabel(day.localDateKey, adjustmentDays: adjustmentDays),
            ),
          )
          .toList(),
    );
  }
}
