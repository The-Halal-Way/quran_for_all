import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../viewmodels/quiz/quiz_viewmodel.dart';
import '../../selection/quiz_track_labels.dart';
import '../../shared/quiz_language_badge.dart';

class QuizTopBar extends StatelessWidget {
  const QuizTopBar({super.key, required this.model, required this.onBack});
  final QuizViewModel model;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final saved = model.attempt ?? model.active;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: model.busy ? null : onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  switch (model.screen) {
                    QuizScreen.review => l10n.quizReviewTitle,
                    QuizScreen.results => l10n.quizResultsTitle,
                    _ => QuizTrackLabels.level(l10n, model.assessment.level),
                  },
                  maxLines: 2,
                  style: AppTheme.text(
                    context,
                  ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
                ),
                Text(
                  QuizTrackLabels.audience(l10n, model.assessment.audience),
                  style: AppTheme.text(context).labelSmall,
                ),
              ],
            ),
          ),
          if (saved != null) ...[
            const SizedBox(width: AppSpacing.sm),
            QuizLanguageBadge(label: saved.config.languageName(saved.language)),
          ],
        ],
      ),
    );
  }
}
