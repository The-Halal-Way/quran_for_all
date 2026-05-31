import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';
import '../../../data/models/quran/quran_hub_models.dart';

class QuranHadithCard extends StatelessWidget {
  const QuranHadithCard({super.key, required this.hadith});

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
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : MyColors.divider.withValues(alpha: 0.78),
        ),
        boxShadow: [
          BoxShadow(
            color: hadith.accent.withValues(alpha: isDark ? 0.14 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: hadith.accent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppRadius.lg),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: hadith.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(
                            hadith.icon,
                            color: hadith.accent,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hadith.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: text.titleMedium.copyWith(
                                  color: titleColor,
                                  fontWeight: AppTheme.weightExtraBold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                hadith.source,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.labelSmall.copyWith(
                                  color: hadith.accent,
                                  fontWeight: AppTheme.weightBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      hadith.body,
                      style: text.bodyMedium.copyWith(
                        color: bodyColor,
                        height: 1.48,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
