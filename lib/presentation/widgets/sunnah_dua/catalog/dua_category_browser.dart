import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import '../../common/app_premium_section_title.dart';
import 'dua_catalog_visuals.dart';

class DuaCategoryBrowser extends StatelessWidget {
  const DuaCategoryBrowser({
    super.key,
    required this.catalog,
    required this.onSelected,
  });
  final DuaCatalog catalog;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CategoryCard(
          category: catalog.category(catalog.allId),
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
                    if (id != catalog.allId)
                      SizedBox(
                        width: width,
                        child: _CategoryCard(
                          category: catalog.category(id),
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
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});
  final DuaCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = DuaCatalogVisuals.color(category.id);
    final text = AppTheme.text(context);
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: Color.alphaBlend(color.withValues(alpha: .07), scheme.surface),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: color.withValues(alpha: .2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(DuaCatalogVisuals.icon(category.id), color: color, size: 26),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title.inLanguage(context.l10n.localeName),
                      style: text.labelLarge.copyWith(
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      context.l10n.duaEntryCount(
                        duaNumber(context, category.entryIds.length),
                      ),
                      style: text.labelSmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
