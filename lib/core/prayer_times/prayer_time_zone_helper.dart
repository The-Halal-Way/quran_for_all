import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class PrayerTimeZoneHelper {
  PrayerTimeZoneHelper._();

  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) {
      return;
    }

    tz_data.initializeTimeZones();
    _initialized = true;
  }

  static tz.Location locationFor(String timeZoneId) {
    ensureInitialized();
    return tz.getLocation(timeZoneId);
  }

  /// Add calendar days, not 24-hour durations (which drift at DST changes).
  static String dateKeyAfter(String key, int days) {
    final date = DateTime.parse(key);
    return dateKey(DateTime.utc(date.year, date.month, date.day + days));
  }

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
