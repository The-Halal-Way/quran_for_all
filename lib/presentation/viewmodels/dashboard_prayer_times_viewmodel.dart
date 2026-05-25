import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class DashboardPrayerTimesViewModel extends ChangeNotifier {
  Map<String, String>? _prayerTimes;
  Map<String, String>? _prayerTimeRanges;
  String _error = '';
  bool _loading = false;
  String? _nextPrayer;
  static bool _timeZonesInitialized = false;

  Map<String, String>? get prayerTimes => _prayerTimes;
  Map<String, String>? get prayerTimeRanges => _prayerTimeRanges;
  String get error => _error;
  bool get isLoading => _loading;
  String? get nextPrayer => _nextPrayer;
  bool get hasData => _prayerTimes != null && _prayerTimes!.isNotEmpty;

  Future<void> loadPrayerTimes({bool forceRefresh = false}) async {
    if (_loading) return;
    if (!forceRefresh && hasData) return;

    _loading = true;
    _error = '';
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Location permission denied';
          _loading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Location permission permanently denied';
        _loading = false;
        notifyListeners();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final coordinates = Coordinates(position.latitude, position.longitude);

      if (!_timeZonesInitialized) {
        tz_data.initializeTimeZones();
        _timeZonesInitialized = true;
      }

      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      final locationTimeZone = tz.getLocation(timeZoneName);
      final nowInLocation = tz.TZDateTime.now(locationTimeZone);
      final dateComponents = DateComponents(
        nowInLocation.year,
        nowInLocation.month,
        nowInLocation.day,
      );

      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
      final tomorrowInLocation = nowInLocation.add(const Duration(days: 1));
      final nextDateComponents = DateComponents(
        tomorrowInLocation.year,
        tomorrowInLocation.month,
        tomorrowInLocation.day,
      );
      final tomorrowPrayerTimes = PrayerTimes(
        coordinates,
        nextDateComponents,
        params,
      );
      final format = DateFormat('hh:mm a');

      String? next;
      final schedule = {
        'Fajr': tz.TZDateTime.from(prayerTimes.fajr, locationTimeZone),
        'Sunrise': tz.TZDateTime.from(prayerTimes.sunrise, locationTimeZone),
        'Dhuhr': tz.TZDateTime.from(prayerTimes.dhuhr, locationTimeZone),
        'Asr': tz.TZDateTime.from(prayerTimes.asr, locationTimeZone),
        'Maghrib': tz.TZDateTime.from(prayerTimes.maghrib, locationTimeZone),
        'Isha': tz.TZDateTime.from(prayerTimes.isha, locationTimeZone),
      };
      final tomorrowFajr = tz.TZDateTime.from(
        tomorrowPrayerTimes.fajr,
        locationTimeZone,
      );

      for (final entry in schedule.entries) {
        if (entry.value.isAfter(nowInLocation)) {
          next = entry.key;
          break;
        }
      }

      _prayerTimes = {
        'Fajr': format.format(schedule['Fajr']!),
        'Sunrise': format.format(schedule['Sunrise']!),
        'Dhuhr': format.format(schedule['Dhuhr']!),
        'Asr': format.format(schedule['Asr']!),
        'Maghrib': format.format(schedule['Maghrib']!),
        'Isha': format.format(schedule['Isha']!),
      };
      _prayerTimeRanges = {
        'Fajr':
            '${format.format(schedule['Fajr']!)} - ${format.format(schedule['Sunrise']!)}',
        'Dhuhr':
            '${format.format(schedule['Dhuhr']!)} - ${format.format(schedule['Asr']!)}',
        'Asr':
            '${format.format(schedule['Asr']!)} - ${format.format(schedule['Maghrib']!)}',
        'Maghrib':
            '${format.format(schedule['Maghrib']!)} - ${format.format(schedule['Isha']!)}',
        'Isha':
            '${format.format(schedule['Isha']!)} - ${format.format(tomorrowFajr)}',
      };
      _nextPrayer = next;
      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load prayer times: $e';
      _loading = false;
      notifyListeners();
    }
  }
}
