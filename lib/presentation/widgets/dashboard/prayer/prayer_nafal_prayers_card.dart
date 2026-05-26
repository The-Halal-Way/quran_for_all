import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_visuals.dart';

class PrayerNafalPrayersCard extends StatelessWidget {
  const PrayerNafalPrayersCard({super.key, required this.items});

  final List<PrayerNafalPrayerItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: MyColors.tertiary.withValues(alpha: 0.32),
      shadowColor: MyColors.tertiary,
      gradient: LinearGradient(
        colors: isDark
            ? const [Color(0xFF071E2C), Color(0xFF21062F), Color(0xFF032D28)]
            : const [Color(0xFFE2FFF9), Color(0xFFF0E7FF), Color(0xFFFFE6F0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NafalHeader(isDark: isDark),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 680;
                  final tileWidth = wide
                      ? (constraints.maxWidth - AppSpacing.md) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (var index = 0; index < items.length; index++)
                        SizedBox(
                          width: tileWidth,
                          child: _NafalPrayerTile(
                            item: items[index],
                            index: index,
                            isDark: isDark,
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              _NafalNote(isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _NafalHeader extends StatelessWidget {
  const _NafalHeader({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? Colors.white : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [MyColors.tertiary, MyColors.secondaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: MyColors.tertiary.withValues(alpha: isDark ? 0.34 : 0.2),
                blurRadius: 24,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Center(
            child: Text(
              context.l10n.prayerNafalArabicLabel,
              style: AppTheme.amiri(
                context,
                fontSize: 28,
                fontWeight: AppTheme.weightBold,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.prayerNafalTitle,
                style: text.prayerCardTitle.copyWith(
                  color: titleColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.prayerNafalSubtitle,
                style: text.prayerCardBody.copyWith(
                  color: bodyColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  _NafalStatChip(
                    icon: Icons.timeline_rounded,
                    label: context.l10n.prayerNafalDailyFlowLabel,
                    accent: MyColors.tertiary,
                    isDark: isDark,
                  ),
                  _NafalStatChip(
                    icon: Icons.tune_rounded,
                    label: context.l10n.prayerNafalFlexibleLabel,
                    accent: MyColors.secondary,
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NafalStatChip extends StatelessWidget {
  const _NafalStatChip({
    required this.icon,
    required this.label,
    required this.accent,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(label, style: text.prayerStatusChip.copyWith(color: accent)),
        ],
      ),
    );
  }
}

class _NafalPrayerTile extends StatelessWidget {
  const _NafalPrayerTile({
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
              _NafalInfoPill(
                label: context.l10n.prayerNafalTimeLabel,
                value: item.timeLabel,
                icon: Icons.schedule_rounded,
                accent: accent,
                isDark: isDark,
              ),
              _NafalInfoPill(
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
          _NafalBenefitBox(body: item.benefit, accent: accent, isDark: isDark),
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
            _NafalHadithReferenceCard(
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
    switch (index) {
      case 0:
        return MyColors.secondaryLight;
      case 1:
        return MyColors.tertiary;
      case 2:
        return MyColors.info;
      default:
        return MyColors.primaryLight;
    }
  }

  IconData _iconFor(int index) {
    switch (index) {
      case 0:
        return Icons.nightlight_round;
      case 1:
        return Icons.wb_twilight_rounded;
      case 2:
        return Icons.wb_sunny_rounded;
      default:
        return Icons.nights_stay_rounded;
    }
  }
}

class _NafalBenefitBox extends StatelessWidget {
  const _NafalBenefitBox({
    required this.body,
    required this.accent,
    required this.isDark,
  });

  final String body;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final bodyColor = isDark ? Colors.white : MyColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite_rounded, color: accent, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: text.bodySmall.copyWith(color: bodyColor, height: 1.42),
                children: [
                  TextSpan(
                    text: '${context.l10n.prayerNafalBenefitLabel}: ',
                    style: TextStyle(
                      color: accent,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                  TextSpan(text: body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NafalHadithReferenceCard extends StatelessWidget {
  const _NafalHadithReferenceCard({
    required this.reference,
    required this.accent,
    required this.isDark,
  });

  final PrayerHadithReference reference;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? Colors.white : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.58),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.menu_book_rounded, color: accent, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reference.source,
                  style: text.prayerStatusChip.copyWith(
                    color: titleColor,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  reference.body,
                  style: text.bodySmall.copyWith(
                    color: bodyColor,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NafalInfoPill extends StatelessWidget {
  const _NafalInfoPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    required this.isDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final valueColor = isDark ? Colors.white : MyColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(
            '$label: ',
            style: text.prayerStatusChip.copyWith(color: accent),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: text.prayerStatusChip.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _NafalNote extends StatelessWidget {
  const _NafalNote({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? Colors.white : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: MyColors.primaryLight.withValues(alpha: isDark ? 0.14 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: MyColors.primaryLight.withValues(alpha: isDark ? 0.24 : 0.16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: MyColors.primaryLight,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.prayerNafalNoteTitle,
                  style: text.prayerStepIndex.copyWith(
                    color: titleColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.prayerNafalNoteBody,
                  style: text.bodySmall.copyWith(
                    color: bodyColor,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
