import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../presentation/widgets/prayer/shared/prayer_detail_scaffold.dart';
import '../../../../presentation/widgets/prayer/wudu/wudu_content.dart';

class WuduView extends StatelessWidget {
  const WuduView({super.key});

  @override
  Widget build(BuildContext context) => PrayerDetailScaffold(
    title: context.l10n.prayerWuduTitle,
    accent: MyColors.tertiary,
    child: const WuduContent(),
  );
}
