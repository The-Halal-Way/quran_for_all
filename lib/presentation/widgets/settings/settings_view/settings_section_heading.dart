import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsSectionHeading extends StatelessWidget {
  const SettingsSectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.accent,
  });

  final String eyebrow;
  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 52,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: text.labelMedium.copyWith(
                  color: accent,
                  letterSpacing: 1.2,
                  fontWeight: AppTheme.weightBold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: text.titleLarge.copyWith(
                  fontWeight: AppTheme.weightExtraBold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
