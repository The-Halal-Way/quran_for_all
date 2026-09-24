import 'package:flutter/material.dart';

import '../../core/theme/my_colors.dart';
import '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../l10n/app_localizations.dart';
import 'sunnah_dua_content_presenter.dart';
import 'sunnah_dua_shortcut.dart';

List<SunnahDuaShortcut> presentSunnahPrimaryShortcuts(AppLocalizations l10n) =>
    [
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
    ];

List<SunnahDuaShortcut> presentSunnahCollectionShortcuts(
  List<SunnahDuaContent> collections,
) => collections.map(_collectionShortcut).toList(growable: false);

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
