import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../viewmodels/prayer/prayer_movement_guide_viewmodel.dart';
import '../../common/app_page_scrollbar.dart';
import '../../common/app_premium_page_background.dart';
import '../shared/prayer_section_header.dart';
import 'prayer_guide_variant_selector.dart';
import 'prayer_movement_fiqh_note.dart';
import 'prayer_movement_flow_chips.dart';
import 'prayer_movement_guide_hero.dart';
import 'prayer_movement_hadith_panel.dart';
import 'prayer_movement_step_card.dart';

class HowToPrayBody extends StatelessWidget {
  const HowToPrayBody({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final model = context.watch<PrayerMovementGuideViewModel>();
    final l10n = context.l10n;
    final steps = model.steps(l10n);

    return AppPremiumPageBackground(
      child: SafeArea(
        top: false,
        child: AppPageScrollbar(
          key: ValueKey(model.variant),
          thumbVisibility: true,
          builder: (context, controller) => SingleChildScrollView(
            key: PageStorageKey('prayer-guide-${model.variant.name}'),
            controller: controller,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              responsive.padding,
              AppSpacing.md,
              responsive.padding,
              AppSpacing.huge,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: responsive.maxReadingContentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrayerGuideVariantSelector(
                      selected: model.variant,
                      onSelected: model.selectVariant,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrayerMovementGuideHero(
                      stepCount: steps.length,
                      variant: model.variant,
                    ),
                    PrayerSectionHeader(
                      title: l10n.prayerMovementsSequenceTitle,
                      subtitle: l10n.prayerMovementsSequenceSubtitle,
                      icon: Icons.route_rounded,
                      accent: MyColors.secondary,
                    ),
                    PrayerMovementFlowChips(steps: steps),
                    const SizedBox(height: AppSpacing.lg),
                    for (var index = 0; index < steps.length; index++) ...[
                      PrayerMovementStepCard(
                        step: steps[index],
                        reverseOnWide: index.isOdd,
                      ),
                      if (index != steps.length - 1)
                        const SizedBox(height: AppSpacing.lg),
                    ],
                    PrayerSectionHeader(
                      title: l10n.prayerMovementsHadithTitle,
                      subtitle: l10n.prayerMovementsHadithSubtitle,
                      icon: Icons.menu_book_rounded,
                      accent: MyColors.tertiary,
                    ),
                    PrayerMovementHadithPanel(hadiths: model.hadiths(l10n)),
                    const PrayerMovementFiqhNote(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
