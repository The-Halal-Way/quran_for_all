import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../data/models/sunnah_dua/sunnah_dua_models.dart';
import '../../../viewmodels/sunnah_dua_viewmodel.dart';
import 'sunnah_dua_filter_segment.dart';

class SunnahDuaFilterBar extends StatelessWidget {
  const SunnahDuaFilterBar({
    super.key,
    required this.viewModel,
    required this.selectedFilter,
  });

  final SunnahDuaViewModel viewModel;
  final SunnahDuaFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: isDark ? 0.66 : 0.9),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.24 : 0.18),
        ),
      ),
      child: Row(
        children: [
          for (final filter in SunnahDuaFilter.values)
            SunnahDuaFilterSegment(
              label: viewModel.filterLabel(context.l10n, filter),
              icon: viewModel.filterIcon(filter),
              color: _colorFor(filter),
              isSelected: filter == selectedFilter,
              onTap: () => viewModel.selectFilter(filter),
            ),
        ],
      ),
    );
  }

  Color _colorFor(SunnahDuaFilter filter) {
    return switch (filter) {
      SunnahDuaFilter.all => MyColors.primaryLight,
      SunnahDuaFilter.sunnah => MyColors.tertiary,
      SunnahDuaFilter.dua => MyColors.secondary,
      SunnahDuaFilter.dhikr => MyColors.secondaryLight,
    };
  }
}
