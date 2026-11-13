import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';

class DuaEntryHeading extends StatelessWidget {
  const DuaEntryHeading({
    super.key,
    required this.catalog,
    required this.entry,
    this.categoryId,
  });
  final DuaCatalog catalog;
  final DuaEntry entry;
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    final language = context.l10n.localeName;
    final text = AppTheme.text(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.titleFor(language, categoryId),
            style: text.headlineMedium.copyWith(
              fontWeight: AppTheme.weightExtraBold,
              height: 1.25,
            ),
          ),
          if (!DuaText(entry.context['subtitle']).isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              DuaText(entry.context['subtitle']).inLanguage(language),
              style: text.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final id in entry.categoryIds)
                Chip(
                  avatar: Icon(DuaCatalogVisuals.icon(id), size: 15),
                  label: Text(catalog.category(id).title.inLanguage(language)),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          if (!entry.isDefault || entry.type == 'sunnah_practice') ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                entry.type == 'sunnah_practice'
                    ? context.l10n.duaPracticeEntry
                    : context.l10n.duaReferenceEntry,
                style: text.bodySmall.copyWith(height: 1.5),
              ),
            ),
          ],
          if (!entry.practice.when.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              entry.practice.when.inLanguage(language),
              style: text.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
