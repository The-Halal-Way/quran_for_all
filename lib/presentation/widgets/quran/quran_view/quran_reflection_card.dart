import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/quran/quran_hub_models.dart';

class QuranReflectionCard extends StatelessWidget {
  const QuranReflectionCard({super.key, required this.hadith});

  final QuranHubHadith hadith;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;
    final titleColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final bodyColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          colors: [
            surface,
            Color.lerp(surface, hadith.accent, isDark ? 0.13 : 0.055)!,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        border: Border.all(
          color: hadith.accent.withValues(alpha: isDark ? 0.28 : 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary.withValues(alpha: isDark ? 0.18 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote_rounded, color: hadith.accent, size: 27),
              const Spacer(),
              Flexible(
                child: Text(
                  hadith.source,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall.copyWith(
                    color: hadith.accent,
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            hadith.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleMedium.copyWith(
              color: titleColor,
              fontWeight: AppTheme.weightExtraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            hadith.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: text.bodyMedium.copyWith(color: bodyColor, height: 1.45),
          ),
        ],
      ),
    );
  }
}
