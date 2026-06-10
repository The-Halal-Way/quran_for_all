import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/daily_task_model.dart';
import 'category_header_widget.dart';

/// A single Daily Tracker checklist row: animated checkbox, English title,
/// Bangla subtitle, and optional/Friday badges.
class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({
    super.key,
    required this.task,
    required this.onToggle,
    required this.cardBg,
    required this.textMain,
    required this.textHint,
    required this.divider,
  });

  final DailyTask task;
  final ValueChanged<bool> onToggle;
  final Color cardBg;
  final Color textMain;
  final Color textHint;
  final Color divider;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final accent = categoryColor(task.category);
    final isDone = task.isCompletedToday;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: divider.withValues(alpha: 0.8), width: 0.8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => onToggle(!isDone),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? accent : Colors.transparent,
                  border: Border.all(
                    color: isDone ? accent : textHint,
                    width: 1.6,
                  ),
                ),
                child: isDone
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: text.bodyMedium.copyWith(
                        color: isDone ? textHint : textMain,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(task.titleEn),
                    ),
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: text.bodySmall.copyWith(
                        color: textHint,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      child: Text(task.titleBn),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (task.isOptional) _Badge(label: context.l10n.dailyTrackerOptionalBadge, color: MyColors.tertiary),
              if (task.isFridayOnly) ...[
                if (task.isOptional) const SizedBox(width: AppSpacing.xs),
                _Badge(
                  label: context.l10n.dailyTrackerFridayBadge,
                  color: MyColors.secondary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: text.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
