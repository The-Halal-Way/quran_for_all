import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../data/models/islamic_days/islamic_days_preferences.dart';
import '../../../../services/notifications/app_notification_coordinator.dart';
import '../../../viewmodels/islamic_days/islamic_days_viewmodel.dart';
import '../shared/islamic_days_action_card.dart';
import '../shared/islamic_days_mutation.dart';

class IslamicDaysNotificationPanel extends StatelessWidget {
  const IslamicDaysNotificationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IslamicDaysViewModel>();
    final preferences = vm.preferences;
    final l10n = context.l10n;
    final available =
        vm.permission != AppNotificationPermission.unsupported &&
        vm.ready &&
        !vm.isLoading;
    void update(IslamicDaysPreferences value) =>
        saveIslamicDaysChange(context, () => vm.updatePreferences(value));
    return Column(
      children: [
        IslamicDaysActionCard(
          title: l10n.islamicDaysNotify,
          subtitle: l10n.islamicDaysNotifyBody,
          icon: Icons.notifications_active_outlined,
          trailing: Switch.adaptive(
            value: preferences.notificationsEnabled,
            onChanged: available && !vm.savingPreferences
                ? (value) =>
                      update(preferences.copyWith(notificationsEnabled: value))
                : null,
          ),
        ),
        const SizedBox(height: 12),
        IslamicDaysActionCard(
          title: l10n.islamicDaysReminderTime,
          icon: Icons.wb_sunny_outlined,
          trailing: Text(
            TimeOfDay(
              hour: preferences.hour,
              minute: preferences.minute,
            ).format(context),
          ),
          onTap: !vm.ready || vm.isLoading || vm.savingPreferences
              ? null
              : () => _chooseTime(context, vm, preparation: false),
        ),
        const SizedBox(height: 12),
        IslamicDaysActionCard(
          title: l10n.islamicDaysPreparation,
          subtitle: l10n.islamicDaysPreparationBody,
          icon: Icons.nights_stay_outlined,
          trailing: Switch.adaptive(
            value: preferences.preparationEnabled,
            onChanged: available && !vm.savingPreferences
                ? (value) =>
                      update(preferences.copyWith(preparationEnabled: value))
                : null,
          ),
        ),
        if (preferences.preparationEnabled) ...[
          const SizedBox(height: 12),
          IslamicDaysActionCard(
            title: l10n.islamicDaysPreparationTime,
            icon: Icons.schedule_rounded,
            trailing: Text(
              TimeOfDay(
                hour: preferences.preparationHour,
                minute: preferences.preparationMinute,
              ).format(context),
            ),
            onTap: !vm.ready || vm.isLoading || vm.savingPreferences
                ? null
                : () => _chooseTime(context, vm, preparation: true),
          ),
        ],
      ],
    );
  }

  Future<void> _chooseTime(
    BuildContext context,
    IslamicDaysViewModel vm, {
    required bool preparation,
  }) async {
    final preferences = vm.preferences;
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: preparation ? preferences.preparationHour : preferences.hour,
        minute: preparation
            ? preferences.preparationMinute
            : preferences.minute,
      ),
    );
    if (selected == null || !context.mounted) return;
    await saveIslamicDaysChange(
      context,
      () => vm.updatePreferences(
        preparation
            ? vm.preferences.copyWith(
                preparationHour: selected.hour,
                preparationMinute: selected.minute,
              )
            : vm.preferences.copyWith(
                hour: selected.hour,
                minute: selected.minute,
              ),
      ),
    );
  }
}
