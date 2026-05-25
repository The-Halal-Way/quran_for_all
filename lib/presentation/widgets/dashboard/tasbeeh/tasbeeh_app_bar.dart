import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

class TasbeehAppBar extends StatelessWidget {
  const TasbeehAppBar({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final foreground = isDark ? Colors.white : MyColors.textPrimary;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [
                  MyColors.primaryDark,
                  MyColors.primary,
                  MyColors.secondaryDark,
                ]
              : const [Color(0xFFE8DDFF), Color(0xFFFFD1E1), Color(0xFFD8FFF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: (isDark ? Colors.white : MyColors.primary).withValues(
            alpha: isDark ? 0.08 : 0.08,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: isDark ? 0.26 : 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: foreground),
            onPressed: () => Navigator.maybePop(context),
          ),
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
    final current = settingsVm.settings.language;
    final text = AppTheme.text(context);

    return PopupMenuButton<AppLanguage>(
      tooltip: context.l10n.duahLanguageToggleTooltip,
      icon: Icon(Icons.language_rounded, color: iconColor),
      onSelected: settingsVm.setLanguage,
      itemBuilder: (context) => [
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.english,
          child: Text(
            context.appLanguageLabel(AppLanguage.english),
            style: current == AppLanguage.english
                ? text.labelMedium
                : text.bodyMedium,
          ),
        ),
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.bangla,
          child: Text(
            context.appLanguageLabel(AppLanguage.bangla),
            style: current == AppLanguage.bangla
                ? text.labelMedium
                : text.bodyMedium,
          ),
        ),
      ],
    );
  }
}
