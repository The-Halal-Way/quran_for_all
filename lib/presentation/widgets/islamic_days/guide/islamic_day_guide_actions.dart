import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/utils/app_page_route.dart';
import '../../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../../views/islamic_days/islamic_days_preferences_view.dart';
import '../shared/islamic_days_action_card.dart';
import '../shared/islamic_days_mutation.dart';

class IslamicDayGuideActions extends StatelessWidget {
  const IslamicDayGuideActions({super.key, required this.occurrence});
  final IslamicDayOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IslamicDaysViewModel>();
    final tracked = vm.isTracked(occurrence);
    return Column(
      children: [
        IslamicDaysActionCard(
          title: tracked
              ? context.l10n.islamicDaysAlreadyTracked
              : occurrence.event.actionLabel?.resolve(
                      context.l10n.localeName,
                    ) ??
                    context.l10n.islamicDaysAddChecklist,
          icon: tracked
              ? Icons.check_circle_outline_rounded
              : Icons.playlist_add_rounded,
          onTap: tracked
              ? null
              : () => saveIslamicDaysChange(
                  context,
                  () => vm.addToTracker(occurrence),
                  success: context.l10n.islamicDaysChecklistAdded,
                ),
          trailing: tracked ? const Icon(Icons.check_rounded) : null,
        ),
        const SizedBox(height: 12),
        IslamicDaysActionCard(
          title: context.l10n.islamicDaysPreferences,
          icon: Icons.notifications_active_outlined,
          onTap: () => Navigator.of(context).push(
            AppPageRoute<void>(
              builder: (_) => const IslamicDaysPreferencesView(),
            ),
          ),
        ),
      ],
    );
  }
}
