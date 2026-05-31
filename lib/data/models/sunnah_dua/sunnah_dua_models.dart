import 'package:flutter/material.dart';

enum SunnahDuaKind { sunnah, dua, dhikr }

enum SunnahDuaFilter { all, sunnah, dua, dhikr }

class SunnahDuaItem {
  const SunnahDuaItem({
    required this.id,
    required this.kind,
    required this.icon,
    required this.accent,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.arabic,
    required this.pronunciation,
    required this.translation,
    required this.practice,
    required this.source,
    this.sunnahPoints = const [],
    this.relatedDuaTitle = '',
    this.isFeatured = false,
  });

  final String id;
  final SunnahDuaKind kind;
  final IconData icon;
  final Color accent;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final String arabic;
  final String pronunciation;
  final String translation;
  final String practice;
  final String source;
  final List<String> sunnahPoints;
  final String relatedDuaTitle;
  final bool isFeatured;

  bool get hasRelatedDua => relatedDuaTitle.isNotEmpty && arabic.isNotEmpty;
  bool get isSunnahPractice => kind == SunnahDuaKind.sunnah;
}
