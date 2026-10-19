import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../common/app_language_action_button.dart';

class KidsBooksLibraryHeader extends StatelessWidget {
  const KidsBooksLibraryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            context.l10n.kidsBooksSectionTitle,
            style: AppTheme.text(
              context,
            ).titleLarge.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
        ),
        AppLanguageActionButton(
          current: settings.settings.language,
          onSelected: settings.setLanguage,
          tooltip: context.l10n.settingsLanguagePanelTitle,
        ),
      ],
    );
  }
}
