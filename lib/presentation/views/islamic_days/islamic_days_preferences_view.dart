import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../../widgets/islamic_days/preferences/islamic_days_category_preferences.dart';
import '../../widgets/islamic_days/preferences/islamic_days_notification_panel.dart';
import '../../widgets/islamic_days/preferences/islamic_days_notification_status.dart';
import '../../widgets/islamic_days/shared/islamic_days_action_card.dart';
import '../../widgets/islamic_days/shared/islamic_days_calendar_note.dart';
import '../../widgets/islamic_days/shared/islamic_days_mutation.dart';
import '../../widgets/islamic_days/shared/islamic_days_page_shell.dart';

class IslamicDaysPreferencesView extends StatelessWidget {
  const IslamicDaysPreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IslamicDaysViewModel>();
    final l10n = context.l10n;
    return IslamicDaysPageShell(
      title: l10n.islamicDaysPreferences,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.islamicDaysTitle,
            style: AppTheme.text(context).headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.islamicDaysNotificationPolicy,
            style: AppTheme.text(context).bodyMedium.copyWith(height: 1.6),
          ),
          const SizedBox(height: 22),
          const IslamicDaysNotificationPanel(),
          const SizedBox(height: 18),
          const IslamicDaysCategoryPreferences(),
          const SizedBox(height: 18),
          IslamicDaysActionCard(
            title: l10n.islamicDaysHajj,
            subtitle: l10n.islamicDaysHajjBody,
            icon: Icons.mosque_outlined,
            trailing: Switch.adaptive(
              value: vm.preferences.isOnHajj,
              onChanged: !vm.ready || vm.isLoading || vm.savingPreferences
                  ? null
                  : (value) => saveIslamicDaysChange(
                      context,
                      () => vm.updatePreferences(
                        vm.preferences.copyWith(isOnHajj: value),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          const IslamicDaysNotificationStatus(),
          const SizedBox(height: 18),
          const IslamicDaysCalendarNote(),
        ],
      ),
    );
  }
}
