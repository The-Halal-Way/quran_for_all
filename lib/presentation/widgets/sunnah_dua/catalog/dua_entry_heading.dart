import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_catalog_visuals.dart';
import 'dua_occasion_label.dart';

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
    final primaryCategory = categoryId != null && categoryId != catalog.allId
        ? categoryId
        : entry.categoryIds.firstOrNull;
    final when = !entry.practice.when.isEmpty
        ? entry.practice.when.inLanguage(language)
        : entry.hasOccasionSelector
        ? ''
        : entry.practice.occasions
              .map((occasion) => duaOccasionLabel(context, entry, occasion))
              .where((label) => label.isNotEmpty)
              .join(' · ');
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
              if (primaryCategory case final id?)
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
          if (when.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              when,
              style: text.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
