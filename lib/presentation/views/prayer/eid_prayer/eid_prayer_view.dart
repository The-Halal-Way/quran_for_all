import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/prayer/eid_prayer/eid_prayer_body.dart';
import '../../../widgets/prayer/prayer_language_menu_action.dart';

class EidPrayerView extends StatelessWidget {
  const EidPrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final bangla = Localizations.localeOf(context).languageCode == 'bn';
    return Scaffold(
      appBar: AppBar(
        title: Text(bangla ? 'ঈদের নামাজের গাইড' : 'Eid Prayer Guide'),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(CupertinoIcons.chevron_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          if (context.watch<SettingsViewModel?>() != null)
            const PrayerLanguageMenuAction(),
        ],
      ),
      body: const EidPrayerBody(),
    );
  }
}
