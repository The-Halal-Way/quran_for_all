import 'dart:async';

import 'package:flutter/material.dart';
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
          leading: const Icon(Icons.tune_rounded),
          title: Text(context.readQuranText('Reading options')),
          subtitle: Text(
            context.readQuranText('Pronunciation and translation visibility'),
          ),
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
                    context.readQuranText('Reading mode'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<ReadingViewMode>(
                      showSelectedIcon: false,
                      style: SegmentedButton.styleFrom(
                        backgroundColor: unselectedBg,
                        foregroundColor: colorScheme.onSurface,
                        selectedBackgroundColor: selectedBg,
                        selectedForegroundColor: colorScheme.primary,
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.22),
                        ),
                      ),
                      segments: <ButtonSegment<ReadingViewMode>>[
                        ButtonSegment<ReadingViewMode>(
                          value: ReadingViewMode.detailsView,
                          icon: const Icon(Icons.view_agenda_rounded),
                          label: Text(context.readQuranText('Details')),
                        ),
                        ButtonSegment<ReadingViewMode>(
                          value: ReadingViewMode.regularView,
                          icon: const Icon(Icons.wrap_text_rounded),
                          label: Text(context.readQuranText('Regular')),
                        ),
                      ],
                      selected: <ReadingViewMode>{settings.readingViewMode},
                      onSelectionChanged: (selection) {
                        final selectedMode = selection.first;
                        unawaited(
                          settingsViewModel.setReadingViewMode(selectedMode),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SwitchListTile(
              dense: true,
              activeThumbColor: colorScheme.primary,
              activeTrackColor: colorScheme.primary.withValues(alpha: 0.35),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              secondary: const Icon(Icons.record_voice_over_rounded),
              value: settings.showPronunciation,
              onChanged: (value) {
                unawaited(settingsViewModel.setShowPronunciation(value));
              },
              title: Text(context.readQuranText('Show pronunciation')),
            ),
            const Divider(height: 1),
            SwitchListTile(
              dense: true,
              activeThumbColor: colorScheme.primary,
              activeTrackColor: colorScheme.primary.withValues(alpha: 0.35),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              secondary: const Icon(Icons.translate_rounded),
              value: settings.showTranslation,
              onChanged: (value) {
                unawaited(settingsViewModel.setShowTranslation(value));
              },
              title: Text(context.readQuranText('Show translations')),
            ),
          ],
        ),
      ),
    );
  }
}
