import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_shadows.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

class NintyNineNamesInsightCard extends StatelessWidget {
  const NintyNineNamesInsightCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final cardBg = isDark ? MyColors.darkCardFill : MyColors.cardFill;
    final borderC = isDark ? MyColors.darkDivider : MyColors.divider;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderC.withValues(alpha: isDark ? 0.8 : 1)),
        boxShadow: AppShadows.card(tint: accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.95),
                      MyColors.primaryLight.withValues(alpha: 0.92),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  boxShadow: AppShadows.glow(accent, intensity: 0.16),
                ),
                child: Icon(icon, size: 19, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: text.titleMedium.copyWith(
                    fontWeight: AppTheme.weightExtraBold,
                    color: isDark
                        ? MyColors.darkTextPrimary
                        : MyColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: text.bodyMedium.copyWith(
              height: 1.62,
              color: isDark
                  ? MyColors.darkTextSecondary
                  : MyColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
