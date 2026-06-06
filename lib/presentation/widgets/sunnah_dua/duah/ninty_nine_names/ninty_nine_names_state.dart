import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class NintyNineNamesLoadingState extends StatelessWidget {
  const NintyNineNamesLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: MyColors.secondary,
            strokeWidth: 2,
          ),
          const SizedBox(height: 14),
          Text(
            context.l10n.duahNintyNineLoading,
            style: text.bodyMedium.copyWith(color: MyColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class NintyNineNamesErrorState extends StatelessWidget {
  const NintyNineNamesErrorState({
    super.key,
    required this.isDark,
    required this.onRetry,
  });

  final bool isDark;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final cardBg = isDark ? MyColors.darkCardFill : MyColors.cardFill;
    final borderC = isDark ? MyColors.darkDivider : MyColors.divider;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderC),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: MyColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: MyColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.duahNintyNineLoadError,
              textAlign: TextAlign.center,
              style: text.titleMedium.copyWith(
                color: titleColor,
                fontWeight: AppTheme.weightBold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.duahNintyNineLoadErrorBody,
              textAlign: TextAlign.center,
              style: text.bodySmall.copyWith(color: bodyColor),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 17),
              label: Text(context.l10n.duahNintyNineRetry),
            ),
          ],
        ),
      ),
    );
  }
}
