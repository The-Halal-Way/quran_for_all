import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/prayer/prayer_detail_models.dart';

class DashboardForbiddenTimeRow extends StatelessWidget {
  const DashboardForbiddenTimeRow({
    super.key,
    required this.item,
    required this.onTap,
  });

  final PrayerForbiddenTimeItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? MyColors.secondaryLight : MyColors.secondary;

    return Semantics(
      button: true,
      onTap: onTap,
      label:
          '${context.l10n.prayerForbiddenTimesTitle}. '
          '${item.title}. ${item.timeLabel}',
      excludeSemantics: true,
      child: Material(
        color: accent.withValues(alpha: isDark ? 0.10 : 0.055),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: isDark ? 0.18 : 0.11),
                  ),
                  child: Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    size: 17,
                    color: accent,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: AppTheme.text(context).bodyMedium.copyWith(
                              fontWeight: AppTheme.weightBold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(
                                alpha: isDark ? 0.18 : 0.10,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Text(
                              context.l10n.prayerForbiddenPauseLabel,
                              style: AppTheme.text(context).labelSmall.copyWith(
                                color: accent,
                                fontWeight: AppTheme.weightBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.timeLabel,
                        style: AppTheme.text(context).bodySmall.copyWith(
                          color: accent,
                          fontWeight: AppTheme.weightSemiBold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  CupertinoIcons.chevron_forward,
                  size: 14,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
