// dashboard_view.dart
// Exotic Dashboard UI — Quran for All
// Plug-in replacement for the old DashboardView.
// All wiring (Navigator pushes, prayer logic) kept identical to original.
import 'dart:ui' as ui;
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/presentation/views/compass/compass_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/daily_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_an_nawawi_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/hadith/hadith_forty_short_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/duah/powerful_duah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/prayer_view.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

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

  bool get _isDark =>
      MediaQuery.of(context).platformBrightness == Brightness.dark;

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
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
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
        ],
      ),
    );
  }

  // ── Greeting header ─────────────────────────────────────────────────────────

  Widget _buildGreetingHeader() {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }
    final dateStr = DateFormat('EEEE, d MMMM').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arabic bismillah strip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primary.withOpacity(0.08),
                MyColors.primaryLight.withOpacity(0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.primaryLight.withOpacity(_isDark ? 0.12 : 0.1),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.secondary.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                style: GoogleFonts.amiri(
                  fontSize: 15,
                  color: _textMain,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          greeting,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textHint,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Quran for All',
          style: GoogleFonts.sora(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _textMain,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 12, color: _textHint),
            const SizedBox(width: 5),
            Text(
              dateStr,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: _textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Continue reading / learning cards ───────────────────────────────────────

  Widget _buildContinueCards() {
    return Row(
      children: [
        Expanded(
          child: _ContinueCard(
            title: 'Continue Reading',
            subtitle: 'Surah Al-Baqarah',
            detail: 'Ayah 255 · Āyat al-Kursī',
            arabicSnippet: 'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ',
            gradientColors: [MyColors.primary, MyColors.primaryLight],
            glowColor: MyColors.primaryLight,
            icon: Icons.auto_stories_rounded,
            isDark: _isDark,
            onTap: () {
              /* TODO */
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ContinueCard(
            title: 'Continue Learning',
            subtitle: 'Tajweed Basics',
            detail: 'Lesson 4 · Ghunnah',
            arabicSnippet: 'ن  ◌ّ  م',
            gradientColors: [Color(0xFF005C4B), MyColors.tertiary],
            glowColor: MyColors.tertiary,
            icon: Icons.school_rounded,
            isDark: _isDark,
            onTap: () {
              /* TODO */
            },
          ),
        ),
      ],
    );
  }

  // ── Section label ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textMain,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.25), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Prayer card ─────────────────────────────────────────────────────────────

  Widget _buildPrayerCard() {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isDark
              ? Colors.white.withOpacity(0.06)
              : _divider.withOpacity(0.8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withOpacity(_isDark ? 0.12 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _loadingPrayerTimes
          ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.secondary,
                  strokeWidth: 2,
                ),
              ),
            )
          : _prayerError.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: MyColors.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _prayerError,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: _textSub,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _loadPrayerTimes,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: MyColors.secondary.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: MyColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Next prayer highlight banner
                if (_nextPrayer != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [MyColors.secondary, MyColors.primaryLight],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getPrayerIcon(_nextPrayer!),
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Prayer',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              _nextPrayer!,
                              style: GoogleFonts.sora(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          _prayerTimes?[_nextPrayer!] ?? '',
                          style: GoogleFonts.sora(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Prayer rows
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    children: (_prayerTimes ?? {}).entries.map((entry) {
                      final isNext = entry.key == _nextPrayer;
                      return _PrayerRow(
                        name: entry.key,
                        time: entry.value,
                        icon: _getPrayerIcon(entry.key),
                        isNext: isNext,
                        isDark: _isDark,
                        textMain: _textMain,
                        textHint: _textHint,
                        divider: _divider,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight_rounded;
      case 'Sunrise':
        return Icons.wb_sunny_rounded;
      case 'Dhuhr':
        return Icons.light_mode_rounded;
      case 'Asr':
        return Icons.cloud_rounded;
      case 'Maghrib':
        return Icons.nights_stay_rounded;
      case 'Isha':
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  // ── Small 2-col action row ──────────────────────────────────────────────────

  Widget _buildSmallActionRow({required List<_ActionItem> items}) {
    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: item == items.last ? 0 : 8),
                child: _ActionTile(
                  item: item,
                  isDark: _isDark,
                  cardBg: _cardBg,
                  textMain: _textMain,
                  textHint: _textHint,
                  divider: _divider,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Hadith cards ────────────────────────────────────────────────────────────

  Widget _buildHadithCards() {
    return Column(
      children: [
        _HadithNavCard(
          number: '40',
          arabicTitle: 'الأربعون النووية',
          englishTitle: 'Forty Hadith An-Nawawi',
          description: 'The classical collection by Imam An-Nawawi',
          accentColors: [MyColors.primary, MyColors.primaryLight],
          glowColor: MyColors.primaryLight,
          isDark: _isDark,
          cardBg: _cardBg,
          textMain: _textMain,
          textSub: _textSub,
          textHint: _textHint,
          divider: _divider,
          onTap: () => _push(const HadithAnNawawiView()),
        ),
        const SizedBox(height: 10),
        _HadithNavCard(
          number: '40',
          arabicTitle: 'الأحاديث القصيرة',
          englishTitle: 'Forty Short Hadith',
          description: 'Short hadith for easy memorization & practice',
          accentColors: [Color(0xFF005C4B), MyColors.tertiary],
          glowColor: MyColors.tertiary,
          isDark: _isDark,
          cardBg: _cardBg,
          textMain: _textMain,
          textSub: _textSub,
          textHint: _textHint,
          divider: _divider,
          onTap: () => _push(const HadithFortyShortView()),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTINUE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ContinueCard extends StatelessWidget {
  final String title, subtitle, detail, arabicSnippet;
  final List<Color> gradientColors;
  final Color glowColor;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _ContinueCard({
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.arabicSnippet,
    required this.gradientColors,
    required this.glowColor,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Watermark Arabic text
            Positioned(
              right: -8,
              bottom: -8,
              child: Text(
                arabicSnippet,
                style: GoogleFonts.amiri(
                  fontSize: 36,
                  color: Colors.white.withOpacity(0.06),
                  fontWeight: FontWeight.bold,
                ),
                textDirection: ui.TextDirection.rtl,
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, size: 17, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.65),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow chip
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRAYER ROW
// ─────────────────────────────────────────────────────────────────────────────

class _PrayerRow extends StatelessWidget {
  final String name, time;
  final IconData icon;
  final bool isNext, isDark;
  final Color textMain, textHint, divider;

  const _PrayerRow({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
    required this.isDark,
    required this.textMain,
    required this.textHint,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isNext
                  ? MyColors.secondary.withOpacity(0.12)
                  : (isDark
                        ? Colors.white.withOpacity(0.05)
                        : MyColors.divider.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 17,
              color: isNext ? MyColors.secondary : textHint,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
              color: isNext ? textMain : textHint,
            ),
          ),
          if (isNext) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: MyColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: MyColors.secondary.withOpacity(0.25),
                  width: 0.7,
                ),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: MyColors.secondary,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
          const Spacer(),
          Text(
            time,
            style: GoogleFonts.sora(
              fontSize: 14,
              fontWeight: isNext ? FontWeight.w800 : FontWeight.w500,
              color: isNext ? MyColors.secondary : textHint,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION TILE  (2-col quick actions)
// ─────────────────────────────────────────────────────────────────────────────

class _ActionItem {
  final IconData icon;
  final String label;
  final String? sublabel;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.color,
    required this.onTap,
  });
}

class _ActionTile extends StatelessWidget {
  final _ActionItem item;
  final bool isDark;
  final Color cardBg, textMain, textHint, divider;

  const _ActionTile({
    required this.item,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : divider.withOpacity(0.8),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(isDark ? 0.1 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: item.color),
            ),
            const SizedBox(height: 12),
            Text(
              item.label,
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textMain,
                letterSpacing: -0.1,
              ),
            ),
            if (item.sublabel != null) ...[
              const SizedBox(height: 2),
              Text(
                item.sublabel!,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  color: textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HADITH NAV CARD  (large, with Arabic title)
// ─────────────────────────────────────────────────────────────────────────────

class _HadithNavCard extends StatelessWidget {
  final String number, arabicTitle, englishTitle, description;
  final List<Color> accentColors;
  final Color glowColor;
  final bool isDark;
  final Color cardBg, textMain, textSub, textHint, divider;
  final VoidCallback onTap;

  const _HadithNavCard({
    required this.number,
    required this.arabicTitle,
    required this.englishTitle,
    required this.description,
    required this.accentColors,
    required this.glowColor,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.textHint,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : divider.withOpacity(0.8),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(isDark ? 0.12 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left accent strip with number
            Container(
              width: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: accentColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: GoogleFonts.sora(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  Text(
                    'hadith',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      color: Colors.white.withOpacity(0.65),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arabicTitle,
                      style: GoogleFonts.amiri(
                        fontSize: 17,
                        color: textMain,
                        height: 1.3,
                      ),
                      textDirection: ui.TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      englishTitle,
                      style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textMain,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: textHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: glowColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: glowColor.withOpacity(0.2),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: glowColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACKGROUND PAINTER  (faint geometric tile)
// ─────────────────────────────────────────────────────────────────────────────

class _BgPainter extends CustomPainter {
  final bool isDark;
  const _BgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? MyColors.primaryLight : MyColors.primary).withOpacity(
        isDark ? 0.03 : 0.025,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;

    const step = 56.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        _drawDiamond(canvas, paint, Offset(x, y), 12);
      }
    }
  }

  void _drawDiamond(Canvas canvas, Paint paint, Offset center, double r) {
    final path = Path()
      ..moveTo(center.dx, center.dy - r)
      ..lineTo(center.dx + r, center.dy)
      ..lineTo(center.dx, center.dy + r)
      ..lineTo(center.dx - r, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.isDark != isDark;
}
