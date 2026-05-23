import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';

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
    final theme = Theme.of(context);
    final cardBg = isDark ? const Color(0xFF1D1238) : Colors.white;
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderC),
        gradient: LinearGradient(
          colors: [
            _accentColor.withValues(alpha: isDark ? 0.10 : 0.05),
            Colors.transparent,
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.auto_awesome_rounded, color: _accentColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _levelLabel(context),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: _accentColor,
                        fontFamily: 'Sora',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.l10n.duahCountLabel(_duahCount),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _description(context),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
                    height: 1.4,
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
