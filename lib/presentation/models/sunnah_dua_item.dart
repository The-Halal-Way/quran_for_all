import 'package:flutter/material.dart';

import '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
export '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';

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
    this.phase,
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
  final SunnahDayPhase? phase;

  bool get hasRelatedDua => relatedDuaTitle.isNotEmpty && arabic.isNotEmpty;
  bool get isSunnahPractice => kind == SunnahDuaKind.sunnah;
}
