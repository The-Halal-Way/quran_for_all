import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../viewmodels/prayer/prayer_viewmodel.dart';
import '../../../views/prayer/forbidden_times/forbidden_times_view.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_view.dart';
import '../../../views/prayer/how_to_pray/how_to_pray_view.dart';
import '../../../views/prayer/janaza_prayer/janaza_prayer_view.dart';
import '../../../views/prayer/nafal_prayers/nafal_prayers_view.dart';
import '../../../views/prayer/salatul_tasbeeh/salatul_tasbeeh_view.dart';
import '../../common/app_icon_grid_section.dart';

class PrayerReferenceSection extends StatelessWidget {
  const PrayerReferenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final model = context.watch<PrayerViewModel>();
    void open(Widget page) =>
        Navigator.of(context).push(AppPageRoute<void>(builder: (_) => page));

    return AppIconGridSection(
      title: l10n.prayerReferenceTitle,
      phoneColumns: 3,
      labelMaxLines: 3,
      items: [
        AppIconGridItem(
          label: l10n.prayerReferenceMovementsActionTitle,
          description: l10n.prayerReferenceMovementsActionSubtitle,
          icon: Icons.self_improvement_rounded,
          accent: MyColors.primaryLight,
          onTap: () => open(const HowToPrayView()),
        ),
        AppIconGridItem(
          label: l10n.prayerReferenceForbiddenActionTitle,
          description: l10n.prayerReferenceForbiddenActionSubtitle,
          icon: Icons.block_rounded,
          accent: MyColors.secondary,
          onTap: () =>
              open(ForbiddenTimesView(items: model.forbiddenTimes(l10n))),
        ),
        AppIconGridItem(
          label: l10n.prayerReferenceNafalActionTitle,
          description: l10n.prayerReferenceNafalActionSubtitle,
          icon: Icons.auto_awesome_rounded,
          accent: MyColors.tertiaryDark,
          onTap: () => open(NafalPrayersView(items: model.nafalPrayers(l10n))),
        ),
        AppIconGridItem(
          label: l10n.prayerReferenceJanazaActionTitle,
          description: l10n.prayerReferenceJanazaActionSubtitle,
          icon: Icons.volunteer_activism_rounded,
          accent: MyColors.primaryLight,
          onTap: () => open(const JanazaPrayerView()),
        ),
        AppIconGridItem(
          label: l10n.prayerReferenceTasbeehActionTitle,
          description: l10n.prayerReferenceTasbeehActionSubtitle,
          icon: Icons.brightness_5_rounded,
          accent: MyColors.secondary,
          onTap: () => open(const SalatulTasbeehView()),
        ),
        AppIconGridItem(
          label: l10n.prayerReferenceEidActionTitle,
          description: l10n.prayerReferenceEidActionSubtitle,
          icon: Icons.nightlight_round,
          accent: MyColors.tertiaryDark,
          onTap: () => open(const EidPrayerView()),
        ),
      ],
    );
  }
}
