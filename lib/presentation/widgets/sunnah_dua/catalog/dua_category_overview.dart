import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';

class DuaCategoryOverview extends StatelessWidget {
  const DuaCategoryOverview({
    super.key,
    required this.category,
    this.description,
  });
  final DuaCategory category;
  final String? description;
  @override
  Widget build(BuildContext context) {
    final accent = DuaCatalogVisuals.color(category.id);
    final text = AppTheme.text(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                DuaCatalogVisuals.icon(category.id),
                color: accent,
                size: 25,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                category.title.inLanguage(context.l10n.localeName),
                style: text.headlineMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          description ??
              category.description.inLanguage(context.l10n.localeName),
          style: text.bodyMedium.copyWith(
            height: 1.6,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
