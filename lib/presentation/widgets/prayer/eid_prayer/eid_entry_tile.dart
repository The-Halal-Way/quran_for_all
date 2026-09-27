import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';
import 'eid_arabic_panel.dart';

class EidEntryTile extends StatelessWidget {
  const EidEntryTile({
    super.key,
    required this.entry,
    required this.accent,
    required this.bangla,
  });

  final EidEntry entry;
  final Color accent;
  final bool bangla;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: dark
            ? colors.surfaceContainerLow
            : accent.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.badge != null) ...[
            Text(
              entry.badge!.inLanguage(bangla),
              style: AppTheme.text(context).labelSmall.copyWith(
                color: accent,
                fontWeight: AppTheme.weightExtraBold,
                letterSpacing: bangla ? 0 : 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            entry.title.inLanguage(bangla),
            style: AppTheme.text(context).titleMedium.copyWith(
              color: colors.onSurface,
              fontWeight: AppTheme.weightBold,
              height: 1.3,
            ),
          ),
          if (entry.arabic != null) ...[
            const SizedBox(height: AppSpacing.md),
            EidArabicPanel(
              arabic: entry.arabic!,
              pronunciation: entry.pronunciation!,
              meaning: entry.meaning!,
              bangla: bangla,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            entry.body.inLanguage(bangla),
            style: AppTheme.text(
              context,
            ).bodyMedium.copyWith(color: colors.onSurfaceVariant, height: 1.55),
          ),
          if (entry.reference != null) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.menu_book_rounded, color: accent, size: 15),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    entry.reference!,
                    style: AppTheme.text(context).labelSmall.copyWith(
                      color: accent,
                      fontWeight: AppTheme.weightSemiBold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
