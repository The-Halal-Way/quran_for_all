import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class WuduReferenceCard extends StatelessWidget {
  const WuduReferenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: MyColors.tertiary.withValues(alpha: 0.24)),
        boxShadow: AppShadows.card(tint: MyColors.tertiary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.prayerWuduSourceTitle,
            style: text.titleMedium.copyWith(
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ReferenceLine(
            text: context.l10n.prayerWuduSourceQuran,
            accent: MyColors.tertiary,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReferenceLine(
            text: context.l10n.prayerWuduSourceHadith,
            accent: MyColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _ReferenceLine extends StatelessWidget {
  const _ReferenceLine({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: accent.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(color: accent.withValues(alpha: 0.16)),
    ),
    child: Text(
      text,
      style: AppTheme.text(context).bodySmall.copyWith(height: 1.5),
    ),
  );
}
