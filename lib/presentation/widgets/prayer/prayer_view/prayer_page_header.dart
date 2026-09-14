import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class PrayerPageHeader extends StatelessWidget {
  const PrayerPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: colors.outline.withValues(alpha: 0.5)),
          ),
          child: Icon(Icons.mosque_outlined, color: colors.secondary, size: 26),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.prayerViewTitle, style: text.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.prayerViewAppBarSubtitle,
                style: text.bodySmall.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
