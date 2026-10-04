import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/viewmodels/prayer/special_prayer_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_language_menu_action.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_section_header.dart';
import 'package:quran_for_all/presentation/widgets/prayer/shared/prayer_detail_scaffold.dart';
import 'package:quran_for_all/presentation/widgets/prayer/special_prayer/special_prayer_hadith_panel.dart';
import 'package:quran_for_all/presentation/widgets/prayer/special_prayer/special_prayer_hero.dart';
import 'package:quran_for_all/presentation/widgets/prayer/special_prayer/special_prayer_note_card.dart';
import 'package:quran_for_all/presentation/widgets/prayer/special_prayer/special_prayer_quick_facts.dart';
import 'package:quran_for_all/presentation/widgets/prayer/special_prayer/special_prayer_section_card.dart';

// MARK: Prayer - Special Prayer Screen
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

// MARK: Prayer - Special Prayer Body
class _SpecialPrayerBody extends StatelessWidget {
  const _SpecialPrayerBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SpecialPrayerViewModel>();
    final content = viewModel.content(context.l10n);
    final primaryAccent = _primaryAccentFor(content.type);

    return PrayerDetailScaffold(
      title: content.title,
      accent: primaryAccent,
      actions: const [PrayerLanguageMenuAction()],
      child: _SpecialPrayerContent(
        content: content,
        primaryAccent: primaryAccent,
      ),
    );
  }

  // MARK: Prayer - Special Prayer Primary Accent
  Color _primaryAccentFor(SpecialPrayerType type) {
    return switch (type) {
      SpecialPrayerType.janaza => MyColors.tertiary,
      SpecialPrayerType.salatulTasbeeh => MyColors.secondary,
    };
  }
}

class _SpecialPrayerContent extends StatelessWidget {
  const _SpecialPrayerContent({
    required this.content,
    required this.primaryAccent,
  });

  final SpecialPrayerContent content;
  final Color primaryAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpecialPrayerHero(content: content),
        PrayerSectionHeader(
          title: content.quickFactsTitle,
          subtitle: content.quickFactsSubtitle,
          icon: Icons.grid_view_rounded,
          accent: primaryAccent,
        ),
        SpecialPrayerQuickFacts(type: content.type, facts: content.facts),
        PrayerSectionHeader(
          title: content.guideTitle,
          subtitle: content.guideSubtitle,
          icon: Icons.route_rounded,
          accent: MyColors.secondary,
        ),
        for (var index = 0; index < content.sections.length; index++) ...[
          SpecialPrayerSectionCard(
            section: content.sections[index],
            index: index,
            type: content.type,
            commentLabel: content.sectionCommentLabel,
          ),
          if (index != content.sections.length - 1)
            const SizedBox(height: AppSpacing.lg),
        ],
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
        SpecialPrayerNoteCard(note: content.note, type: content.type),
      ],
    );
  }
}
