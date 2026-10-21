import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_config.dart';
import '../../shared/quiz_labels.dart';

class QuizQuotaCard extends StatelessWidget {
  const QuizQuotaCard({super.key, required this.config});
  final QuizConfig config;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quizQuestionMix,
          style: AppTheme.text(
            context,
          ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (config.usesQuestionStyles) ...[
          Text(l10n.quizStylesNotice, style: AppTheme.text(context).bodySmall),
          const SizedBox(height: AppSpacing.sm),
        ],
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quizPerSubject,
                style: AppTheme.text(context).labelMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final quota in config.quotas.entries)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      side: BorderSide.none,
                      label: Text(
                        l10n.quizQuota(
                          quota.value,
                          QuizLabels.questionGroup(l10n, quota.key),
                        ),
                      ),
                    ),
                ],
              ),
              const Divider(height: 24),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final category in config.categories)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          QuizLabels.categoryIcon(category),
                          size: 16,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            QuizLabels.category(l10n, category),
                            style: AppTheme.text(context).bodySmall,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
