import 'package:flutter/material.dart';

class SunnahCatalogVisuals {
  const SunnahCatalogVisuals._();

  static IconData icon(String id) => switch (id) {
    'all' => Icons.auto_awesome_rounded,
    'waking_up' || 'morning_remembrance' => Icons.wb_sunny_rounded,
    'washroom' || 'wudu_sunnahs' => Icons.water_drop_rounded,
    'miswak' || 'personal_care' => Icons.health_and_safety_rounded,
    'eating_sunnahs' || 'drinking' => Icons.restaurant_rounded,
    'evening_remembrance' ||
    'sleeping_sunnahs' ||
    'night_safety' => Icons.dark_mode_rounded,
    'friday' || 'mosque' => Icons.mosque_rounded,
    'quran_learning' || 'bedtime_recitation' => Icons.menu_book_rounded,
    'family' || 'community' => Icons.diversity_1_rounded,
    'travel' || 'leaving_home' => Icons.route_rounded,
    'fasting' || 'ramadan' => Icons.nightlight_round,
    'charity' => Icons.volunteer_activism_rounded,
    'weather' => Icons.cloud_rounded,
    'livelihood' => Icons.work_outline_rounded,
    _ => Icons.spa_rounded,
  };

  static Color color(String id) => switch (id.hashCode.abs() % 5) {
    0 => const Color(0xFF0797A8),
    1 => const Color(0xFF7657F5),
    2 => const Color(0xFFE6478D),
    3 => const Color(0xFF148D6F),
    _ => const Color(0xFFB97800),
  };
}
