import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/dua/dua_catalog.dart';

class DuaEntryPreview extends StatelessWidget {
  const DuaEntryPreview({super.key, required this.entry, required this.accent});
  final DuaEntry entry;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    final purpose = entry.insights.purpose.isEmpty
        ? entry.meaning.inLanguage(language)
        : entry.insights.purpose.inLanguage(language);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          purpose,
          key: ValueKey('dua-preview-purpose-${entry.id}'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.bodyMedium.copyWith(
            height: 1.55,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          entry.arabic,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.amiri(
            context,
            fontSize: 24,
            height: 1.65,
            color: accent,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  entry.isDefault
                      ? Icons.auto_stories_outlined
                      : Icons.info_outline_rounded,
                  color: accent,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    entry.isDefault
                        ? context.l10n.duaReadReflect
                        : context.l10n.duaSourceNotes,
                    style: text.labelSmall.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            if (entry.isDefault && entry.insights.reportedVirtues.isNotEmpty)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Text(
                    context.l10n.duaReportedVirtueLabel,
                    style: text.labelSmall.copyWith(color: accent),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
