import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/sunnah_dua/sunnah_dua_models.dart';
import 'package:quran_for_all/presentation/viewmodels/sunnah_dua_viewmodel.dart';

class SunnahDuaFilterBar extends StatelessWidget {
  const SunnahDuaFilterBar({
    super.key,
    required this.viewModel,
    required this.selectedFilter,
    required this.countBuilder,
  });

  final SunnahDuaViewModel viewModel;
  final SunnahDuaFilter selectedFilter;
  final int Function(SunnahDuaFilter filter) countBuilder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: isDark ? 0.62 : 0.86),
        borderRadius: BorderRadius.circular(AppRadius.base),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.28 : 0.22),
        ),
      ),
      child: Row(
        children: [
          for (final filter in SunnahDuaFilter.values)
            Expanded(
              child: _FilterSegment(
                filter: filter,
                label: viewModel.filterLabel(context.l10n, filter),
                icon: viewModel.filterIcon(filter),
                count: countBuilder(filter),
                isSelected: filter == selectedFilter,
                onTap: () => viewModel.selectFilter(filter),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterSegment extends StatelessWidget {
  const _FilterSegment({
    required this.filter,
    required this.label,
    required this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final SunnahDuaFilter filter;
  final String label;
  final IconData icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = _activeColor(colorScheme);

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.small),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: isSelected
                ? Border.all(color: activeColor.withValues(alpha: 0.44))
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: isSelected
                        ? activeColor
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: text.labelSmall.copyWith(
                          color: isSelected
                              ? activeColor
                              : colorScheme.onSurface.withValues(alpha: 0.62),
                          fontWeight: isSelected
                              ? AppTheme.weightBlack
                              : AppTheme.weightBold,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '$count',
                style: text.labelSmall.copyWith(
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.82)
                      : colorScheme.onSurface.withValues(alpha: 0.38),
                  fontWeight: AppTheme.weightBold,
                  letterSpacing: 0,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _activeColor(ColorScheme colorScheme) {
    return switch (filter) {
      SunnahDuaFilter.all => colorScheme.primary,
      SunnahDuaFilter.sunnah => colorScheme.tertiary,
      SunnahDuaFilter.dua => colorScheme.secondary,
      SunnahDuaFilter.dhikr => const Color(0xFFFF4081),
    };
  }
}
