import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';

/// Card with a segmented theme mode selector (System / Light / Dark).
class SettingsThemeCard extends StatelessWidget {
  const SettingsThemeCard({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        children: [
          _SectionTitle(
            icon: Icons.palette_outlined,
            title: context.readQuranText('Appearance'),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.readQuranText('Theme'),
                  style: AppTheme.text(
                    context,
                  ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        icon: const Icon(
                          Icons.brightness_auto_rounded,
                          size: 18,
                        ),
                        label: Text(context.readQuranText('System')),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        icon: const Icon(Icons.light_mode_rounded, size: 18),
                        label: Text(context.readQuranText('Light')),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        icon: const Icon(Icons.dark_mode_rounded, size: 18),
                        label: Text(context.readQuranText('Dark')),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (selected) {
                      onThemeModeChanged(selected.first);
                    },
                    style: SegmentedButton.styleFrom(
                      selectedForegroundColor: colorScheme.onPrimary,
                      selectedBackgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = AppResponsive.of(context);
    final boxSize = responsive.pick(mobile: 34, tablet: 30, desktop: 34);
    final iconSize = responsive.pick(mobile: 18, tablet: 16.5, desktop: 18.5);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg - 2,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.sm + 2),
            ),
            child: Icon(icon, color: colorScheme.primary, size: iconSize),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Text(
            title,
            style: AppTheme.text(
              context,
            ).titleMedium.copyWith(fontWeight: AppTheme.weightBold),
          ),
        ],
      ),
    );
  }
}
