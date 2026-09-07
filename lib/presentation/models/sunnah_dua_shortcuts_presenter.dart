import 'package:flutter/material.dart';

import '../../core/theme/my_colors.dart';
import '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../domain/usecases/sunnah_dua/search_sunnah_content.dart';
import '../../l10n/app_localizations.dart';
import 'sunnah_dua_content_presenter.dart';
import 'sunnah_dua_shortcut.dart';

List<SunnahDuaShortcut> presentSunnahShortcuts(
  AppLocalizations l10n,
  List<SunnahDuaContent> collections,
  String query,
) {
  final shortcuts = [
    SunnahDuaShortcut(
      id: 'daily_dua',
      title: l10n.dashboardActionDailyDua,
      subtitle: l10n.dashboardActionDailyDuaSub,
      icon: Icons.wb_twilight_rounded,
      accent: MyColors.tertiary,
      destination: SunnahDuaDestination.dailyDua,
    ),
    SunnahDuaShortcut(
      id: 'powerful_dua',
      title: l10n.dashboardActionPowerfulDua,
      subtitle: l10n.dashboardActionPowerfulDuaSub,
      icon: Icons.bolt_rounded,
      accent: MyColors.secondary,
      destination: SunnahDuaDestination.powerfulDua,
    ),
    SunnahDuaShortcut(
      id: 'names',
      title: l10n.dashboardActionNintyNineNames,
      subtitle: l10n.dashboardActionNintyNineNamesSub,
      icon: Icons.diamond_rounded,
      accent: MyColors.primaryLight,
      destination: SunnahDuaDestination.names,
    ),
    for (final content in collections) _collectionShortcut(content),
  ];
  return shortcuts
      .where(
        (shortcut) => SearchSunnahContent.matches(
          '${shortcut.title} ${shortcut.subtitle}',
          query,
        ),
      )
      .toList(growable: false);
}

SunnahDuaShortcut _collectionShortcut(SunnahDuaContent content) {
  final detail = presentSunnahContent(content);
  return SunnahDuaShortcut(
    id: content.id,
    title: content.title,
    subtitle: content.subtitle,
    icon: detail.icon,
    accent: detail.accent,
    destination: SunnahDuaDestination.detail,
    detail: detail,
  );
}
