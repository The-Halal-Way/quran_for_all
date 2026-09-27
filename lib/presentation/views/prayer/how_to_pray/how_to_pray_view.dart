import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../viewmodels/prayer/prayer_movement_guide_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/prayer/how_to_pray/how_to_pray_body.dart';
import '../../../widgets/prayer/prayer_language_menu_action.dart';

class HowToPrayView extends StatelessWidget {
  const HowToPrayView({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => PrayerMovementGuideViewModel(),
    child: Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.prayerMovementsTitle),
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
      body: const HowToPrayBody(),
    ),
  );
}
