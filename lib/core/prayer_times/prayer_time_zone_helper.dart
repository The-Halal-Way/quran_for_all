import 'package:timezone/data/latest.dart' as tz_data;
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
}
