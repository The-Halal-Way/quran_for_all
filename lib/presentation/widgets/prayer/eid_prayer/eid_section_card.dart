import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';
import 'eid_entry_tile.dart';
import 'eid_guide_style.dart';

class EidSectionCard extends StatelessWidget {
  const EidSectionCard({
    super.key,
    required this.section,
    required this.index,
    required this.eid,
    required this.bangla,
  });

  final EidSection section;
  final int index;
  final EidKind eid;
  final bool bangla;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = EidGuideStyle.accent(eid);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: dark ? MyColors.darkCardFill : MyColors.cardFill,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: dark ? 0.08 : 0.055),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: AppTheme.text(context).labelLarge.copyWith(
                    color: accent,
                    fontWeight: AppTheme.weightExtraBold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    section.title.inLanguage(bangla),
                    style: AppTheme.text(context).titleLarge.copyWith(
                      fontWeight: AppTheme.weightExtraBold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (section.intro != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              section.intro!.inLanguage(bangla),
              style: AppTheme.text(context).bodyMedium.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.58,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < section.entries.length; i++) ...[
            EidEntryTile(
              entry: section.entries[i],
              accent: accent,
              bangla: bangla,
            ),
            if (i < section.entries.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
