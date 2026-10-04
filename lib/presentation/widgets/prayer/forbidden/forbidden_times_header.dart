import 'package:flutter/material.dart';

import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class ForbiddenTimesHeader extends StatelessWidget {
  const ForbiddenTimesHeader({super.key, required this.isDark});

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
                  _ForbiddenPauseChip(isDark: isDark),
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

class _ForbiddenPauseChip extends StatelessWidget {
  const _ForbiddenPauseChip({required this.isDark});

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
