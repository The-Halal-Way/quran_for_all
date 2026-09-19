import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_language_action_button.dart';

// MARK: Prayer - Language Menu Action
class PrayerLanguageMenuAction extends StatelessWidget {
  const PrayerLanguageMenuAction({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    return AppLanguageActionButton(
      tooltip: context.l10n.prayerViewLanguageTooltip,
      current: settingsVm.settings.language,
      iconColor: iconColor,
      onSelected: settingsVm.setLanguage,
    );
  }
}
