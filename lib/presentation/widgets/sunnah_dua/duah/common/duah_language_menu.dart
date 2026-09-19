import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../viewmodels/settings_viewmodel.dart';
import '../../../common/app_language_action_button.dart';

class DuahLanguageMenu extends StatelessWidget {
  const DuahLanguageMenu({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    return AppLanguageActionButton(
      tooltip: context.l10n.duahLanguageToggleTooltip,
      current: settings.settings.language,
      onSelected: settings.setLanguage,
      iconColor: accent,
      iconSize: 20,
    );
  }
}
