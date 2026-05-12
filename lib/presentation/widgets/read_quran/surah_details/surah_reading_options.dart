import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

class SurahReadingOptions extends StatelessWidget {
  const SurahReadingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final settingsViewModel = context.read<SettingsViewModel>();
    final settings = context.watch<SettingsViewModel>().settings;

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
            SwitchListTile(
              dense: true,
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
