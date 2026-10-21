import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/quiz/quiz_config.dart';
import '../../shared/quiz_labels.dart';
import '../../shared/quiz_orbit_artwork.dart';

class QuizIntroHero extends StatelessWidget {
  const QuizIntroHero({super.key, required this.config});
  final QuizConfig config;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          colors: [Color(0xFF303E87), Color(0xFF7540B1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quizEyebrow,
                  style: text.labelSmall.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
              const QuizOrbitArtwork(size: 66),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.quizIntroTitle,
            style: text.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightExtraBold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.quizIntroDescription,
            style: text.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: .8),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _Pill(
                label:
                    '${QuizLabels.number(l10n, config.questionCount)} ${l10n.quizQuestions}',
              ),
              _Pill(
                label:
                    '${QuizLabels.number(l10n, config.categories.length)} ${l10n.quizSubjects}',
              ),
              if (config.timeLimitSeconds == null)
                _Pill(label: l10n.quizUntimed),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(AppRadius.full),
      border: Border.all(color: Colors.white.withValues(alpha: .16)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Text(
        label,
        style: AppTheme.text(context).labelSmall.copyWith(color: Colors.white),
      ),
    ),
  );
}
