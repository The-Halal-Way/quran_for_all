import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../../../l10n/app_localizations.dart';

class DailyReminderArabicPassageCard extends StatelessWidget {
  const DailyReminderArabicPassageCard({
    super.key,
    required this.passage,
    required this.l10n,
  });

  final DailyReminderPassage passage;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: l10n.dailyRemindersOriginalArabic,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primary.withValues(alpha: 0.12),
              scheme.tertiary.withValues(alpha: 0.07),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  size: 18,
                  color: scheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.dailyRemindersOriginalArabic,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (passage.isExcerpt) ...[
                  const Spacer(),
                  Text(
                    l10n.dailyRemindersExcerpt,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Directionality(
              textDirection: TextDirection.rtl,
              child: SelectableText(
                passage.text,
                textAlign: TextAlign.center,
                style: AppTheme.amiri(
                  context,
                  fontSize: 29,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface,
                  height: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
