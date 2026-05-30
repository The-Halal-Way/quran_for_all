import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';

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
          _SectionIntro(section: section, index: index, accent: accent),
          const SizedBox(height: AppSpacing.lg),
          for (
            var pointIndex = 0;
            pointIndex < section.points.length;
            pointIndex++
          ) ...[
            _SpecialPrayerPointTile(
              point: section.points[pointIndex],
              index: pointIndex,
              accent: accent,
            ),
            if (pointIndex != section.points.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.lg),
          _SectionCommentBox(
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

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
    required this.section,
    required this.index,
    required this.accent,
  });

  final SpecialPrayerSection section;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: accent.withValues(alpha: 0.28)),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: text.prayerStepIndex.copyWith(
                color: accent,
                letterSpacing: 0,
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
                section.title,
                style: text.prayerCardTitle.copyWith(
                  color: titleColor,
                  height: 1.2,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                section.body,
                style: text.prayerCardBody.copyWith(
                  color: bodyColor,
                  height: 1.5,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecialPrayerPointTile extends StatelessWidget {
  const _SpecialPrayerPointTile({
    required this.point,
    required this.index,
    required this.accent,
  });

  final SpecialPrayerPoint point;
  final int index;
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.055)
            : Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PointMarker(
                label: point.badge ?? '${index + 1}',
                accent: accent,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.title,
                      style: text.prayerTimelineNameActive.copyWith(
                        color: titleColor,
                        height: 1.22,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      point.body,
                      style: text.bodySmall.copyWith(
                        color: bodyColor,
                        height: 1.48,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (point.arabic != null ||
              point.pronunciation != null ||
              point.translation != null) ...[
            const SizedBox(height: AppSpacing.md),
            _PrayerPhrasePanel(point: point, accent: accent),
          ],
        ],
      ),
    );
  }
}

class _PointMarker extends StatelessWidget {
  const _PointMarker({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);

    return Container(
      width: 42,
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: text.prayerStatusChip.copyWith(
              color: accent,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerPhrasePanel extends StatelessWidget {
  const _PrayerPhrasePanel({required this.point, required this.accent});

  final SpecialPrayerPoint point;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (point.arabic != null)
            Text(
              point.arabic!,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTheme.amiri(
                context,
                fontSize: 25,
                fontWeight: AppTheme.weightBold,
                color: isDark ? Colors.white : MyColors.textPrimary,
                height: 1.7,
                letterSpacing: 0,
              ),
            ),
          if (point.pronunciation != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              point.pronunciation!,
              style: text.prayerCardBodyEmphasis.copyWith(
                color: accent,
                letterSpacing: 0,
              ),
            ),
          ],
          if (point.translation != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              point.translation!,
              style: text.bodySmall.copyWith(
                color: bodyColor,
                height: 1.45,
                letterSpacing: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCommentBox extends StatelessWidget {
  const _SectionCommentBox({
    required this.label,
    required this.body,
    required this.accent,
  });

  final String label;
  final String body;
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
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.13 : 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.mode_comment_outlined, color: accent, size: 19),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: text.prayerStatusChip.copyWith(
                    color: titleColor,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  body,
                  style: text.bodySmall.copyWith(
                    color: bodyColor,
                    height: 1.45,
                    letterSpacing: 0,
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
