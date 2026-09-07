import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import 'daily_duah_data.dart';

class DailyDuahLevelSelector extends StatelessWidget {
  const DailyDuahLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  final DuahLevel selectedLevel;
  final ValueChanged<DuahLevel> onLevelChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          for (final level in DuahLevel.values)
            Expanded(
              child: _LevelSegment(
                level: level,
                selected: level == selectedLevel,
                onTap: () => onLevelChanged(level),
              ),
            ),
        ],
      ),
    );
  }
}

class _LevelSegment extends StatelessWidget {
  const _LevelSegment({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final DuahLevel level;
  final bool selected;
  final VoidCallback onTap;

  Color get _accent => switch (level) {
    DuahLevel.beginner => const Color(0xFF00A891),
    DuahLevel.intermediate => const Color(0xFF6044BA),
    DuahLevel.advanced => const Color(0xFFD50057),
  };

  String _label(BuildContext context) => switch (level) {
    DuahLevel.beginner => context.l10n.duahLevelBeginner,
    DuahLevel.intermediate => context.l10n.duahLevelIntermediate,
    DuahLevel.advanced => context.l10n.duahLevelAdvanced,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: selected
                ? _accent.withValues(alpha: 0.13)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: selected
                ? Border.all(color: _accent.withValues(alpha: 0.34))
                : null,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _label(context),
              maxLines: 1,
              style: AppTheme.text(context).labelSmall.copyWith(
                color: selected
                    ? _accent
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.55),
                fontWeight: AppTheme.weightExtraBold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
