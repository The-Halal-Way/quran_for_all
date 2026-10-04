import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

class ForbiddenTimeTile extends StatelessWidget {
  const ForbiddenTimeTile({
    super.key,
    required this.item,
    required this.index,
    required this.isDark,
  });

  final PrayerForbiddenTimeItem item;
  final int index;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final accent = _accentFor(index);
    final titleColor = isDark ? Colors.white : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.07 : 0.74),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.10 : 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Icon(_iconFor(index), color: accent, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.prayerTimelineNameActive.copyWith(
                    color: titleColor,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.timeLabel,
              style: text.prayerTimelineTimeActive.copyWith(color: accent),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.body,
            style: text.bodySmall.copyWith(color: bodyColor, height: 1.45),
          ),
        ],
      ),
    );
  }

  Color _accentFor(int index) {
    return switch (index) {
      0 => MyColors.secondaryLight,
      1 => MyColors.tertiary,
      _ => MyColors.primaryLight,
    };
  }

  IconData _iconFor(int index) {
    return switch (index) {
      0 => Icons.wb_sunny_rounded,
      1 => Icons.light_mode_rounded,
      _ => Icons.nights_stay_rounded,
    };
  }
}
