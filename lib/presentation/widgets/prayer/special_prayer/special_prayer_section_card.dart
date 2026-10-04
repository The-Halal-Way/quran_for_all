import 'package:flutter/material.dart';

import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_card_shell.dart';
import 'special_prayer_comment_box.dart';
import 'special_prayer_point_tile.dart';
import 'special_prayer_section_intro.dart';

class SpecialPrayerSectionCard extends StatelessWidget {
  const SpecialPrayerSectionCard({
    super.key,
    required this.section,
    required this.index,
    required this.type,
    required this.commentLabel,
  });

  final SpecialPrayerSection section;
  final int index;
  final SpecialPrayerType type;
  final String commentLabel;

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(type, index);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PrayerCardShell(
      borderColor: accent.withValues(alpha: 0.22),
      shadowColor: accent,
      gradient: LinearGradient(
        colors: [
          accent.withValues(alpha: isDark ? 0.13 : 0.06),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpecialPrayerSectionIntro(
            section: section,
            index: index,
            accent: accent,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (
            var pointIndex = 0;
            pointIndex < section.points.length;
            pointIndex++
          ) ...[
            SpecialPrayerPointTile(
              point: section.points[pointIndex],
              index: pointIndex,
              accent: accent,
            ),
            if (pointIndex != section.points.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.lg),
          SpecialPrayerCommentBox(
            label: commentLabel,
            body: section.comment,
            accent: accent,
          ),
        ],
      ),
    );
  }

  Color _accentFor(SpecialPrayerType type, int index) {
    final colors = type == SpecialPrayerType.janaza
        ? const [
            MyColors.tertiary,
            MyColors.info,
            MyColors.primaryLight,
            MyColors.secondary,
          ]
        : const [
            MyColors.secondary,
            MyColors.tertiary,
            MyColors.info,
            MyColors.primaryLight,
          ];
    return colors[index % colors.length];
  }
}
