import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../presentation/widgets/prayer/shared/prayer_detail_scaffold.dart';
import '../../../../presentation/widgets/prayer/tayammum/tayammum_content.dart';

class TayammumView extends StatelessWidget {
  const TayammumView({super.key});

  @override
  Widget build(BuildContext context) => PrayerDetailScaffold(
    title: context.l10n.prayerTayammumTitle,
    accent: MyColors.secondary,
    child: const TayammumContent(),
  );
}
