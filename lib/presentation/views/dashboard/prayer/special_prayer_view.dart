import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/core/utils/app_responsive.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/viewmodels/prayer/special_prayer_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_page_scrollbar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_language_menu_action.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/prayer_visuals.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/special_prayer/special_prayer_hadith_panel.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/special_prayer/special_prayer_hero.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/special_prayer/special_prayer_note_card.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/special_prayer/special_prayer_quick_facts.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/prayer/special_prayer/special_prayer_section_card.dart';

class SpecialPrayerView extends StatelessWidget {
  const SpecialPrayerView({super.key, required this.type});

  final SpecialPrayerType type;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpecialPrayerViewModel(type),
      child: const _SpecialPrayerBody(),
    );
  }
}

class _SpecialPrayerBody extends StatelessWidget {
  const _SpecialPrayerBody();

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<SpecialPrayerViewModel>();
    final content = viewModel.content(context.l10n);
    final primaryAccent = _primaryAccentFor(content.type);

    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: const [PrayerLanguageMenuAction()],
      ),
      body: Stack(
        children: [
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
                      // Hero section.
                      SpecialPrayerHero(content: content),

                      // Quick fact section.
                      PrayerSectionHeader(
                        title: content.quickFactsTitle,
                        subtitle: content.quickFactsSubtitle,
                        icon: Icons.grid_view_rounded,
                        accent: primaryAccent,
                      ),
                      SpecialPrayerQuickFacts(
                        type: content.type,
                        facts: content.facts,
                      ),

                      // Instruction sections, each with its own comment.
                      PrayerSectionHeader(
                        title: content.guideTitle,
                        subtitle: content.guideSubtitle,
                        icon: Icons.route_rounded,
                        accent: MyColors.secondary,
                      ),
                      for (
                        var index = 0;
                        index < content.sections.length;
                        index++
                      ) ...[
                        SpecialPrayerSectionCard(
                          section: content.sections[index],
                          index: index,
                          type: content.type,
                          commentLabel: content.sectionCommentLabel,
                        ),
                        if (index != content.sections.length - 1)
                          const SizedBox(height: AppSpacing.lg),
                      ],

                      // Hadith section.
                      PrayerSectionHeader(
                        title: content.hadithTitle,
                        subtitle: content.hadithSubtitle,
                        icon: Icons.menu_book_rounded,
                        accent: MyColors.tertiary,
                      ),
                      SpecialPrayerHadithPanel(
                        references: content.hadithReferences,
                        type: content.type,
                      ),
                      SpecialPrayerNoteCard(
                        note: content.note,
                        type: content.type,
                      ),
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

  Color _primaryAccentFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => MyColors.tertiary,
      SpecialPrayerType.salatulTasbeeh => MyColors.secondary,
    };
  }
}
