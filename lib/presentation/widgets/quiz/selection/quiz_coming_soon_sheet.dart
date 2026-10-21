import 'package:flutter/material.dart';

import '../../../../core/constants/quiz_catalog.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'quiz_track_labels.dart';

Future<void> showQuizComingSoon(
  BuildContext context,
  QuizAudience audience,
  QuizLevel level,
) => showModalBottomSheet<void>(
  context: context,
  useSafeArea: true,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) {
    final l10n = context.l10n;
    final color = QuizTrackLabels.color(audience);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: color.withValues(alpha: .12),
              child: Icon(Icons.auto_stories_rounded, color: color, size: 30),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            QuizTrackLabels.audience(l10n, audience),
            style: AppTheme.text(context).bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            QuizTrackLabels.level(l10n, level),
            style: AppTheme.text(
              context,
            ).headlineMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.quizComingSoonMessage,
            style: AppTheme.text(context).bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xxl),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.quizBrowseLevels),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  },
);
