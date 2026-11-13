import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/sunnah/sunnah_catalog.dart';
import '../../common/app_premium_section_title.dart';
import 'sunnah_catalog_visuals.dart';

class SunnahCategoryBrowser extends StatelessWidget {
  const SunnahCategoryBrowser({
    super.key,
    required this.catalog,
    required this.language,
    required this.countLabel,
    required this.onSelected,
  });

  final SunnahCatalog catalog;
  final String language;
  final String Function(int count) countLabel;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _CategoryCard(
        category: catalog.category(catalog.allId),
        language: language,
        countLabel: countLabel,
        onTap: () => onSelected(catalog.allId),
      ),
      for (final group in catalog.groups) ...[
        const SizedBox(height: AppSpacing.xl),
        AppPremiumSectionTitle(title: group.title.inLanguage(language)),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth < 340
                ? 1
                : constraints.maxWidth < 700
                ? 2
                : 3;
            final width =
                (constraints.maxWidth - (columns - 1) * AppSpacing.sm) /
                columns;
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final id in group.categoryIds)
                  SizedBox(
                    width: width,
                    child: _CategoryCard(
                      category: catalog.category(id),
                      language: language,
                      countLabel: countLabel,
                      onTap: () => onSelected(id),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    ],
  );
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.language,
    required this.countLabel,
    required this.onTap,
  });
  final SunnahCategory category;
  final String language;
  final String Function(int count) countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = SunnahCatalogVisuals.color(category.id);
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: Color.alphaBlend(color.withValues(alpha: .07), scheme.surface),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: color.withValues(alpha: .22)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Icon(
                    SunnahCatalogVisuals.icon(category.id),
                    color: color,
                    size: 23,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title.inLanguage(language),
                      style: AppTheme.text(
                        context,
                      ).labelLarge.copyWith(fontWeight: AppTheme.weightBold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      countLabel(category.entryIds.length),
                      style: AppTheme.text(
                        context,
                      ).labelSmall.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
