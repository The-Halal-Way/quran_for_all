import 'package:flutter/material.dart';

import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'nafal_benefit_box.dart';
import 'nafal_hadith_reference.dart';
import 'nafal_info_pill.dart';

class NafalPrayerTile extends StatelessWidget {
  const NafalPrayerTile({
    super.key,
    required this.item,
    required this.index,
    required this.isDark,
  });

  final PrayerNafalPrayerItem item;
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.075 : 0.76),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.26)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.10 : 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(_iconFor(index), color: accent, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.prayerTimelineNameActive.copyWith(
                        color: titleColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.badge,
                      style: text.prayerStatusChip.copyWith(color: accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              NafalInfoPill(
                label: context.l10n.prayerNafalTimeLabel,
                value: item.timeLabel,
                icon: Icons.schedule_rounded,
                accent: accent,
                isDark: isDark,
              ),
              NafalInfoPill(
                label: context.l10n.prayerNafalRakahLabel,
                value: item.rakahLabel,
                icon: Icons.format_list_numbered_rounded,
                accent: accent,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.body,
            style: text.bodySmall.copyWith(color: bodyColor, height: 1.48),
          ),
          const SizedBox(height: AppSpacing.md),
          NafalBenefitBox(body: item.benefit, accent: accent, isDark: isDark),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.prayerNafalHadithReferencesLabel,
            style: text.prayerStatusChip.copyWith(color: accent),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (
            var hadithIndex = 0;
            hadithIndex < item.hadithReferences.length;
            hadithIndex++
          ) ...[
            NafalHadithReference(
              reference: item.hadithReferences[hadithIndex],
              accent: accent,
              isDark: isDark,
            ),
            if (hadithIndex != item.hadithReferences.length - 1)
              const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
    );
  }

  Color _accentFor(int index) {
    return switch (index) {
      0 => MyColors.secondaryLight,
      1 => MyColors.tertiary,
      2 => MyColors.info,
      _ => MyColors.primaryLight,
    };
  }

  IconData _iconFor(int index) {
    return switch (index) {
      0 => Icons.nightlight_round,
      1 => Icons.wb_twilight_rounded,
      2 => Icons.wb_sunny_rounded,
      _ => Icons.nights_stay_rounded,
    };
  }
}
