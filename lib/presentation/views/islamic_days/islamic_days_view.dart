import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../services/hijri_calendar_service.dart';
import '../../models/islamic_day_presenter.dart';
import '../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/islamic_days/overview/islamic_day_occasion_card.dart';
import '../../widgets/islamic_days/overview/islamic_days_empty_state.dart';
import '../../widgets/islamic_days/overview/islamic_days_feed_selector.dart';
import '../../widgets/islamic_days/overview/islamic_days_hero.dart';
import '../../widgets/islamic_days/overview/islamic_days_load_state.dart';
import '../../widgets/islamic_days/overview/islamic_days_search_field.dart';
import '../../widgets/islamic_days/shared/islamic_days_calendar_note.dart';
import '../../widgets/islamic_days/shared/islamic_days_mutation.dart';
import '../../widgets/islamic_days/shared/islamic_days_page_shell.dart';
import 'islamic_day_details_view.dart';
import 'islamic_days_preferences_view.dart';

class IslamicDaysView extends StatefulWidget {
  const IslamicDaysView({super.key});

  @override
  State<IslamicDaysView> createState() => _IslamicDaysViewState();
}

class _IslamicDaysViewState extends State<IslamicDaysView> {
  IslamicDaysFeed _feed = IslamicDaysFeed.today;
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<IslamicDaysViewModel>();
      if (!vm.ready && !vm.isLoading) {
        vm.initialize(
          context.l10n.localeName,
          context.read<SettingsViewModel>().settings.hijriDateAdjustment,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IslamicDaysViewModel>();
    final l10n = context.l10n;
    final hijri = const HijriCalendarService().fromGregorian(
      vm.localNow,
      adjustmentDays: vm.adjustment,
    );
    final records = switch (_feed) {
      IslamicDaysFeed.today => vm.today,
      IslamicDaysFeed.upcoming => vm.upcoming,
      IslamicDaysFeed.saved => vm.saved,
      IslamicDaysFeed.guides => vm.guides,
    };
    final filtered = records
        .where((entry) => _matches(entry, l10n.localeName))
        .toList();
    return IslamicDaysPageShell(
      title: l10n.islamicDaysTitle,
      actions: [
        IconButton(
          tooltip: l10n.islamicDaysPreferences,
          icon: const Icon(Icons.tune_rounded),
          onPressed: () => Navigator.of(context).push(
            AppPageRoute<void>(
              builder: (_) => const IslamicDaysPreferencesView(),
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IslamicDaysHero(
            hijriDate: l10n.hijriDateFull(
              islamicDayNumber(l10n, hijri.day),
              islamicDayMonth(l10n, hijri.month),
              islamicDayNumber(l10n, hijri.year),
            ),
            gregorianDate: islamicDayGregorianLabel(l10n, vm.localNow),
          ),
          const SizedBox(height: 22),
          IslamicDaysFeedSelector(
            selected: _feed,
            onChanged: (feed) => setState(() => _feed = feed),
          ),
          const SizedBox(height: 16),
          IslamicDaysSearchField(
            onChanged: (query) =>
                setState(() => _query = query.trim().toLowerCase()),
          ),
          const SizedBox(height: 18),
          if (!vm.ready || vm.error != null)
            IslamicDaysLoadState(
              hasError: vm.error != null,
              onRetry: () => vm.initialize(l10n.localeName, vm.adjustment),
            )
          else if (filtered.isEmpty) ...[
            IslamicDaysEmptyState(
              icon: _feed == IslamicDaysFeed.saved
                  ? Icons.bookmark_border_rounded
                  : Icons.nightlight_round,
              title: _query.isNotEmpty
                  ? l10n.islamicDaysNoResults
                  : _feed == IslamicDaysFeed.saved
                  ? l10n.islamicDaysSavedEmpty
                  : l10n.islamicDaysTodayEmpty,
              message: _feed == IslamicDaysFeed.saved
                  ? l10n.islamicDaysSavedEmptyBody
                  : l10n.islamicDaysTodayEmptyBody,
            ),
            if (_feed == IslamicDaysFeed.today &&
                _query.isEmpty &&
                vm.upcoming.isNotEmpty) ...[
              const SizedBox(height: 18),
              _card(vm.upcoming.first, vm),
            ],
          ] else ...[
            if (_feed == IslamicDaysFeed.upcoming) ...[
              Text(l10n.islamicDaysUpcomingBody),
              const SizedBox(height: 16),
            ],
            for (final occurrence in filtered) ...[
              _card(occurrence, vm),
              const SizedBox(height: 14),
            ],
          ],
          const SizedBox(height: 18),
          const IslamicDaysCalendarNote(),
        ],
      ),
    );
  }

  Widget _card(IslamicDayOccurrence occurrence, IslamicDaysViewModel vm) =>
      IslamicDayOccasionCard(
        occurrence: occurrence,
        saved: vm.isSaved(occurrence.event.id),
        onSave: () => saveIslamicDaysChange(
          context,
          () => vm.toggleSaved(occurrence.event.id),
        ),
        onOpen: () => Navigator.of(context).push(
          AppPageRoute<void>(
            builder: (_) => IslamicDayDetailsView(
              eventId: occurrence.event.id,
              date: occurrence.date,
            ),
          ),
        ),
      );

  bool _matches(IslamicDayOccurrence occurrence, String locale) {
    final event = occurrence.event;
    return [
      event.title.resolve(locale),
      event.description.resolve(locale),
      ...event.actions.map((action) => action.text.resolve(locale)),
      ...event.hadith.expand(
        (hadith) => [
          hadith.arabic,
          hadith.meaning.resolve(locale),
          hadith.reference,
        ],
      ),
    ].join(' ').toLowerCase().contains(_query);
  }
}
