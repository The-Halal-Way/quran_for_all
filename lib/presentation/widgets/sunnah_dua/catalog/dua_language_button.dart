import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../common/app_language_action_button.dart';

class DuaLanguageButton extends StatelessWidget {
  const DuaLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    return AppLanguageActionButton(
      current: settings.settings.language,
      onSelected: settings.setLanguage,
      tooltip: context.l10n.settingsLanguagePanelTitle,
    );
  }
}
