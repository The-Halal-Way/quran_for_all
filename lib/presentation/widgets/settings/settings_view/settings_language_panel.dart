import 'package:flutter/cupertino.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'settings_choice_segment.dart';
import 'settings_panel.dart';

class SettingsLanguagePanel extends StatelessWidget {
  const SettingsLanguagePanel({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsPanel(
      title: context.l10n.settingsLanguagePanelTitle,
      icon: CupertinoIcons.globe,
      accent: MyColors.tertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.settingsLanguagePreferenceLabel,
            style: AppTheme.text(
              context,
            ).labelMedium.copyWith(fontWeight: AppTheme.weightBold),
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
