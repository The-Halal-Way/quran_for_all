import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:quran_for_all/presentation/models/daily_hadith_presenter.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_hadith_viewmodel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/daily_hadith/daily_hadith_reader/daily_hadith_arabic_passage_card.dart';
import '../../widgets/daily_hadith/daily_hadith_reader/daily_hadith_content_block.dart';
import '../../widgets/daily_hadith/daily_hadith_reader/daily_hadith_reader_actions.dart';
import '../../widgets/daily_hadith/daily_hadith_reader/daily_hadith_reader_header.dart';
import '../../widgets/daily_hadith/daily_hadith_reader/daily_hadith_source_section.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_navigation.dart';

class DailyHadithReaderView extends StatefulWidget {
  const DailyHadithReaderView({super.key, required this.record});
  final DailyHadithRecord record;
  @override
  State<DailyHadithReaderView> createState() => _DailyHadithReaderViewState();
}

class _DailyHadithReaderViewState extends State<DailyHadithReaderView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(
          context.read<DailyHadithViewModel>().markRead(widget.record.item.id),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyHadithViewModel>();
    final pack = vm.pack!;
    final item = widget.record.item;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final resolved = vm.resolveEdition(item)!;
    final edition = resolved.edition;
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);
    final originalIds = item.originalPassageIds.toSet();
    final contentBlocks = edition.blocks.where(
      (block) =>
          block.type != DailyHadithBlockType.action &&
          !(block.type == DailyHadithBlockType.originalPassage &&
              originalIds.contains(block.passageId)),
    );
    final actionBlock = edition.blocks
        .where(
          (block) =>
              block.type == DailyHadithBlockType.action &&
              block.actionType == 'addChecklistItem' &&
              block.targetId == item.id,
        )
        .firstOrNull;

    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              responsive.padding,
              AppSpacing.md,
              responsive.padding,
              AppSpacing.huge,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            CupertinoIcons.chevron_back,
                            size: 21,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.76),
                            side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.58),
                              width: 0.7,
                            ),
                          ),
                        ),
                        const Spacer(),
                        DailyHadithReaderActions(
                          l10n: l10n,
                          isSaved: vm.isSaved(item.id),
                          canAddChecklist: actionBlock != null,
                          onToggleSaved: () => vm.toggleSaved(item.id),
                          onShare: () => _share(context, pack, item, edition),
                          onAddChecklist: () =>
                              _addToChecklist(context, item, actionBlock),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    DailyHadithReaderHeader(
                      item: item,
                      edition: edition,
                      dateLabel: DateFormat.yMMMMEEEEd(locale).format(
                        widget.record.schedule.localDate.toLocalDateTime(),
                      ),
                      l10n: l10n,
                    ),
                    if (resolved.isFallback) ...[
                      const SizedBox(height: AppSpacing.md),
                      Chip(
                        avatar: const Icon(CupertinoIcons.globe, size: 16),
                        label: Text(
                          l10n.dailyHadithFallbackLanguage(edition.locale),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    ...item.originalPassageIds.map((id) {
                      final passage = pack.passages[id];
                      return passage == null
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.lg,
                              ),
                              child: DailyHadithArabicPassageCard(
                                passage: passage,
                                l10n: l10n,
                              ),
                            );
                    }),
                    ...contentBlocks.map(
                      (block) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                        child: DailyHadithContentBlock(
                          block: block,
                          pack: pack,
                          l10n: l10n,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Text(
                        l10n.dailyHadithReviewNote,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    DailyHadithSourceSection(
                      sources: item.sourceIds
                          .map((id) => pack.sources[id])
                          .whereType<DailyHadithSource>()
                          .toList(),
                      l10n: l10n,
                      onOpen: (source) => _openSource(context, source),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _share(
    BuildContext context,
    DailyHadithPack pack,
    DailyHadithItem item,
    DailyHadithEdition edition,
  ) async {
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text: dailyHadithShareText(
          pack: pack,
          item: item,
          edition: edition,
          originalArabicLabel: context.l10n.dailyHadithOriginalArabic,
          originalReflectionLabel: context.l10n.dailyHadithOriginalReflection,
          suggestedActionLabel: context.l10n.dailyHadithSuggestedAction,
          sourcesLabel: context.l10n.dailyHadithSources,
          reviewNote: context.l10n.dailyHadithReviewNote,
        ),
        subject: edition.title,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _addToChecklist(
    BuildContext context,
    DailyHadithItem item,
    DailyHadithBlock? action,
  ) async {
    if (action == null) return;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final alternative = item.editions.entries
        .where((entry) => entry.key != locale.split('-').first)
        .map((entry) => entry.value.blocks)
        .expand((blocks) => blocks)
        .where((block) => block.id == action.id)
        .map((block) => block.value)
        .whereType<String>()
        .firstOrNull;
    await context.read<DailyTrackerViewModel>().addReminderTask(
      contentId: item.id,
      title: action.value ?? '',
      alternateLocaleTitle: alternative ?? '',
    );
    if (context.mounted) {
      AppSnackbar.showInfo(context, context.l10n.dailyHadithChecklistAdded);
    }
  }

  Future<void> _openSource(
    BuildContext context,
    DailyHadithSource source,
  ) async {
    if (source.hasExactOfflineQuranMapping) {
      final readVm = context.read<ReadQuranViewModel>();
      if (readVm.surahs.isEmpty) await readVm.load(showLoading: false);
      final surah = readVm.surahs
          .where((entry) => entry.id == source.surah)
          .firstOrNull;
      if (surah != null && context.mounted) {
        await openDashboardSurah(context, surah, source.verseStart);
        return;
      }
    }
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(source.url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      AppSnackbar.showError(context, context.l10n.dailyHadithSourceError);
    }
  }
}
