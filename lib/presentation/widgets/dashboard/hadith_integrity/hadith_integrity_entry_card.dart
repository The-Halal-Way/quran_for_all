import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/hadith_integrity/hadith_integrity_library.dart';
import 'hadith_integrity_item_sheet.dart';

class HadithIntegrityEntryCard extends StatelessWidget {
  const HadithIntegrityEntryCard({
    super.key,
    required this.collection,
    required this.item,
    required this.index,
    required this.accent,
  });

  final HadithIntegrityCollection collection;
  final HadithIntegrityItem item;
  final int index;
  final Color accent;

  String _title(BuildContext context) {
    final locale = Localizations.localeOf(context);
    for (final field in const ['title', 'text', 'misconception', 'content']) {
      final value = item.localized(field, locale);
      if (value.isNotEmpty) return value;
    }
    return context.l10n.hadithIntegrityNoItems;
  }

  String _summary(BuildContext context) {
    final locale = Localizations.localeOf(context);
    for (final field in const [
      'status',
      'explanation',
      'correction',
      'lesson',
      'action',
      'user_action',
    ]) {
      final value = item.localized(field, locale);
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final summary = _summary(context);
    return Semantics(
      button: true,
      label: _title(context),
      child: Material(
        color: scheme.surface.withValues(alpha: .7),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .7)),
        ),
        child: InkWell(
          onTap: () => showHadithIntegrityItemSheet(context, collection, item),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTheme.text(context).labelLarge.copyWith(
                          color: accent,
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title(context),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.text(
                          context,
                        ).bodyMedium.copyWith(fontWeight: AppTheme.weightBold),
                      ),
                      if (summary.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text(context).bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.arrow_forward_ios_rounded, size: 15, color: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
