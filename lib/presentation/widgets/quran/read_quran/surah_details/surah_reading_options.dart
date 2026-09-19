import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

class SurahReadingOptions extends StatelessWidget {
  const SurahReadingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final settingsViewModel = context.read<SettingsViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedBg = colorScheme.primary.withValues(alpha: 0.14);
    final unselectedBg = colorScheme.surface.withValues(alpha: 0.8);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.padding,
        0,
        responsive.padding,
        AppSpacing.sm,
      ),
      child: Card(
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 0,
          ),
          childrenPadding: EdgeInsets.zero,
          leading: const Icon(CupertinoIcons.slider_horizontal_3),
          title: Text(context.l10n.readQuranReadingOptionsTitle),
          subtitle: Text(context.l10n.readQuranReadingOptionsSubtitle),
          children: [
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.readQuranReadingModeLabel,
                    style: AppTheme.text(context).labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: CupertinoSlidingSegmentedControl<ReadingViewMode>(
                      groupValue: settings.readingViewMode,
                      backgroundColor: unselectedBg,
                      thumbColor: selectedBg,
                      children: {
                        ReadingViewMode.detailsView: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.list_bullet, size: 17),
                              const SizedBox(width: AppSpacing.sm),
                              Text(context.l10n.readQuranDetailsMode),
                            ],
                          ),
                        ),
                        ReadingViewMode.regularView: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.textformat, size: 17),
                              const SizedBox(width: AppSpacing.sm),
                              Text(context.l10n.readQuranRegularMode),
                            ],
                          ),
                        ),
                      },
                      onValueChanged: (selectedMode) {
                        if (selectedMode != null) {
                          unawaited(
                            settingsViewModel.setReadingViewMode(selectedMode),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SwitchListTile.adaptive(
              dense: true,
              activeThumbColor: colorScheme.primary,
              activeTrackColor: colorScheme.primary.withValues(alpha: 0.35),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              secondary: const Icon(CupertinoIcons.waveform),
              value: settings.showPronunciation,
              onChanged: (value) {
                unawaited(settingsViewModel.setShowPronunciation(value));
              },
              title: Text(context.l10n.settingsShowPronunciationTitle),
            ),
            const Divider(height: 1),
            SwitchListTile.adaptive(
              dense: true,
              activeThumbColor: colorScheme.primary,
              activeTrackColor: colorScheme.primary.withValues(alpha: 0.35),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              secondary: const Icon(CupertinoIcons.globe),
              value: settings.showTranslation,
              onChanged: (value) {
                unawaited(settingsViewModel.setShowTranslation(value));
              },
              title: Text(context.l10n.settingsShowTranslationsTitle),
            ),
          ],
        ),
      ),
    );
  }
}
