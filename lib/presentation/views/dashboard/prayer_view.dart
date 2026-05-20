import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class PrayerView extends StatefulWidget {
  const PrayerView({super.key});

  @override
  State<PrayerView> createState() => _PrayerViewState();
}

class _PrayerViewState extends State<PrayerView> {
  Map<String, String>? _prayerTimes;
  String _error = '';
  bool _loading = true;
  static bool _timeZonesInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permission denied';
            _loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permission permanently denied';
          _loading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final coordinates = Coordinates(position.latitude, position.longitude);

      if (!_timeZonesInitialized) {
        tz_data.initializeTimeZones();
        _timeZonesInitialized = true;
      }

      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
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

      final format = DateFormat('hh:mm a');
      setState(() {
        _prayerTimes = {
          'Fajr': format.format(tz.TZDateTime.from(prayerTimes.fajr, locationTimeZone)),
          'Sunrise': format.format(
            tz.TZDateTime.from(prayerTimes.sunrise, locationTimeZone),
          ),
          'Dhuhr': format.format(tz.TZDateTime.from(prayerTimes.dhuhr, locationTimeZone)),
          'Asr': format.format(tz.TZDateTime.from(prayerTimes.asr, locationTimeZone)),
          'Maghrib': format.format(
            tz.TZDateTime.from(prayerTimes.maghrib, locationTimeZone),
          ),
          'Isha': format.format(tz.TZDateTime.from(prayerTimes.isha, locationTimeZone)),
        };
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load prayer times: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loading = true;
                        _error = '';
                      });
                      _loadPrayerTimes();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemCount: _prayerTimes!.entries.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = _prayerTimes!.entries.elementAt(index);
                  return ListTile(
                    leading: Icon(_getIcon(entry.key)),
                    title: Text(entry.key),
                    trailing: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
      ),
    );
  }

  IconData _getIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny;
      case 'Dhuhr':
        return Icons.wb_sunny_outlined;
      case 'Asr':
        return Icons.umbrella;
      case 'Maghrib':
        return Icons.nights_stay;
      case 'Isha':
        return Icons.bedtime;
      default:
        return Icons.access_time;
    }
  }
}
