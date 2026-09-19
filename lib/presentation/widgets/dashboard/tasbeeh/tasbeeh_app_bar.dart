import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_language_action_button.dart';

class TasbeehAppBar extends StatelessWidget {
  const TasbeehAppBar({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colors = Theme.of(context).colorScheme;
    final foreground = colors.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(CupertinoIcons.chevron_back, size: 21),
            color: foreground,
            style: IconButton.styleFrom(
              backgroundColor: colors.surfaceContainerHighest.withValues(
                alpha: isDark ? 0.7 : 0.8,
              ),
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.tasbeehTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleLarge.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  context.l10n.tasbeehSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall.copyWith(
                    color: foreground.withValues(alpha: isDark ? 0.76 : 0.72),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _LanguageToggleAction(iconColor: foreground),
        ],
      ),
    );
  }
}

class _LanguageToggleAction extends StatelessWidget {
  const _LanguageToggleAction({required this.iconColor});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    return AppLanguageActionButton(
      tooltip: context.l10n.duahLanguageToggleTooltip,
      current: settingsVm.settings.language,
      iconColor: iconColor,
      onSelected: settingsVm.setLanguage,
    );
  }
}
