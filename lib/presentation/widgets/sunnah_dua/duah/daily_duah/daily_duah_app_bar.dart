import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

import 'daily_duah_data.dart';

class DuahAppBar extends StatelessWidget {
  const DuahAppBar({
    super.key,
    required this.isDark,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  final bool isDark;
  final DuahLevel selectedLevel;
  final ValueChanged<DuahLevel> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = AppTheme.text(context);
    final colorScheme = theme.colorScheme;
    final cardBg = colorScheme.surface.withValues(alpha: 0.9);
    final borderC = colorScheme.outline.withValues(alpha: 0.28);

    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.tertiary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.duahDailyTitle,
            style: text.duahAppBarTitle.copyWith(color: Colors.white),
          ),
          Text(
            context.l10n.duahDailySubtitle,
            style: text.duahAppBarSubtitle.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
      actions: const [_LanguageToggleAction()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppRadius.base),
            border: Border.all(color: borderC),
          ),
          child: Row(
            children: DuahLevel.values.map((level) {
              return Expanded(
                child: LevelTab(
                  level: level,
                  isSelected: selectedLevel == level,
                  isDark: isDark,
                  onTap: () => onLevelChanged(level),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class LevelTab extends StatelessWidget {
  const LevelTab({
    super.key,
    required this.level,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final DuahLevel level;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  String _label(BuildContext context) {
    switch (level) {
      case DuahLevel.beginner:
        return context.l10n.duahLevelBeginner;
      case DuahLevel.intermediate:
        return context.l10n.duahLevelIntermediate;
      case DuahLevel.advanced:
        return context.l10n.duahLevelAdvanced;
    }
  }

  Color get _activeColor {
    switch (level) {
      case DuahLevel.beginner:
        return const Color(0xFF00BFA5);
      case DuahLevel.intermediate:
        return const Color(0xFF4B30A1);
      case DuahLevel.advanced:
        return const Color(0xFFD50057);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _activeColor.withValues(alpha: isDark ? 0.22 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.small),
          border: isSelected
              ? Border.all(color: _activeColor.withValues(alpha: 0.5), width: 1)
              : null,
        ),
        child: Text(
          _label(context),
          textAlign: TextAlign.center,
          style: text
              .duahLevelTab(isSelected: isSelected)
              .copyWith(
                color: isSelected
                    ? _activeColor
                    : (isDark
                          ? const Color(0xFF7E57C2)
                          : const Color(0xFF7A7288)),
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
      tooltip: context.l10n.duahLanguageToggleTooltip,
      icon: const Icon(Icons.language_rounded, color: Colors.white),
      onSelected: (language) => settingsVm.setLanguage(language),
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
