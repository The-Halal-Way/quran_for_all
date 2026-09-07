import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import 'daily_duah_data.dart';

class LevelBanner extends StatelessWidget {
  const LevelBanner({super.key, required this.level, required this.isDark});

  final DuahLevel level;
  final bool isDark;

  String _description(BuildContext context) {
    switch (level) {
      case DuahLevel.beginner:
        return context.l10n.duahLevelBeginnerDesc;
      case DuahLevel.intermediate:
        return context.l10n.duahLevelIntermediateDesc;
      case DuahLevel.advanced:
        return context.l10n.duahLevelAdvancedDesc;
    }
  }

  String _levelLabel(BuildContext context) {
    switch (level) {
      case DuahLevel.beginner:
        return context.l10n.duahLevelBeginner;
      case DuahLevel.intermediate:
        return context.l10n.duahLevelIntermediate;
      case DuahLevel.advanced:
        return context.l10n.duahLevelAdvanced;
    }
  }

  Color get _accentColor {
    switch (level) {
      case DuahLevel.beginner:
        return const Color(0xFF00BFA5);
      case DuahLevel.intermediate:
        return const Color(0xFF4B30A1);
      case DuahLevel.advanced:
        return const Color(0xFFD50057);
    }
  }

  int get _duahCount =>
      DuahData.forLevel(level).fold(0, (sum, cat) => sum + cat.items.length);

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final cardBg = isDark ? const Color(0xFF171126) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _accentColor.withValues(alpha: 0.20)),
        gradient: LinearGradient(
          colors: [
            _accentColor.withValues(alpha: isDark ? 0.14 : 0.07),
            cardBg,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: _accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_levelLabel(context)} • ${context.l10n.duahCountLabel(_duahCount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall.copyWith(
                    color: _accentColor,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _description(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.duahLevelDescription.copyWith(
                    color: isDark
                        ? const Color(0xFFB39DDB)
                        : const Color(0xFF4C425C),
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
