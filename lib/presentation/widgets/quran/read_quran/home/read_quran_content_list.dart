import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_responsive.dart';
import '../../../../../data/models/surah_model.dart';
import '../../../common/section_header.dart';
import 'continue_reading_card.dart';
import 'read_quran_top_banner.dart';
import 'surah_card.dart';

class ReadQuranContentList extends StatelessWidget {
  const ReadQuranContentList({
    super.key,
    required this.controller,
    required this.surahs,
    required this.bookmarkedSurahIds,
    required this.onSearchTap,
    required this.onSurahTap,
    required this.onToggleBookmark,
    required this.onContinueTap,
    this.lastReadSurah,
    this.lastReadAyahNumber,
    this.lastReadPreview,
  });

  final ScrollController controller;
  final List<SurahModel> surahs;
  final Set<int> bookmarkedSurahIds;
  final VoidCallback onSearchTap;
  final ValueChanged<SurahModel> onSurahTap;
  final ValueChanged<SurahModel> onToggleBookmark;
  final VoidCallback onContinueTap;
  final SurahModel? lastReadSurah;
  final int? lastReadAyahNumber;
  final String? lastReadPreview;

  @override
  Widget build(BuildContext context) {
    final responsive = AppResponsive.of(context);
    final hasContinue = lastReadSurah != null && lastReadAyahNumber != null;
    final surahStart = hasContinue ? 3 : 2;

    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        responsive.padding,
        AppSpacing.sm + 2,
        responsive.padding,
        AppSpacing.lg,
      ),
      itemCount: surahStart + surahs.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: ReadQuranTopBanner(
              onSearchTap: onSearchTap,
              surahCount: surahs.length,
            ),
          );
        }

        if (hasContinue && index == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: ContinueReadingCard(
              surah: lastReadSurah!,
              ayahNumber: lastReadAyahNumber!,
              ayahPreview: lastReadPreview,
              onTap: onContinueTap,
            ),
          );
        }

        if (index == surahStart - 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
            child: SectionHeader(
              title: context.l10n.readQuranAllSurahsTitle,
              trailing: Chip(
                label: Text(
                  '${surahs.length} ${context.l10n.readQuranTotalLabel}',
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
          );
        }

        final surahIndex = index - surahStart;
        final surah = surahs[surahIndex];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SurahCard(
              key: ValueKey<int>(surah.id),
              surah: surah,
              onTap: () => onSurahTap(surah),
              isBookmarked: bookmarkedSurahIds.contains(surah.id),
              onToggleBookmark: () => onToggleBookmark(surah),
            ),
            if (surahIndex < surahs.length - 1)
              Divider(
                height: 1,
                indent: 64,
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.55),
              ),
          ],
        );
      },
    );
  }
}
