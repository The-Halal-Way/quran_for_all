import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../models/daily_reminder_presenter.dart';

class DailyReminderReaderHeader extends StatelessWidget {
  const DailyReminderReaderHeader({
    super.key,
    required this.item,
    required this.edition,
    required this.dateLabel,
    required this.l10n,
  });

  final DailyReminderItem item;
  final DailyReminderEdition edition;
  final String dateLabel;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = dailyReminderKindColor(context, item.kind);
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      header: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(colors.surface, color, dark ? 0.2 : 0.08)!,
              colors.surface,
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: dark ? 0.08 : 0.12),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              end: -44,
              top: -52,
              child: IgnorePointer(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withValues(alpha: 0.08),
                      width: 24,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        dailyReminderKindIcon(item.kind),
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        dailyReminderKindLabel(l10n, item.kind),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  edition.title,
                  style: AppTheme.sora(
                    context,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    height: 1.18,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 15,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
