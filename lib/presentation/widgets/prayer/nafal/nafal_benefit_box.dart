import 'package:flutter/material.dart';

import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class NafalBenefitBox extends StatelessWidget {
  const NafalBenefitBox({
    super.key,
    required this.body,
    required this.accent,
    required this.isDark,
  });

  final String body;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final bodyColor = isDark ? Colors.white : MyColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite_rounded, color: accent, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: text.bodySmall.copyWith(color: bodyColor, height: 1.42),
                children: [
                  TextSpan(
                    text: '${context.l10n.prayerNafalBenefitLabel}: ',
                    style: TextStyle(
                      color: accent,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                  TextSpan(text: body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
