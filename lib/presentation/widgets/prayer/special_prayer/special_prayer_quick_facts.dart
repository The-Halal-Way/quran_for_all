import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

// MARK: Prayer - Special Prayer Quick Facts
class SpecialPrayerQuickFacts extends StatelessWidget {
  const SpecialPrayerQuickFacts({
    super.key,
    required this.type,
    required this.facts,
  });

  final SpecialPrayerType type;
  final List<SpecialPrayerFact> facts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        final itemWidth = wide
            ? (constraints.maxWidth - (AppSpacing.md * (facts.length - 1))) /
                  facts.length
            : constraints.maxWidth;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (var index = 0; index < facts.length; index++)
              SizedBox(
                width: itemWidth,
                child: _SpecialPrayerFactCard(
                  fact: facts[index],
                  icon: _iconFor(type, index),
                  accent: _accentFor(type, index),
                ),
              ),
          ],
        );
      },
    );
  }

  // MARK: Prayer - Special Prayer Quick Fact Icon
  IconData _iconFor(SpecialPrayerType type, int index) {
    if (type == SpecialPrayerType.janaza) {
      return switch (index) {
        0 => Icons.groups_2_rounded,
        1 => Icons.filter_4_rounded,
        _ => Icons.volunteer_activism_rounded,
      };
    }

    return switch (index) {
      0 => Icons.favorite_rounded,
      1 => Icons.exposure_plus_1_rounded,
      _ => Icons.view_week_rounded,
    };
  }

  // MARK: Prayer - Special Prayer Quick Fact Accent
  Color _accentFor(SpecialPrayerType type, int index) {
    final colors = type == SpecialPrayerType.janaza
        ? const [MyColors.tertiary, MyColors.info, MyColors.primaryLight]
        : const [MyColors.secondary, MyColors.tertiary, MyColors.info];
    return colors[index % colors.length];
  }
}

// MARK: Prayer - Special Prayer Fact Card
class _SpecialPrayerFactCard extends StatelessWidget {
  const _SpecialPrayerFactCard({
    required this.fact,
    required this.icon,
    required this.accent,
  });

  final SpecialPrayerFact fact;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      constraints: const BoxConstraints(minHeight: 142),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.16 : 0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  fact.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.prayerStatusChip.copyWith(
                    color: accent,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            fact.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.prayerCardTitle.copyWith(
              color: titleColor,
              height: 1.18,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            fact.detail,
            style: text.bodySmall.copyWith(
              color: bodyColor,
              height: 1.42,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
