import 'package:flutter/material.dart';

import '../../../../core/constants/quiz_catalog.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'quiz_level_tile.dart';
import 'quiz_track_labels.dart';

class QuizAudienceSection extends StatelessWidget {
  const QuizAudienceSection({
    super.key,
    required this.audience,
    required this.onSelect,
  });

  final QuizAudience audience;
  final ValueChanged<QuizLevel> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    final scheme = Theme.of(context).colorScheme;
    final color = QuizTrackLabels.color(audience);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(color.withValues(alpha: .08), scheme.surface),
            scheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  QuizTrackLabels.icon(audience),
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  QuizTrackLabels.audience(l10n, audience),
                  style: text.titleMedium.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            QuizTrackLabels.description(l10n, audience),
            style: text.bodySmall.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 290 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.3;
              final width = stacked
                  ? constraints.maxWidth
                  : (constraints.maxWidth - AppSpacing.sm * 2) / 3;
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final level in QuizLevel.values)
                    SizedBox(
                      width: width,
                      child: QuizLevelTile(
                        level: level,
                        color: color,
                        available: QuizCatalog.find(audience, level) != null,
                        onTap: () => onSelect(level),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
