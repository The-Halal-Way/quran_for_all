import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../core/enums/app_language.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';

class SettingsPreferencesCard extends StatelessWidget {
  const SettingsPreferencesCard({
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
    return Card(
      child: Column(
        children: [
          _SectionTitle(
            icon: Icons.tune_rounded,
            title: context.l10n.settingsReadingPreferencesTitle,
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: showPronunciation,
            onChanged: onShowPronunciationChanged,
            title: Text(context.l10n.settingsShowPronunciationTitle),
            subtitle: Text(context.l10n.settingsShowPronunciationSubtitle),
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: showTranslation,
            onChanged: onShowTranslationChanged,
            title: Text(context.l10n.settingsShowTranslationsTitle),
            subtitle: Text(context.l10n.settingsShowTranslationsSubtitle),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: DropdownButtonFormField<AppLanguage>(
              initialValue: language,
              decoration: InputDecoration(
                labelText: context.l10n.settingsLanguagePreferenceLabel,
              ),
              items: AppLanguage.values
                  .map(
                    (appLanguage) => DropdownMenuItem<AppLanguage>(
                      value: appLanguage,
                      child: Text(context.appLanguageLabel(appLanguage)),
                    ),
                  )
                  .toList(),
              onChanged: (selected) {
                if (selected != null) {
                  onLanguageChanged(selected);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);
    final boxSize = responsive.pick(mobile: 34, tablet: 30, desktop: 34);
    final iconSize = responsive.pick(mobile: 18, tablet: 16.5, desktop: 18.5);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg - 2,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.compact),
            ),
            child: Icon(icon, color: colorScheme.primary, size: iconSize),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Text(
            title,
            style: AppTheme.text(
              context,
            ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
        ],
      ),
    );
  }
}
