import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../../core/localization/l10n_extensions.dart';

class DuaCatalogVisuals {
  const DuaCatalogVisuals._();

  static IconData icon(String id) => switch (id) {
    'all' => Icons.auto_stories_rounded,
    'morning' => Icons.wb_sunny_rounded,
    'evening' || 'sleep' => Icons.nights_stay_rounded,
    'home' || 'family' => Icons.cottage_rounded,
    'mosque' || 'worship' => Icons.mosque_rounded,
    'quran' || 'hadith' => Icons.menu_book_rounded,
    'food' => Icons.restaurant_rounded,
    'hygiene' => Icons.water_drop_rounded,
    'clothing' => Icons.checkroom_rounded,
    'travel' => Icons.explore_rounded,
    'weather' => Icons.cloud_rounded,
    'health' => Icons.healing_rounded,
    'protection' => Icons.shield_rounded,
    'forgiveness' || 'faith' => Icons.favorite_rounded,
    'hardship' => Icons.spa_rounded,
    'provision' => Icons.grass_rounded,
    'learning' => Icons.lightbulb_rounded,
    'hereafter' => Icons.brightness_4_rounded,
    _ => Icons.auto_awesome_rounded,
  };

  static Color color(String id) => switch (id) {
    'morning' || 'food' || 'gratitude' => const Color(0xFFB77A13),
    'evening' || 'sleep' || 'faith' || 'hereafter' => const Color(0xFF8B5CF6),
    'family' || 'forgiveness' || 'hardship' => const Color(0xFFD64C86),
    'quran' || 'mosque' || 'worship' || 'provision' => const Color(0xFF148D75),
    _ => const Color(0xFF159DB7),
  };
}

String duaNumber(BuildContext context, int number) =>
    NumberFormat.decimalPattern(context.l10n.localeName).format(number);
