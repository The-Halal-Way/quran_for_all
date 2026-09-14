import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../models/daily_reminder_presenter.dart';
import '../../viewmodels/daily_reminders/daily_reminders_viewmodel.dart';
import '../../viewmodels/dashboard/daily_tracker_viewmodel.dart';
import '../../viewmodels/read_quran/read_quran_viewmodel.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/daily_reminders/daily_reminder_reader/daily_reminder_arabic_passage_card.dart';
import '../../widgets/daily_reminders/daily_reminder_reader/daily_reminder_content_block.dart';
import '../../widgets/daily_reminders/daily_reminder_reader/daily_reminder_reader_actions.dart';
import '../../widgets/daily_reminders/daily_reminder_reader/daily_reminder_reader_header.dart';
import '../../widgets/daily_reminders/daily_reminder_reader/daily_reminder_source_section.dart';
import '../../widgets/dashboard/dashboard_view/dashboard_navigation.dart';

class DailyReminderReaderView extends StatefulWidget {
  const DailyReminderReaderView({super.key, required this.record});

  final DailyReminderRecord record;

  @override
  State<DailyReminderReaderView> createState() =>
      _DailyReminderReaderViewState();
}

class _DailyReminderReaderViewState extends State<DailyReminderReaderView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(
          context.read<DailyRemindersViewModel>().markRead(
            widget.record.item.id,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyRemindersViewModel>();
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
          block.type != DailyReminderBlockType.action &&
          !(block.type == DailyReminderBlockType.originalPassage &&
              originalIds.contains(block.passageId)),
    );
    final actionBlock = edition.blocks
        .where(
          (block) =>
              block.type == DailyReminderBlockType.action &&
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
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const Spacer(),
                        DailyReminderReaderActions(
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
                    DailyReminderReaderHeader(
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
                        avatar: const Icon(Icons.translate_rounded, size: 16),
                        label: Text(
                          l10n.dailyRemindersFallbackLanguage(edition.locale),
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
                              child: DailyReminderArabicPassageCard(
                                passage: passage,
                                l10n: l10n,
                              ),
                            );
                    }),
                    ...contentBlocks.map(
                      (block) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                        child: DailyReminderContentBlock(
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
                        l10n.dailyRemindersReviewNote,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    DailyReminderSourceSection(
                      sources: item.sourceIds
                          .map((id) => pack.sources[id])
                          .whereType<DailyReminderSource>()
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
    DailyReminderPack pack,
    DailyReminderItem item,
    DailyReminderEdition edition,
  ) async {
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text: dailyReminderShareText(
          pack: pack,
          item: item,
          edition: edition,
          originalArabicLabel: context.l10n.dailyRemindersOriginalArabic,
          originalReflectionLabel:
              context.l10n.dailyRemindersOriginalReflection,
          suggestedActionLabel: context.l10n.dailyRemindersSuggestedAction,
          sourcesLabel: context.l10n.dailyRemindersSources,
          reviewNote: context.l10n.dailyRemindersReviewNote,
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
    DailyReminderItem item,
    DailyReminderBlock? action,
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
      AppSnackbar.showInfo(context, context.l10n.dailyRemindersChecklistAdded);
    }
  }

  Future<void> _openSource(
    BuildContext context,
    DailyReminderSource source,
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
      AppSnackbar.showError(context, context.l10n.dailyRemindersSourceError);
    }
  }
}
