import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class DailyTrackerCelebration extends StatelessWidget {
  const DailyTrackerCelebration({super.key, required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.black54,
    child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [MyColors.primary, MyColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                border: Border.all(
                  color: MyColors.tertiaryLight.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: MyColors.tertiaryLight,
                    size: 42,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'ما شاء الله',
                    textDirection: TextDirection.rtl,
                    style: AppTheme.text(
                      context,
                    ).duahArabic.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.l10n.dailyTrackerCelebrationTitle,
                    textAlign: TextAlign.center,
                    style: AppTheme.text(
                      context,
                    ).titleMedium.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: onDismiss,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: MyColors.primary,
                    ),
                    child: Text(context.l10n.dailyTrackerCelebrationButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
