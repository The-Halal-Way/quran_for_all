import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../core/utils/app_responsive.dart';
import '../../../data/models/daily_reminders/daily_reminder_pack.dart';
import '../../viewmodels/daily_reminders/daily_reminders_viewmodel.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/daily_reminders/daily_reminders_view/daily_reminder_card.dart';
import '../../widgets/daily_reminders/daily_reminders_view/daily_reminders_empty_state.dart';
import '../../widgets/daily_reminders/daily_reminders_view/daily_reminders_filter_bar.dart';
import '../../widgets/daily_reminders/daily_reminders_view/daily_reminders_hero.dart';
import 'daily_reminder_preferences_view.dart';
import 'daily_reminder_reader_view.dart';

class DailyRemindersView extends StatefulWidget {
  const DailyRemindersView({super.key});

  @override
  State<DailyRemindersView> createState() => _DailyRemindersViewState();
}

class _DailyRemindersViewState extends State<DailyRemindersView> {
  String? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == null) {
      _locale = locale;
      final vm = context.read<DailyRemindersViewModel>();
      if (vm.pack == null && !vm.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) unawaited(vm.initialize(locale));
        });
      }
    } else if (_locale != locale) {
      _locale = locale;
      final vm = context.read<DailyRemindersViewModel>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(vm.localeChanged(locale));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyRemindersViewModel>();
    final responsive = AppResponsive.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final ready = !vm.isLoading && vm.error == null;
    final history = ready ? vm.filteredHistory : const <DailyReminderRecord>[];
    return Scaffold(
      body: AppPremiumPageBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => vm.initialize(locale, forceRefresh: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    responsive.padding,
                    AppSpacing.lg,
                    responsive.padding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: responsive.maxReadingContentWidth,
                        ),
                        child: _buildTopContent(context, vm, locale),
                      ),
                    ),
                  ),
                ),
                if (ready && history.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.padding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: DailyRemindersEmptyState(
                        title: context.l10n.dailyRemindersNoResults,
                        message: context.l10n.dailyRemindersNoNewMessage,
                        icon: Icons.filter_alt_off_rounded,
                      ),
                    ),
                  )
                else if (ready)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.padding,
                    ),
                    sliver: SliverList.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) => _historyItem(
                        context,
                        vm,
                        history,
                        index,
                        locale,
                        responsive.maxReadingContentWidth,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxxl),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent(
    BuildContext context,
    DailyRemindersViewModel vm,
    String locale,
  ) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyRemindersHero(
          l10n: l10n,
          onBack: () => Navigator.of(context).maybePop(),
          onSettings: () => _openPreferences(context),
        ),
        if (vm.isLoading) ...[
          const SizedBox(height: AppSpacing.xxl),
          const Center(child: CircularProgressIndicator()),
        ] else if (vm.error != null) ...[
          const SizedBox(height: AppSpacing.xxl),
          DailyRemindersEmptyState(
            title: l10n.dailyRemindersLoadError,
            message: vm.error.toString(),
            icon: Icons.error_outline_rounded,
          ),
          Center(
            child: FilledButton.icon(
              onPressed: () => vm.initialize(locale, forceRefresh: true),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.dailyRemindersRetry),
            ),
          ),
        ] else ...[
          const SizedBox(height: AppSpacing.xxl),
          Text(
            l10n.dailyRemindersToday,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.md),
          if (vm.todayReminder case final today?)
            _reminderCard(context, vm, today, locale, featured: true)
          else
            DailyRemindersEmptyState(
              title: vm.releasedRecords.isEmpty
                  ? l10n.dailyRemindersEmptyTitle
                  : l10n.dailyRemindersNoNewTitle,
              message: vm.releasedRecords.isEmpty
                  ? l10n.dailyRemindersEmptyMessage
                  : l10n.dailyRemindersNoNewMessage,
            ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            l10n.dailyRemindersHistory,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.md),
          DailyRemindersFilterBar(
            l10n: l10n,
            kinds: vm.availableKinds,
            selectedKind: vm.kindFilter,
            feedFilter: vm.feedFilter,
            onQueryChanged: vm.setQuery,
            onKindChanged: vm.setKindFilter,
            onFeedFilterChanged: vm.setFeedFilter,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }

  Widget _historyItem(
    BuildContext context,
    DailyRemindersViewModel vm,
    List<DailyReminderRecord> history,
    int index,
    String locale,
    double maxWidth,
  ) {
    final record = history[index];
    final showMonth =
        index == 0 ||
        !_sameMonth(
          record.schedule.localDate,
          history[index - 1].schedule.localDate,
        );
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showMonth)
              Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 0 : AppSpacing.xl,
                  bottom: AppSpacing.sm,
                ),
                child: Text(
                  DateFormat.yMMMM(
                    locale,
                  ).format(record.schedule.localDate.toLocalDateTime()),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _reminderCard(context, vm, record, locale),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reminderCard(
    BuildContext context,
    DailyRemindersViewModel vm,
    DailyReminderRecord record,
    String locale, {
    bool featured = false,
  }) => DailyReminderCard(
    record: record,
    edition: vm.resolveEdition(record.item)!,
    l10n: context.l10n,
    dateLabel: _formatDate(locale, record.schedule.localDate, long: featured),
    isRead: vm.isRead(record.item.id),
    isSaved: vm.isSaved(record.item.id),
    featured: featured,
    onOpen: () => _openReader(context, record),
    onToggleSaved: () => vm.toggleSaved(record.item.id),
  );

  void _openPreferences(BuildContext context) {
    Navigator.of(context).push(
      AppPageRoute<void>(builder: (_) => const DailyReminderPreferencesView()),
    );
  }

  void _openReader(BuildContext context, DailyReminderRecord record) {
    Navigator.of(context).push(
      AppPageRoute<void>(
        builder: (_) => DailyReminderReaderView(record: record),
      ),
    );
  }
}

bool _sameMonth(LocalCalendarDate a, LocalCalendarDate b) =>
    a.year == b.year && a.month == b.month;

String _formatDate(
  String locale,
  LocalCalendarDate value, {
  required bool long,
}) => DateFormat(
  long ? 'EEEE, d MMMM' : 'd MMM',
  locale,
).format(value.toLocalDateTime());
