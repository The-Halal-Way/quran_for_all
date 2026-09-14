import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';

import 'prayer_rakat_plan_tile.dart';

class PrayerRakatGuideSheet extends StatelessWidget {
  const PrayerRakatGuideSheet({
    super.key,
    required this.items,
    required this.focusPrayer,
  });

  final List<PrayerRakatPlan> items;
  final PrayerKey focusPrayer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final textColor = isDark ? MyColors.darkTextPrimary : MyColors.textPrimary;
    final hintColor = isDark
        ? MyColors.darkTextSecondary
        : MyColors.textSecondary;
    final surface = isDark ? MyColors.darkCardFill : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, controller) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: hintColor.withValues(alpha: 0.26),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.prayerRakatGuideTitle,
                            style: text.hadithTitle.copyWith(
                              color: textColor,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            context.l10n.prayerRakatGuideSubtitle,
                            style: text.bodySmall.copyWith(
                              color: hintColor,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: hintColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                // MARK: Prayer - Rakat Detail List
                child: ListView.separated(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return PrayerRakatPlanTile(
                      item: item,
                      isFocus: item.prayer == focusPrayer,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
