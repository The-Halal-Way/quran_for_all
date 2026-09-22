import 'package:flutter/material.dart';

import '../../core/theme/my_colors.dart';
import 'sunnah_dua_item.dart';

SunnahDuaItem presentSunnahContent(SunnahDuaContent content) {
  final accent = switch (content.phase) {
    SunnahDayPhase.morning => MyColors.tertiaryDark,
    SunnahDayPhase.daytime => MyColors.secondary,
    SunnahDayPhase.evening => MyColors.primaryLight,
    null =>
      content.kind == SunnahDuaKind.dua
          ? MyColors.secondary
          : MyColors.tertiaryDark,
  };
  return SunnahDuaItem(
    id: content.id,
    kind: content.kind,
    phase: content.phase,
    icon: _iconFor(content.id),
    accent: accent,
    gradientColors: [MyColors.primary, accent],
    title: content.title,
    subtitle: content.subtitle,
    arabic: content.arabic,
    pronunciation: content.pronunciation,
    translation: content.translation,
    practice: content.practice,
    source: content.source,
    sunnahPoints: content.points,
    isFeatured: content.id == 'waking_up' || content.id == 'sleeping_sunnahs',
  );
}

IconData _iconFor(String id) => switch (id) {
  'waking_up' => Icons.wb_twilight_rounded,
  'washroom' => Icons.wash_rounded,
  'miswak' => Icons.brush_rounded,
  'wudu_sunnahs' => Icons.water_drop_rounded,
  'dressing' => Icons.checkroom_rounded,
  'adhan' => Icons.hearing_rounded,
  'masjid_sunnahs' => Icons.mosque_rounded,
  'after_prayer' => Icons.auto_awesome_rounded,
  'morning_remembrance' => Icons.light_mode_rounded,
  'duha' => Icons.wb_sunny_rounded,
  'leaving_home' => Icons.directions_walk_rounded,
  'eating_sunnahs' => Icons.restaurant_rounded,
  'drinking' => Icons.local_drink_rounded,
  'greetings' => Icons.waving_hand_rounded,
  'good_speech' => Icons.forum_rounded,
  'sneezing_sunnah' => Icons.air_rounded,
  'returning_home' => Icons.home_rounded,
  'family' => Icons.diversity_1_rounded,
  'evening_remembrance' => Icons.wb_twilight_rounded,
  'night_safety' => Icons.door_front_door_rounded,
  'bedtime_recitation' => Icons.menu_book_rounded,
  'sleeping_sunnahs' => Icons.bedtime_rounded,
  'seeking_forgiveness' => Icons.favorite_rounded,
  'difficulty' => Icons.shield_rounded,
  'morning_evening' => Icons.flare_rounded,
  'gratitude' => Icons.volunteer_activism_rounded,
  'siyam_sunnahs' => Icons.no_meals_rounded,
  'after_salah' => Icons.auto_awesome_rounded,
  'salawat' => Icons.favorite_rounded,
  'when_angry' => Icons.self_improvement_rounded,
  'during_loss' => Icons.healing_rounded,
  'after_fajr' => Icons.wb_sunny_rounded,
  'ending_gathering' => Icons.groups_rounded,
  'bedtime_dhikr' => Icons.bedtime_rounded,
  _ => Icons.auto_awesome_rounded,
};
