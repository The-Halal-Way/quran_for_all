import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_visuals.dart';

class PrayerForbiddenTimesCard extends StatelessWidget {
  const PrayerForbiddenTimesCard({super.key, required this.items});

  final List<PrayerForbiddenTimeItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);

    return PrayerCardShell(
      padding: EdgeInsets.zero,
      borderColor: MyColors.secondary.withValues(alpha: 0.38),
      shadowColor: MyColors.secondary,
      gradient: LinearGradient(
        colors: isDark
            ? const [Color(0xFF2A0532), MyColors.primaryDark, Color(0xFF052722)]
            : const [Color(0xFFFFE1EB), Color(0xFFEAE1FF), Color(0xFFE2FFF9)],
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
              _ForbiddenHeader(isDark: isDark, text: text),
              const SizedBox(height: AppSpacing.lg),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 680) {
                    return Column(
                      children: [
                        for (var index = 0; index < items.length; index++) ...[
                          _ForbiddenTimeTile(
                            item: items[index],
                            index: index,
                            isDark: isDark,
                          ),
                          if (index != items.length - 1)
                            const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var index = 0; index < items.length; index++) ...[
                        Expanded(
                          child: _ForbiddenTimeTile(
                            item: items[index],
                            index: index,
                            isDark: isDark,
                          ),
                        ),
                        if (index != items.length - 1)
                          const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForbiddenHeader extends StatelessWidget {
  const _ForbiddenHeader({required this.isDark, required this.text});

  final bool isDark;
  final AppTypography text;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? Colors.white : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [MyColors.secondary, MyColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: MyColors.secondary.withValues(
                  alpha: isDark ? 0.34 : 0.2,
                ),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.block_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    context.l10n.prayerForbiddenAlertTitle,
                    style: text.prayerCardTitle.copyWith(
                      color: titleColor,
                      height: 1.2,
                    ),
                  ),
                  _PauseChip(isDark: isDark),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.prayerForbiddenAlertBody,
                style: text.prayerCardBody.copyWith(
                  color: bodyColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PauseChip extends StatelessWidget {
  const _PauseChip({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.secondary.withValues(alpha: isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: MyColors.secondary.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: MyColors.secondary,
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            context.l10n.prayerForbiddenPauseLabel,
            style: text.prayerStatusChip.copyWith(color: MyColors.secondary),
          ),
        ],
      ),
    );
  }
}

class _ForbiddenTimeTile extends StatelessWidget {
  const _ForbiddenTimeTile({
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
    switch (index) {
      case 0:
        return MyColors.secondaryLight;
      case 1:
        return MyColors.tertiary;
      default:
        return MyColors.primaryLight;
    }
  }

  IconData _iconFor(int index) {
    switch (index) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
        return Icons.light_mode_rounded;
      default:
        return Icons.nights_stay_rounded;
    }
  }
}
