import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/islamic_days/islamic_day.dart';
import '../../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../shared/islamic_days_section.dart';

class IslamicDayFastingNotice extends StatelessWidget {
  const IslamicDayFastingNotice({super.key, required this.occurrence});
  final IslamicDayOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final prohibited = occurrence.dayFasting == IslamicDayFasting.prohibited;
    final ramadanOverride =
        occurrence.dayFasting == IslamicDayFasting.obligatory &&
        occurrence.event.fasting != IslamicDayFasting.obligatory;
    final title = prohibited
        ? l10n.islamicDaysProhibited
        : occurrence.pilgrimRestriction
        ? l10n.islamicDaysPilgrimTitle
        : ramadanOverride
        ? l10n.islamicDaysRamadanOverride
        : occurrence.event.fasting == IslamicDayFasting.obligatory
        ? l10n.islamicDaysObligatory
        : l10n.islamicDaysRecommended;
    final message = prohibited
        ? l10n.islamicDaysBlockedBody
        : occurrence.pilgrimRestriction
        ? l10n.islamicDaysPilgrimBody
        : ramadanOverride
        ? l10n.islamicDaysRamadanOverrideBody
        : null;
    return IslamicDaysSection(
      title: title,
      icon: prohibited ? Icons.no_food_outlined : Icons.nightlight_round,
      color: prohibited ? scheme.error : scheme.tertiary,
      child: message == null
          ? Text(
              islamicDayFastingSummary(context),
              style: AppTheme.text(context).bodyMedium.copyWith(height: 1.55),
            )
          : Text(
              message,
              style: AppTheme.text(context).bodyMedium.copyWith(height: 1.55),
            ),
    );
  }

  String islamicDayFastingSummary(BuildContext context) => occurrence
      .availableActions
      .where((action) => action.fasting)
      .map((action) => action.text.resolve(context.l10n.localeName))
      .join('\n');
}
