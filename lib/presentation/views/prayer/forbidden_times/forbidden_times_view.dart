import 'package:flutter/material.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_forbidden_times_card.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_detail_scaffold.dart';

// MARK: Prayer - Forbidden Times Screen
class ForbiddenTimesView extends StatelessWidget {
  const ForbiddenTimesView({super.key, required this.items});

  final List<PrayerForbiddenTimeItem> items;

  @override
  Widget build(BuildContext context) {
    return PrayerDetailScaffold(
      title: context.l10n.prayerForbiddenTimesTitle,
      accent: MyColors.secondary,
      child: PrayerForbiddenTimesCard(items: items),
    );
  }
}
