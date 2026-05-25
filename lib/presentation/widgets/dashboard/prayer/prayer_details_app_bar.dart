import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

class PrayerDetailsAppBar extends StatelessWidget {
  const PrayerDetailsAppBar({
    super.key,
    required this.isDark,
    required this.onRefresh,
  });

  final bool isDark;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        IconButton(
          tooltip: context.l10n.prayerViewRefreshTooltip,
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: onRefresh,
        ),
        const _LanguageToggleAction(),
      ],
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.prayerViewTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.prayerAppBarTitle.copyWith(
              color: Colors.white,
              height: 1.2,
            ),
          ),
          Text(
            context.l10n.prayerViewAppBarSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.prayerAppBarSubtitle.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
              height: 1.2,
            ),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.fromSTEB(56, 0, 112, 14),
        background: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                MyColors.primary,
                MyColors.primaryLight,
                MyColors.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.primary.withValues(alpha: isDark ? 0.34 : 0.22),
                blurRadius: 18,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageToggleAction extends StatelessWidget {
  const _LanguageToggleAction();

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    final current = settingsVm.settings.language;
    final text = AppTheme.text(context);

    return PopupMenuButton<AppLanguage>(
      tooltip: context.l10n.prayerViewLanguageTooltip,
      icon: const Icon(Icons.language_rounded, color: Colors.white),
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
