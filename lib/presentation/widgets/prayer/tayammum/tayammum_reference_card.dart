import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

class TayammumReferenceCard extends StatelessWidget {
  const TayammumReferenceCard({super.key});

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
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: MyColors.tertiary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.prayerTayammumSourceTitle,
                  style: text.titleMedium.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _ReferenceLine(
            icon: Icons.auto_stories_rounded,
            text: context.l10n.prayerTayammumSourceQuran,
            accent: MyColors.tertiary,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReferenceLine(
            icon: Icons.format_quote_rounded,
            text: context.l10n.prayerTayammumSourceHadith,
            accent: MyColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _ReferenceLine extends StatelessWidget {
  const _ReferenceLine({
    required this.icon,
    required this.text,
    required this.accent,
  });

  final IconData icon;
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accent, size: 19),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTheme.text(context).bodySmall.copyWith(height: 1.5),
          ),
        ),
      ],
    ),
  );
}
