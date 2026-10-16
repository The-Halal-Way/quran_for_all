import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/my_colors.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/learn_quran_content.dart';
import '../../../../data/models/surah_model.dart';
import '../../../viewmodels/learn_quran_viewmodel.dart';
import '../../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../../viewmodels/read_quran/surah_details_viewmodel.dart';
import '../../../views/quran/learn_quran/learn_quran_view.dart';
import '../../../views/quran/learn_quran/learning_quran_detail_view.dart';
import '../../../views/quran/read_quran/read_quran_view.dart';
import '../../../views/quran/read_quran/surah_details_view.dart';
import 'quran_continue_card.dart';

class QuranContinueSection extends StatelessWidget {
  const QuranContinueSection({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.watch<ReadQuranViewModel>();
    final learn = context.watch<LearnQuranViewModel>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final hasLastRead = read.lastRead != null && read.lastReadSurah != null;
    final lastRead = read.lastRead;
    final lastReadSurah = read.lastReadSurah;
    final nextLesson = learn.nextLesson;
    final nextModule = nextLesson != null
        ? learn.moduleForLesson(nextLesson.id)
        : (learn.modules.isEmpty ? null : learn.modules.first);

    final cards = [
      QuranContinueCard(
        title: context.l10n.quranHubContinueReadingTitle,
        subtitle: hasLastRead
            ? '${lastReadSurah!.nameEnglish} (${lastReadSurah.nameArabic})'
            : context.l10n.quranHubContinueReadingStartSubtitle,
        detail: hasLastRead
            ? context.l10n.quranHubContinueReadingAyahDetail(
                lastRead!.ayahNumber,
                lastReadSurah!.nameTranslated.isNotEmpty
                    ? lastReadSurah.nameTranslated
                    : lastReadSurah.nameEnglish,
              )
            : context.l10n.quranHubContinueReadingStartDetail,
        icon: Icons.auto_stories_rounded,
        accent: dark ? MyColors.primaryLight : AppThemeColors.light.heroEnd,
        onTap: hasLastRead
            ? () => _openSurah(context, lastReadSurah!, lastRead!.ayahNumber)
            : () => _push(context, const ReadQuranView()),
      ),
      QuranContinueCard(
        title: context.l10n.quranHubContinueLearningTitle,
        subtitle:
            nextLesson?.title ??
            context.l10n.quranHubContinueLearningStartSubtitle,
        detail: nextModule != null
            ? context.l10n.quranHubContinueLearningModuleDetail(
                nextModule.title,
                nextModule.lessons.length,
              )
            : context.l10n.quranHubContinueLearningStartDetail,
        icon: Icons.school_rounded,
        accent: dark ? MyColors.tertiaryDark : AppThemeColors.light.cyan,
        onTap: () => _openLearning(context, learn, nextModule),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final singleColumn = constraints.maxWidth < 280 || scale > 1.5;
        return singleColumn
            ? Column(
                children: [
                  cards.first,
                  const SizedBox(height: AppSpacing.md),
                  cards.last,
                ],
              )
            : Row(
                children: [
                  Expanded(child: cards.first),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: cards.last),
                ],
              );
      },
    );
  }

  static void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(AppPageRoute<void>(builder: (_) => page));
  }

  static Future<void> _openSurah(
    BuildContext context,
    SurahModel surah,
    int ayah,
  ) async {
    unawaited(context.read<SurahDetailsViewModel>().openSurah(surah));
    await Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => SurahDetailsView(surah: surah, initialAyahNumber: ayah),
      ),
    );
    if (context.mounted) {
      await context.read<ReadQuranViewModel>().load(showLoading: false);
    }
  }

  static void _openLearning(
    BuildContext context,
    LearnQuranViewModel learn,
    LearnQuranModule? module,
  ) {
    if (module == null) {
      _push(context, const LearnQuranView());
      return;
    }
    _push(context, LearningQuranDetailView(module: module));
  }
}
