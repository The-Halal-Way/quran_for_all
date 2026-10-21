import 'package:flutter/material.dart';

import '../../../../core/constants/quiz_catalog.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'quiz_track_labels.dart';

class QuizLevelTile extends StatelessWidget {
  const QuizLevelTile({
    super.key,
    required this.level,
    required this.color,
    required this.available,
    required this.onTap,
  });

  final QuizLevel level;
  final Color color;
  final bool available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final foreground = available ? color : scheme.onSurfaceVariant;
    final radius = BorderRadius.circular(AppRadius.md);
    return Semantics(
      button: true,
      child: Material(
        color: available
            ? color.withValues(alpha: .12)
            : scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: available
                ? color.withValues(alpha: .4)
                : scheme.outlineVariant.withValues(alpha: .6),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  available
                      ? Icons.arrow_outward_rounded
                      : Icons.hourglass_empty_rounded,
                  color: foreground,
                  size: 20,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  QuizTrackLabels.level(l10n, level),
                  style: AppTheme.text(context).labelMedium.copyWith(
                    color: available
                        ? scheme.onSurface
                        : scheme.onSurfaceVariant,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  available ? l10n.quizLevelAvailable : l10n.quizLevelSoon,
                  style: AppTheme.text(
                    context,
                  ).labelSmall.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
