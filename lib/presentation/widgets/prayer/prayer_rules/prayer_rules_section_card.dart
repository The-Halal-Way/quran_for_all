import 'package:flutter/material.dart';

import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class PrayerRulesSectionCard extends StatelessWidget {
  const PrayerRulesSectionCard({
    super.key,
    required this.title,
    required this.items,
    required this.accent,
  });

  final String title;
  final List<String> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
        boxShadow: AppShadows.card(tint: accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 34,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: text.titleLarge.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (var index = 0; index < items.length; index++) ...[
            _RuleLine(number: index + 1, text: items[index], accent: accent),
            if (index != items.length - 1)
              const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine({
    required this.number,
    required this.text,
    required this.accent,
  });

  final int number;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.13),
          shape: BoxShape.circle,
          border: Border.all(color: accent.withValues(alpha: 0.24)),
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: AppTheme.text(context).labelMedium.copyWith(
            color: accent,
            fontWeight: AppTheme.weightExtraBold,
          ),
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Text(
          text,
          style: AppTheme.text(context).bodyMedium.copyWith(height: 1.55),
        ),
      ),
    ],
  );
}
