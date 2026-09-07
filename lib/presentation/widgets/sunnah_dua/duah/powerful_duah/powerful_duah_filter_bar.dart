import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import 'powerful_duah_data.dart';

class PowerfulDuahFilterBar extends StatelessWidget {
  const PowerfulDuahFilterBar({
    super.key,
    required this.selected,
    required this.featuredOnly,
    required this.onSituationChanged,
    required this.onFeaturedToggled,
  });

  final DuahSituation selected;
  final bool featuredOnly;
  final ValueChanged<DuahSituation> onSituationChanged;
  final VoidCallback onFeaturedToggled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterSegment(
            label: context.l10n.duahPowerfulBestFive,
            icon: Icons.star_rounded,
            accent: const Color(0xFFD50057),
            selected: featuredOnly,
            onTap: onFeaturedToggled,
          ),
          const SizedBox(width: AppSpacing.sm),
          for (final situation in DuahSituation.values) ...[
            _FilterSegment(
              label: situation.label(context),
              icon: situation.icon,
              accent: situation.color,
              selected: situation == selected,
              onTap: () => onSituationChanged(situation),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _FilterSegment extends StatelessWidget {
  const _FilterSegment({
    required this.label,
    required this.icon,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: selected
                  ? accent.withValues(alpha: 0.13)
                  : Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: selected
                    ? accent.withValues(alpha: 0.40)
                    : Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: accent),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTheme.text(context).labelSmall.copyWith(
                    color: selected
                        ? accent
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.62),
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
