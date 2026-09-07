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
        Icons.brightness_auto_rounded,
      ),
      (
        ThemeMode.light,
        context.l10n.settingsThemeLight,
        Icons.light_mode_rounded,
      ),
      (ThemeMode.dark, context.l10n.settingsThemeDark, Icons.dark_mode_rounded),
    ];

    return SettingsPanel(
      title: context.l10n.settingsAppearanceTitle,
      icon: Icons.palette_outlined,
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
