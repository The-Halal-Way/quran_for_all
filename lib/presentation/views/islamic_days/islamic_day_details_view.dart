import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/islamic_days/islamic_day.dart';
import '../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../widgets/islamic_days/guide/islamic_day_checklist.dart';
import '../../widgets/islamic_days/guide/islamic_day_fasting_notice.dart';
import '../../widgets/islamic_days/guide/islamic_day_guidance_list.dart';
import '../../widgets/islamic_days/guide/islamic_day_guide_actions.dart';
import '../../widgets/islamic_days/guide/islamic_day_guide_header.dart';
import '../../widgets/islamic_days/guide/islamic_day_hadith_card.dart';
import '../../widgets/islamic_days/shared/islamic_days_calendar_note.dart';
import '../../widgets/islamic_days/shared/islamic_days_mutation.dart';
import '../../widgets/islamic_days/shared/islamic_days_page_shell.dart';

class IslamicDayDetailsView extends StatelessWidget {
  const IslamicDayDetailsView({
    super.key,
    required this.eventId,
    required this.date,
  });
  final String eventId;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vm = context.watch<IslamicDaysViewModel>();
    final occurrence = vm.occurrenceFor(eventId, date);
    final saved = vm.isSaved(eventId);
    return IslamicDaysPageShell(
      title: l10n.islamicDaysViewGuidance,
      actions: [
        IconButton(
          onPressed: () =>
              saveIslamicDaysChange(context, () => vm.toggleSaved(eventId)),
          tooltip: saved ? l10n.islamicDaysUnsave : l10n.islamicDaysSave,
          icon: Icon(
            saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          ),
        ),
      ],
      child: occurrence == null
          ? Text(l10n.islamicDaysLoadError)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IslamicDayGuideHeader(occurrence: occurrence),
                if (occurrence.dayFasting != IslamicDayFasting.none ||
                    occurrence.event.fasting != IslamicDayFasting.none ||
                    occurrence.pilgrimRestriction) ...[
                  const SizedBox(height: 18),
                  IslamicDayFastingNotice(occurrence: occurrence),
                ],
                const SizedBox(height: 18),
                IslamicDayChecklist(occurrence: occurrence),
                const SizedBox(height: 18),
                IslamicDayGuidanceList(
                  title: l10n.islamicDaysAvoid,
                  entries: occurrence.event.avoid,
                  locale: l10n.localeName,
                  avoid: true,
                ),
                if (occurrence.event.notes.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  IslamicDayGuidanceList(
                    title: l10n.islamicDaysNotes,
                    entries: occurrence.event.notes,
                    locale: l10n.localeName,
                  ),
                ],
                const SizedBox(height: 26),
                Text(
                  l10n.islamicDaysHadith,
                  style: AppTheme.text(
                    context,
                  ).titleLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                for (final hadith in occurrence.event.hadith) ...[
                  IslamicDayHadithCard(hadith: hadith),
                  const SizedBox(height: 14),
                ],
                IslamicDayGuideActions(occurrence: occurrence),
                const SizedBox(height: 18),
                const IslamicDaysCalendarNote(),
              ],
            ),
    );
  }
}
