import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/presentation/viewmodels/prayer/prayer_movement_guide_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/prayer/movement_guide/prayer_movement_guide_widgets.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_language_menu_action.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_visuals.dart';

// MARK: Prayer - How To Pray Screen
class HowToPrayView extends StatelessWidget {
  const HowToPrayView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerMovementGuideViewModel(),
      child: const _HowToPrayBody(),
    );
  }
}

// MARK: Prayer - How To Pray Body
class _HowToPrayBody extends StatelessWidget {
  const _HowToPrayBody();

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<PrayerMovementGuideViewModel>();
    final steps = viewModel.steps(context.l10n);
    final hadiths = viewModel.hadiths(context.l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.prayerMovementsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: const [PrayerLanguageMenuAction()],
      ),
      body: Stack(
        children: [
          // MARK: Prayer - How To Pray Background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppGradients.darkPageBg
                    : AppGradients.pageBg,
              ),
            ),
          ),
          AppPageScrollbar(
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                responsive.padding,
                AppSpacing.sm + 2,
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
                      // MARK: Prayer - Movement Hero
                      PrayerMovementGuideHero(stepCount: steps.length),
                      // MARK: Prayer - Movement Sequence
                      PrayerSectionHeader(
                        title: context.l10n.prayerMovementsSequenceTitle,
                        subtitle: context.l10n.prayerMovementsSequenceSubtitle,
                        icon: Icons.route_rounded,
                        accent: MyColors.secondary,
                      ),
                      PrayerMovementFlowChips(steps: steps),
                      const SizedBox(height: AppSpacing.lg),
                      // MARK: Prayer - Movement Steps
                      for (var index = 0; index < steps.length; index++) ...[
                        PrayerMovementStepCard(
                          step: steps[index],
                          reverseOnWide: index.isOdd,
                        ),
                        if (index != steps.length - 1)
                          const SizedBox(height: AppSpacing.lg),
                      ],
                      // MARK: Prayer - Movement Hadith
                      PrayerSectionHeader(
                        title: context.l10n.prayerMovementsHadithTitle,
                        subtitle: context.l10n.prayerMovementsHadithSubtitle,
                        icon: Icons.menu_book_rounded,
                        accent: MyColors.tertiary,
                      ),
                      PrayerMovementHadithPanel(hadiths: hadiths),
                      // MARK: Prayer - Movement Fiqh Note
                      const PrayerMovementFiqhNote(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
