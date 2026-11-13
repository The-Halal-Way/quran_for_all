import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';

class DuaEntryTile extends StatelessWidget {
  const DuaEntryTile({
    super.key,
    required this.entry,
    required this.onTap,
    this.categoryId,
  });
  final DuaEntry entry;
  final String? categoryId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    final accent = DuaCatalogVisuals.color(
      categoryId ?? entry.categoryIds.firstOrNull ?? 'all',
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .6)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.titleFor(language, categoryId),
                        style: text.titleSmall.copyWith(
                          fontWeight: AppTheme.weightBold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      entry.isDefault
                          ? Icons.arrow_outward_rounded
                          : Icons.info_outline_rounded,
                      color: accent,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    entry.arabic,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.amiri(context, fontSize: 24, color: accent),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry.meaning.inLanguage(language),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
