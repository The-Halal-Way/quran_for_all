import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../viewmodels/dua/dua_library_viewmodel.dart';
import 'dua_catalog_visuals.dart';

class DuaLibraryFilters extends StatelessWidget {
  const DuaLibraryFilters({super.key, required this.model});
  final DuaLibraryViewModel model;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final category in model.catalog!.categories) ...[
              ChoiceChip(
                label: Text(category.title.inLanguage(context.l10n.localeName)),
                selected: category.id == model.category.id,
                onSelected: (_) =>
                    model.selectCategory(category.id, clearSearch: false),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      ),
      if (model.category.referenceIds.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(
                context.l10n.duaEntryCount(
                  duaNumber(context, model.mainMatchCount),
                ),
              ),
              selected: !model.referenceOnly,
              onSelected: (_) => model.showReferences(false),
            ),
            ChoiceChip(
              label: Text(
                '${context.l10n.duaSourceNotes} · ${duaNumber(context, model.referenceMatchCount)}',
              ),
              selected: model.referenceOnly,
              onSelected: (_) => model.showReferences(true),
            ),
          ],
        ),
      ],
    ],
  );
}
