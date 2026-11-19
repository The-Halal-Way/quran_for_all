import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/dua/dua_catalog.dart';
import 'dua_occasion_label.dart';

class DuaOccasionSelector extends StatelessWidget {
  const DuaOccasionSelector({
    super.key,
    required this.entry,
    required this.selected,
    required this.onSelected,
  });
  final DuaEntry entry;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        for (final occasion in entry.practice.occasions)
          ChoiceChip(
            label: Text(
              duaOccasionLabel(context, entry, occasion).isNotEmpty
                  ? duaOccasionLabel(context, entry, occasion)
                  : entry.title.inLanguage(context.l10n.localeName),
            ),
            selected: occasion == selected,
            onSelected: (_) => onSelected(occasion),
          ),
      ],
    ),
  );
}
