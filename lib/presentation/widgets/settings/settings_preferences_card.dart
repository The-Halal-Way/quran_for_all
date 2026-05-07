import 'package:flutter/material.dart';

import '../../../core/enums/app_language.dart';
import '../../../core/localization/l10n_extensions.dart';

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
          const _SectionTitle(
            icon: Icons.tune_rounded,
            title: 'Reading Preferences',
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: showPronunciation,
            onChanged: onShowPronunciationChanged,
            title: const Text('Show pronunciation'),
            subtitle: const Text('Display transliteration under Arabic ayah.'),
          ),
          const Divider(height: 1),
          SwitchListTile(
            value: showTranslation,
            onChanged: onShowTranslationChanged,
            title: const Text('Show translations'),
            subtitle: const Text('Display meaning in your selected language.'),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: DropdownButtonFormField<AppLanguage>(
              initialValue: language,
              decoration: const InputDecoration(labelText: 'Language preference'),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
