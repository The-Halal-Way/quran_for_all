import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/islamic_days/islamic_day_occurrence.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../shared/islamic_days_mutation.dart';
import '../shared/islamic_days_section.dart';
import 'islamic_day_action_tile.dart';

class IslamicDayChecklist extends StatelessWidget {
  const IslamicDayChecklist({super.key, required this.occurrence});
  final IslamicDayOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IslamicDaysViewModel>();
    final actions = occurrence.availableActions;
    final completed = actions
        .where((action) => vm.isCompleted(occurrence.actionKey(action)))
        .length;
    return IslamicDaysSection(
      title: context.l10n.islamicDaysActions,
      subtitle: context.l10n.islamicDaysActionsSubtitle,
      icon: Icons.checklist_rounded,
      child: Column(
        children: [
          if (actions.isNotEmpty) ...[
            LinearProgressIndicator(
              value: completed / actions.length,
              minHeight: 5,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 12),
          ],
          for (final action in actions)
            IslamicDayActionTile(
              text: action.text.resolve(context.l10n.localeName),
              completed: vm.isCompleted(occurrence.actionKey(action)),
              onToggle: () => saveIslamicDaysChange(
                context,
                () => vm.toggleAction(occurrence, action),
              ),
            ),
        ],
      ),
    );
  }
}
