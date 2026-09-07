import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/app_language.dart';
import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../viewmodels/settings_viewmodel.dart';

class DuahLanguageMenu extends StatelessWidget {
  const DuahLanguageMenu({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final current = settings.settings.language;

    return PopupMenuButton<AppLanguage>(
      tooltip: context.l10n.duahLanguageToggleTooltip,
      onSelected: settings.setLanguage,
      icon: Icon(Icons.language_rounded, color: accent, size: 20),
      color: Theme.of(context).colorScheme.surface,
      itemBuilder: (context) => [
        for (final language in AppLanguage.values)
          PopupMenuItem<AppLanguage>(
            value: language,
            child: Row(
              children: [
                Icon(
                  current == language
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 17,
                  color: current == language
                      ? accent
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 9),
                Text(
                  context.appLanguageLabel(language),
                  style: AppTheme.text(context).bodyMedium.copyWith(
                    fontWeight: current == language
                        ? AppTheme.weightBold
                        : AppTheme.weightRegular,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
