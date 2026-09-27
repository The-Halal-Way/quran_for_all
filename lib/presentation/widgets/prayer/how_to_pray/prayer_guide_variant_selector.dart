import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/prayer/prayer_guide_variant.dart';
import 'prayer_guide_variant_option.dart';

class PrayerGuideVariantSelector extends StatelessWidget {
  const PrayerGuideVariantSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PrayerGuideVariant selected;
  final ValueChanged<PrayerGuideVariant> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.prayerMovementsVariantTitle,
          style: AppTheme.text(
            context,
          ).titleMedium.copyWith(fontWeight: AppTheme.weightExtraBold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.prayerMovementsVariantSubtitle,
          style: AppTheme.text(
            context,
          ).bodySmall.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(
                child: PrayerGuideVariantOption(
                  label: l10n.prayerMovementsMaleLabel,
                  icon: Icons.man_rounded,
                  selected: selected == PrayerGuideVariant.male,
                  onTap: () => onSelected(PrayerGuideVariant.male),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: PrayerGuideVariantOption(
                  label: l10n.prayerMovementsFemaleLabel,
                  icon: Icons.woman_rounded,
                  selected: selected == PrayerGuideVariant.female,
                  onTap: () => onSelected(PrayerGuideVariant.female),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
