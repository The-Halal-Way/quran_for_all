import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/my_colors.dart';
import 'daily_duah_data.dart';

class DailyDuahSubItemCard extends StatelessWidget {
  const DailyDuahSubItemCard({super.key, required this.item});

  final DuahItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: MyColors.secondary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: MyColors.secondary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            item.localizedTitle(context),
            style: AppTheme.text(context).titleSmall.copyWith(
              color: MyColors.secondary,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.arabic,
            textAlign: TextAlign.right,
            textDirection: ui.TextDirection.rtl,
            style: AppTheme.text(context).titleLarge.copyWith(height: 1.7),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.localizedTranslation(context),
            style: AppTheme.text(context).bodySmall.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}
