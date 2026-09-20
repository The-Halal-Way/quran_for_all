import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import 'settings_choice_segment.dart';
import 'settings_panel.dart';

class SettingsThemePanel extends StatelessWidget {
  const SettingsThemePanel({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final choices = [
      (
        ThemeMode.system,
        context.l10n.settingsThemeSystem,
        CupertinoIcons.circle_lefthalf_fill,
      ),
      (
        ThemeMode.light,
        context.l10n.settingsThemeLight,
        CupertinoIcons.sun_max_fill,
      ),
      (
        ThemeMode.dark,
        context.l10n.settingsThemeDark,
        CupertinoIcons.moon_stars_fill,
      ),
    ];

    return SettingsPanel(
      title: context.l10n.settingsAppearanceTitle,
      icon: CupertinoIcons.paintbrush_fill,
      accent: MyColors.primaryLight,
      child: Row(
        children: [
          for (var index = 0; index < choices.length; index++) ...[
            Expanded(
              child: SettingsChoiceSegment<ThemeMode>(
                value: choices[index].$1,
                selectedValue: themeMode,
                label: choices[index].$2,
                icon: choices[index].$3,
                accent: MyColors.primaryLight,
                onSelected: onThemeModeChanged,
              ),
            ),
            if (index < choices.length - 1)
              const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
