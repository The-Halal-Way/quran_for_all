import 'package:flutter/cupertino.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'settings_choice_segment.dart';
import 'settings_panel.dart';
import 'settings_toggle_row.dart';

class SettingsPreferencesPanel extends StatelessWidget {
  const SettingsPreferencesPanel({
    super.key,
    required this.showPronunciation,
    required this.showTranslation,
    required this.language,
    required this.onShowPronunciationChanged,
    required this.onShowTranslationChanged,
    required this.onLanguageChanged,
  });

  final bool showPronunciation;
  final bool showTranslation;
  final AppLanguage language;
  final ValueChanged<bool> onShowPronunciationChanged;
  final ValueChanged<bool> onShowTranslationChanged;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsPanel(
      title: context.l10n.settingsReadingPreferencesTitle,
      icon: CupertinoIcons.slider_horizontal_3,
      accent: MyColors.tertiary,
      child: Column(
        children: [
          SettingsToggleRow(
            title: context.l10n.settingsShowPronunciationTitle,
            semanticDescription: context.l10n.settingsShowPronunciationSubtitle,
            icon: CupertinoIcons.speaker_2_fill,
            value: showPronunciation,
            onChanged: onShowPronunciationChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          SettingsToggleRow(
            title: context.l10n.settingsShowTranslationsTitle,
            semanticDescription: context.l10n.settingsShowTranslationsSubtitle,
            icon: CupertinoIcons.textformat,
            value: showTranslation,
            onChanged: onShowTranslationChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.l10n.settingsLanguagePreferenceLabel,
              style: AppTheme.text(
                context,
              ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) => Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final option in AppLanguage.values)
                  SizedBox(
                    width: (constraints.maxWidth - AppSpacing.sm) / 2,
                    child: SettingsChoiceSegment<AppLanguage>(
                      value: option,
                      selectedValue: language,
                      label: context.appLanguageLabel(option),
                      icon: CupertinoIcons.globe,
                      accent: MyColors.tertiary,
                      onSelected: onLanguageChanged,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
