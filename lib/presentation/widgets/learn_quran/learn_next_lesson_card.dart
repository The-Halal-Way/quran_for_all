import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/learn_quran_content.dart';
import '../common/app_continue_box.dart';
import '../common/common_painters.dart';

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
      leading: SizedBox(
        width: 62.w.clamp(56.0, 68.0),
        height: 58.h.clamp(50.0, 64.0),
        child: CustomPaint(
          painter: YShapePainter(
            backgroundColor: colorScheme.primary.withValues(alpha: 0.16),
            shadowColor: colorScheme.primary.withValues(alpha: 0.12),
            bumpWidth: 30,
            bumpHeight: 9,
            shadowBlurRadius: 5,
          ),
          child: Center(
            child: Icon(
              hasLesson ? Icons.play_lesson_rounded : Icons.verified_rounded,
              color: colorScheme.primary,
              size: 25.sp.clamp(22.0, 27.0),
            ),
          ),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasLesson
                ? l10n.learnNextContinuePathTitle
                : l10n.learnNextAllLessonsCompletedTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs - 1),
          Text(
            hasLesson
                ? context.learnText(lesson.title)
                : l10n.learnNextAllLessonsCompletedBody,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (hasLesson) ...[
            const SizedBox(height: AppSpacing.sm - 2),
            Text(
              context.learnText(lesson.objective),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.74),
              ),
            ),
          ],
        ],
      ),
      trailing: Container(
        width: 32.w.clamp(30.0, 36.0),
        height: 32.w.clamp(30.0, 36.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16.sp.clamp(14.0, 17.0),
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
