import 'dart:ui' as ui;
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/views/compass/compass_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/daily_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_an_nawawi_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_forty_short_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/powerful_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer_view.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

part '../../widgets/dashobard/dashboard/dashboard_view_models.dart';
part '../../widgets/dashobard/dashboard/dashboard_view_sections.dart';
part '../../widgets/dashobard/dashboard/dashboard_view_widgets.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Map<String, String>? _prayerTimes;
  String _prayerError = '';
  bool _loadingPrayerTimes = true;
  static bool _timeZonesInitialized = false;

  // Which prayer row is next/active (highlight)
  String? _nextPrayer;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _loadingPrayerTimes = true;
      _prayerError = '';
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _prayerError = 'Location permission denied';
            _loadingPrayerTimes = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _prayerError = 'Location permission permanently denied';
          _loadingPrayerTimes = false;
        });
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
      final format = DateFormat('hh:mm a');

      // Determine next prayer
      final now = nowInLocation;
      String? next;
      final schedule = {
        'Fajr': tz.TZDateTime.from(prayerTimes.fajr, locationTimeZone),
        'Sunrise': tz.TZDateTime.from(prayerTimes.sunrise, locationTimeZone),
        'Dhuhr': tz.TZDateTime.from(prayerTimes.dhuhr, locationTimeZone),
        'Asr': tz.TZDateTime.from(prayerTimes.asr, locationTimeZone),
        'Maghrib': tz.TZDateTime.from(prayerTimes.maghrib, locationTimeZone),
        'Isha': tz.TZDateTime.from(prayerTimes.isha, locationTimeZone),
      };
      for (final entry in schedule.entries) {
        if (entry.value.isAfter(now)) {
          next = entry.key;
          break;
        }
      }

      setState(() {
        _prayerTimes = {
          'Fajr': format.format(schedule['Fajr']!),
          'Sunrise': format.format(schedule['Sunrise']!),
          'Dhuhr': format.format(schedule['Dhuhr']!),
          'Asr': format.format(schedule['Asr']!),
          'Maghrib': format.format(schedule['Maghrib']!),
          'Isha': format.format(schedule['Isha']!),
        };
        _nextPrayer = next;
        _loadingPrayerTimes = false;
      });
    } catch (e) {
      setState(() {
        _prayerError = 'Failed to load prayer times: $e';
        _loadingPrayerTimes = false;
      });
    }
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _scaffoldBg => _isDark ? MyColors.darkScaffold : MyColors.scaffold;
  Color get _cardBg => _isDark ? MyColors.darkCard : MyColors.cardFill;
  Color get _textMain =>
      _isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
  Color get _textSub =>
      _isDark ? MyColors.darkTextSecondary : MyColors.textSecondary;
  Color get _textHint =>
      _isDark ? MyColors.darkTextTertiary : MyColors.textTertiary;
  Color get _divider => _isDark ? MyColors.darkDivider : MyColors.divider;

  void _push(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: Stack(
        children: [
          // Subtle background tiling
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _BgPainter(isDark: _isDark)),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                20,
                responsive.padding,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: responsive.maxReadingContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreetingHeader(),
                      const SizedBox(height: 20),
                      _buildContinueCards(),
                      const SizedBox(height: 24),
                      _buildSectionLabel(
                        'Prayer Times',
                        Icons.access_time_rounded,
                        MyColors.secondary,
                      ),
                      const SizedBox(height: 10),
                      _buildPrayerCard(),
                      const SizedBox(height: 10),
                      _buildSmallActionRow(
                        items: [
                          _ActionItem(
                            icon: Icons.access_time_filled_rounded,
                            label: 'Full Prayer View',
                            color: MyColors.secondary,
                            onTap: () => _push(const PrayerView()),
                          ),
                          _ActionItem(
                            icon: Icons.explore_rounded,
                            label: 'Qibla Compass',
                            color: MyColors.primaryLight,
                            onTap: () => _push(const CompassView()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionLabel(
                        "Du'ā'",
                        Icons.auto_awesome_rounded,
                        MyColors.tertiary,
                      ),
                      const SizedBox(height: 10),
                      _buildSmallActionRow(
                        items: [
                          _ActionItem(
                            icon: Icons.wb_twilight_rounded,
                            label: 'Daily Du\'ā\'',
                            sublabel: 'Morning & evening',
                            color: MyColors.tertiary,
                            onTap: () => _push(const DailyDuahView()),
                          ),
                          _ActionItem(
                            icon: Icons.bolt_rounded,
                            label: 'Powerful Du\'ā\'',
                            sublabel: 'Curated supplications',
                            color: MyColors.secondary,
                            onTap: () => _push(const PowerfulDuahView()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionLabel(
                        'Hadith',
                        Icons.menu_book_rounded,
                        MyColors.primaryLight,
                      ),
                      const SizedBox(height: 10),
                      _buildHadithCards(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
