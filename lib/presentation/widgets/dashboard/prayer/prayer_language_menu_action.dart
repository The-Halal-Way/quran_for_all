import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

// MARK: Prayer - Language Menu Action
class PrayerLanguageMenuAction extends StatelessWidget {
  const PrayerLanguageMenuAction({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    final current = settingsVm.settings.language;
    final text = AppTheme.text(context);

    return PopupMenuButton<AppLanguage>(
      tooltip: context.l10n.prayerViewLanguageTooltip,
      icon: Icon(Icons.language_rounded, color: iconColor),
      onSelected: settingsVm.setLanguage,
      itemBuilder: (context) => [
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.english,
          child: Text(
            context.appLanguageLabel(AppLanguage.english),
            style: current == AppLanguage.english
                ? text.labelMedium
                : text.bodyMedium,
          ),
        ),
        PopupMenuItem<AppLanguage>(
          value: AppLanguage.bangla,
          child: Text(
            context.appLanguageLabel(AppLanguage.bangla),
            style: current == AppLanguage.bangla
                ? text.labelMedium
                : text.bodyMedium,
          ),
        ),
      ],
    );
  }
}
