import 'package:flutter/material.dart';

import 'sunnah_dua_item.dart';

enum SunnahDuaDestination { dailyDua, powerfulDua, names, detail }

class SunnahDuaShortcut {
  const SunnahDuaShortcut({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.destination,
    this.detail,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final SunnahDuaDestination destination;
  final SunnahDuaItem? detail;
}
