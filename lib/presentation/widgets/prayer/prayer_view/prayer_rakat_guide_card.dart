import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';
import '../prayer_rakat_guide/prayer_rakat_guide_sheet.dart';

class PrayerRakatGuideCard extends StatelessWidget {
  const PrayerRakatGuideCard({
    super.key,
    required this.items,
    required this.focusPrayer,
  });

  final List<PrayerRakatPlan> items;
  final PrayerKey focusPrayer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final focused =
        items.where((item) => item.prayer == focusPrayer).firstOrNull ??
        items.firstOrNull;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.secondary.withValues(alpha: 0.1),
              colors.secondary.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: colors.secondary.withValues(alpha: 0.22)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: InkWell(
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) =>
                PrayerRakatGuideSheet(items: items, focusPrayer: focusPrayer),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_list_numbered_rounded,
                      color: colors.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.prayerRakatGuideTitle,
                        style: text.titleMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: colors.secondary,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.prayerRakatGuideSubtitle,
                  style: text.bodySmall.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                if (focused != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      '${focused.name} • ${l10n.prayerRakatTotalLabel(focused.totalRakats)}',
                      style: text.labelMedium.copyWith(
                        color: colors.secondary,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
