import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class PrayerRulesReferenceCard extends StatelessWidget {
  const PrayerRulesReferenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: MyColors.primaryLight.withValues(alpha: 0.24),
        ),
        boxShadow: AppShadows.card(tint: MyColors.primaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.prayerRulesSourceTitle,
            style: text.titleMedium.copyWith(
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.l10n.prayerRulesSourceQuran,
            style: text.bodySmall.copyWith(height: 1.5),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.l10n.prayerRulesSourceHadith,
            style: text.bodySmall.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
