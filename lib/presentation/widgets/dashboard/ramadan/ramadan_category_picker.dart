import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';

class RamadanCategoryPicker extends StatelessWidget {
  const RamadanCategoryPicker({
    super.key,
    required this.isBangla,
    required this.selectedSection,
    required this.onSelected,
  });

  final bool isBangla;
  final RamadanSection? selectedSection;
  final ValueChanged<RamadanSection?> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _chip(
          context,
          label: ramadanLabel(isBangla, 'Overview', 'পরিচিতি'),
          icon: Icons.grid_view_rounded,
          selected: selectedSection == null,
          onTap: () => onSelected(null),
        ),
        for (final section in RamadanSection.values) ...[
          const SizedBox(width: AppSpacing.sm),
          _chip(
            context,
            label: section.title.of(isBangla),
            icon: section.icon,
            selected: selectedSection == section,
            onTap: () => onSelected(section),
          ),
        ],
      ],
    ),
  );

  Widget _chip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(
        icon,
        size: 17,
        color: selected ? scheme.onTertiary : scheme.tertiary,
      ),
      selected: selected,
      showCheckmark: false,
      selectedColor: scheme.tertiary,
      labelStyle: AppTheme.text(context).labelMedium.copyWith(
        color: selected ? scheme.onTertiary : scheme.onSurface,
        fontWeight: AppTheme.weightBold,
      ),
      side: BorderSide(
        color: selected ? scheme.tertiary : scheme.outlineVariant,
      ),
      onSelected: (_) => onTap(),
    );
  }
}
