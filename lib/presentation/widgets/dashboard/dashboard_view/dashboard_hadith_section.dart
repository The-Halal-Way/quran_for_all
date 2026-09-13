import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../views/dashboard/hadith/hadith_an_nawawi_view.dart';
import '../../../views/dashboard/hadith/hadith_forty_short_view.dart';
import '../hadith/common/hadith_collection_palette.dart';
import 'dashboard_hadith_card.dart';
import 'dashboard_navigation.dart';
import 'dashboard_section_title.dart';

class DashboardHadithSection extends StatelessWidget {
  const DashboardHadithSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      DashboardHadithCard(
        arabicTitle: 'الأربعون النووية',
        title: context.l10n.dashboardHadithAnNawawiTitle,
        description: context.l10n.dashboardHadithAnNawawiDescription,
        gradient: HadithCollectionPalette.anNawawiGradient,
        onTap: () => pushDashboardPage(context, const HadithAnNawawiView()),
      ),
      DashboardHadithCard(
        arabicTitle: 'الأحاديث القصيرة',
        title: context.l10n.dashboardHadithShortTitle,
        description: context.l10n.dashboardHadithShortDescription,
        gradient: HadithCollectionPalette.fortyShortGradient,
        onTap: () => pushDashboardPage(context, const HadithFortyShortView()),
      ),
    ];
    return Column(
      children: [
        DashboardSectionTitle(
          title: context.l10n.dashboardSectionHadith,
          icon: Icons.menu_book_rounded,
          accent: MyColors.primaryLight,
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth >= 740 &&
                  MediaQuery.textScalerOf(context).scale(14) < 20
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards.first),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: cards.last),
                  ],
                )
              : Column(
                  children: [
                    cards.first,
                    const SizedBox(height: AppSpacing.md),
                    cards.last,
                  ],
                ),
        ),
      ],
    );
  }
}
