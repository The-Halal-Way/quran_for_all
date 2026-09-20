import 'package:flutter/cupertino.dart';
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
        detail: readDetail,
        iconAsset: MyIcons.quranViewIcon,
        icon: CupertinoIcons.book_fill,
        accent: MyColors.secondary,
        secondaryAccent: MyColors.primaryLight,
      ),
      QuranHubAction(
        destination: QuranHubDestination.learn,
        title: l10n.quranHubLearnTitle,
        detail: learnDetail,
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
        icon: CupertinoIcons.rosette,
        accent: MyColors.secondary,
      ),
      QuranHubHadith(
        title: l10n.quranHubHadithIntercessorTitle,
        body: l10n.quranHubHadithIntercessorBody,
        source: l10n.quranHubHadithIntercessorSource,
        icon: CupertinoIcons.sun_max_fill,
        accent: MyColors.primaryLight,
      ),
      QuranHubHadith(
        title: l10n.quranHubHadithEffortTitle,
        body: l10n.quranHubHadithEffortBody,
        source: l10n.quranHubHadithEffortSource,
        icon: CupertinoIcons.circle_grid_hex_fill,
        accent: MyColors.tertiary,
      ),
    ];
  }
}
