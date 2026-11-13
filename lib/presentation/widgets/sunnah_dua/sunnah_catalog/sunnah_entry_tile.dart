import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/sunnah/sunnah_catalog.dart';
import 'sunnah_catalog_visuals.dart';

class SunnahEntryTile extends StatelessWidget {
  const SunnahEntryTile({
    super.key,
    required this.entry,
    required this.language,
    required this.typeLabel,
    required this.onTap,
  });
  final SunnahEntry entry;
  final String language, typeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = SunnahCatalogVisuals.color(
      entry.categoryIds.firstOrNull ?? '',
    );
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Color.alphaBlend(color.withValues(alpha: .035), scheme.surface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .65)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: .12),
                foregroundColor: color,
                child: Icon(
                  SunnahCatalogVisuals.icon(
                    entry.categoryIds.firstOrNull ?? '',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title.inLanguage(language),
                      style: AppTheme.text(
                        context,
                      ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      entry.practice.inLanguage(language),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.text(
                        context,
                      ).bodySmall.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      typeLabel,
                      style: AppTheme.text(context).labelSmall.copyWith(
                        color: color,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_outward_rounded, size: 19),
            ],
          ),
        ),
      ),
    );
  }
}
