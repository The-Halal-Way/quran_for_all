import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

import '../shared/prayer_card_shell.dart';

class PrayerStateCard extends StatelessWidget {
  const PrayerStateCard.loading({super.key})
    : title = '',
      body = '',
      icon = Icons.hourglass_empty_rounded,
      isLoading = true,
      onRetry = null;

  const PrayerStateCard.error({
    super.key,
    required this.title,
    required this.body,
    required this.onRetry,
  }) : icon = Icons.location_off_rounded,
       isLoading = false;

  final String title;
  final String body;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final subColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final text = AppTheme.text(context);

    return PrayerCardShell(
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: CircularProgressIndicator(
                  color: MyColors.secondary,
                  strokeWidth: 2.4,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: MyColors.secondary, size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: text.prayerCardTitle.copyWith(
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            body,
                            style: text.bodySmall.copyWith(
                              color: subColor,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(CupertinoIcons.refresh, size: 17),
                    label: Text(context.l10n.dashboardRetry),
                  ),
                ),
              ],
            ),
    );
  }
}
