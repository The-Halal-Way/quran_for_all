import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/when_you_have_a_need/need_amal.dart';

class NeedCategoryPicker extends StatelessWidget {
  const NeedCategoryPicker({
    super.key,
    required this.isBangla,
    required this.selected,
    required this.onSelected,
  });

  final bool isBangla;
  final NeedCategory? selected;
  final ValueChanged<NeedCategory?> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _chip(
          context,
          title: isBangla ? 'সব' : 'All',
          icon: Icons.apps_rounded,
          active: selected == null,
          onTap: () => onSelected(null),
        ),
        for (final category in NeedCategory.values) ...[
          const SizedBox(width: AppSpacing.sm),
          _chip(
            context,
            title: category.title.of(isBangla),
            icon: category.icon,
            active: selected == category,
            onTap: () => onSelected(category),
          ),
        ],
      ],
    ),
  );

  Widget _chip(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(title),
      avatar: Icon(
        icon,
        size: 17,
        color: active ? scheme.onTertiary : scheme.tertiary,
      ),
      selected: active,
      showCheckmark: false,
      selectedColor: scheme.tertiary,
      labelStyle: AppTheme.text(context).labelMedium.copyWith(
        color: active ? scheme.onTertiary : scheme.onSurface,
        fontWeight: AppTheme.weightBold,
      ),
      side: BorderSide(color: active ? scheme.tertiary : scheme.outlineVariant),
      onSelected: (_) => onTap(),
    );
  }
}
