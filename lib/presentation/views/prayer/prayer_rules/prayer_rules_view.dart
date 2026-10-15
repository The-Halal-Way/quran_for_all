import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../presentation/widgets/prayer/prayer_rules/prayer_rules_content.dart';
import '../../../../presentation/widgets/prayer/shared/prayer_detail_scaffold.dart';

class PrayerRulesView extends StatelessWidget {
  const PrayerRulesView({super.key});

  @override
  Widget build(BuildContext context) => PrayerDetailScaffold(
    title: context.l10n.prayerRulesTitle,
    accent: MyColors.primaryLight,
    child: const PrayerRulesContent(),
  );
}
