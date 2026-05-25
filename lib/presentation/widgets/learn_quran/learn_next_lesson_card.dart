import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
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
    final responsive = AppResponsive.of(context);
    final leadingWidth = responsive.pick(mobile: 62, tablet: 56, desktop: 64);
    final leadingHeight = responsive.pick(mobile: 58, tablet: 52, desktop: 60);
    final leadingIconSize = responsive.pick(
      mobile: 25,
      tablet: 22,
      desktop: 26,
    );
    final trailingSize = responsive.pick(mobile: 32, tablet: 30, desktop: 34);
    final trailingIconSize = responsive.pick(
      mobile: 16,
      tablet: 14.5,
      desktop: 16.5,
    );

    return AppContinueBox(
      onTap: onStart,
      leading: SizedBox(
        width: leadingWidth,
        height: leadingHeight,
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
              size: leadingIconSize,
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
              style: AppTheme.text(context).bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.74),
              ),
            ),
          ],
        ],
      ),
      trailing: Container(
        width: trailingSize,
        height: trailingSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withValues(alpha: 0.12),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: trailingIconSize,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
