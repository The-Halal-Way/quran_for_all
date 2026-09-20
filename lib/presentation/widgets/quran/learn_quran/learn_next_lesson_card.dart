import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/learn_quran_content.dart';
import '../../common/app_continue_box.dart';

class LearnNextLessonCard extends StatelessWidget {
  const LearnNextLessonCard({
    super.key,
    this.nextLesson,
    required this.onStart,
  });

  final LearnQuranLesson? nextLesson;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final lesson = nextLesson;
    final hasLesson = lesson != null;
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return AppContinueBox(
      onTap: onStart,
      padding: const EdgeInsets.all(AppSpacing.md),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.18),
          ),
        ),
        child: Icon(
          hasLesson ? Icons.play_lesson_rounded : Icons.verified_rounded,
          color: colorScheme.primary,
          size: 23,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasLesson
                ? l10n.learnNextContinuePathTitle
                : l10n.learnNextAllLessonsCompletedTitle,
            style: AppTheme.text(context).labelLarge.copyWith(
              color: colorScheme.primary,
              fontWeight: AppTheme.weightExtraBold,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs - 1),
          Text(
            hasLesson
                ? context.learnText(lesson.title)
                : l10n.learnNextAllLessonsCompletedBody,
            style: AppTheme.text(
              context,
            ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
          if (hasLesson) ...[
            const SizedBox(height: AppSpacing.sm - 2),
            Text(
              context.learnText(lesson.objective),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.text(context).bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.74),
              ),
            ),
          ],
        ],
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
        child: Icon(
          CupertinoIcons.chevron_forward,
          size: 15,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
