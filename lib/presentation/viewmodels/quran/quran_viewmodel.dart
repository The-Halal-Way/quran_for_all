import 'package:flutter/material.dart';

import '../../../core/theme/my_colors.dart';
import '../../../core/theme/my_icons.dart';
import '../../../data/models/quran/quran_hub_models.dart';
import '../../../l10n/app_localizations.dart';
import '../learn_quran_viewmodel.dart';
import '../read_quran/read_quran_viewmodel.dart';

class QuranViewModel {
  QuranHubContent content({
    required AppLocalizations l10n,
    required ReadQuranViewModel readViewModel,
    required LearnQuranViewModel learnViewModel,
  }) {
    return QuranHubContent(
      actions: _actions(
        l10n: l10n,
        readViewModel: readViewModel,
        learnViewModel: learnViewModel,
      ),
      hadiths: _hadiths(l10n),
      stats: _stats(l10n, readViewModel),
    );
  }

  List<QuranHubAction> _actions({
    required AppLocalizations l10n,
    required ReadQuranViewModel readViewModel,
    required LearnQuranViewModel learnViewModel,
  }) {
    final lastRead = readViewModel.lastRead;
    final lastReadSurah = readViewModel.lastReadSurah;
    final readDetail = lastRead != null && lastReadSurah != null
        ? l10n.quranHubReadContinueDetail(
            lastReadSurah.nameTranslated.isNotEmpty
                ? lastReadSurah.nameTranslated
                : lastReadSurah.nameEnglish,
            lastRead.ayahNumber,
          )
        : l10n.quranHubReadFreshStart;

    final nextLesson = learnViewModel.nextLesson;
    final learnDetail = nextLesson?.title ?? l10n.quranHubLearningFreshStart;

    return [
      QuranHubAction(
        destination: QuranHubDestination.read,
        title: l10n.quranHubReadTitle,
        subtitle: l10n.quranHubReadSubtitle,
        detail: readDetail,
        actionLabel: l10n.quranHubReadAction,
        metricValue: _surahCount(readViewModel).toString(),
        metricLabel: l10n.readQuranSurahsLabel,
        iconAsset: MyIcons.quranViewIcon,
        icon: Icons.auto_stories_rounded,
        accent: MyColors.secondary,
        secondaryAccent: MyColors.primaryLight,
      ),
      QuranHubAction(
        destination: QuranHubDestination.learn,
        title: l10n.quranHubLearnTitle,
        subtitle: l10n.quranHubLearnSubtitle,
        detail: learnDetail,
        actionLabel: l10n.quranHubLearnAction,
        metricValue: learnViewModel.modules.length.toString(),
        metricLabel: l10n.learnHeaderModulesLabel,
        iconAsset: MyIcons.learnIcon,
        icon: Icons.school_rounded,
        accent: MyColors.tertiary,
        secondaryAccent: const Color(0xFF005C4B),
        progress: learnViewModel.overallProgress,
      ),
    ];
  }

  List<QuranHubHadith> _hadiths(AppLocalizations l10n) {
    return [
      QuranHubHadith(
        title: l10n.quranHubHadithBestTitle,
        body: l10n.quranHubHadithBestBody,
        source: l10n.quranHubHadithBestSource,
        icon: Icons.workspace_premium_rounded,
        accent: MyColors.secondary,
      ),
      QuranHubHadith(
        title: l10n.quranHubHadithIntercessorTitle,
        body: l10n.quranHubHadithIntercessorBody,
        source: l10n.quranHubHadithIntercessorSource,
        icon: Icons.brightness_7_rounded,
        accent: MyColors.primaryLight,
      ),
      QuranHubHadith(
        title: l10n.quranHubHadithEffortTitle,
        body: l10n.quranHubHadithEffortBody,
        source: l10n.quranHubHadithEffortSource,
        icon: Icons.diamond_rounded,
        accent: MyColors.tertiary,
      ),
    ];
  }

  List<QuranHubStat> _stats(
    AppLocalizations l10n,
    ReadQuranViewModel readViewModel,
  ) {
    return [
      QuranHubStat(
        value: _surahCount(readViewModel).toString(),
        label: l10n.readQuranSurahsLabel,
        icon: Icons.menu_book_rounded,
        color: MyColors.secondary,
      ),
      QuranHubStat(
        value: l10n.quranHubStatOfflineValue,
        label: l10n.quranHubStatOfflineLabel,
        icon: Icons.offline_bolt_rounded,
        color: MyColors.tertiary,
      ),
      QuranHubStat(
        value: l10n.quranHubStatLanguagesValue,
        label: l10n.quranHubStatLanguagesLabel,
        icon: Icons.translate_rounded,
        color: MyColors.primaryLight,
      ),
    ];
  }

  int _surahCount(ReadQuranViewModel viewModel) {
    return viewModel.surahs.isEmpty ? 114 : viewModel.surahs.length;
  }
}
