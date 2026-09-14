import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../models/daily_reminder_presenter.dart';
import '../../viewmodels/daily_reminders/daily_reminders_viewmodel.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/daily_reminders/daily_reminder_preferences/daily_reminder_delivery_note.dart';
import '../../widgets/daily_reminders/daily_reminder_preferences/daily_reminder_permission_badge.dart';
import '../../widgets/daily_reminders/daily_reminder_preferences/daily_reminder_preference_panel.dart';

class DailyReminderPreferencesView extends StatelessWidget {
  const DailyReminderPreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyRemindersViewModel>();
    final preferences = vm.preferences;
    final l10n = context.l10n;
    final responsive = AppResponsive.of(context);
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
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l10n.dailyRemindersPreferencesTitle,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    DailyReminderDeliveryNote(
                      title: l10n.dailyRemindersInAppDeliveryTitle,
                      message: l10n.dailyRemindersInAppDeliveryMessage,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DailyReminderPreferencePanel(
                      icon: Icons.notifications_active_outlined,
                      title: l10n.dailyRemindersNotifyToggle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.dailyRemindersNotifySubtitle),
                            value: preferences.notificationsEnabled,
                            onChanged: vm.setNotificationsEnabled,
                          ),
                          if (preferences.notificationsEnabled) ...[
                            const Divider(),
                            const SizedBox(height: AppSpacing.sm),
                            Text(l10n.dailyRemindersPermission),
                            const SizedBox(height: AppSpacing.sm),
                            DailyReminderPermissionBadge(
                              status: vm.permissionStatus,
                              l10n: l10n,
                            ),
                          ],
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: preferences.notificationsEnabled
                          ? Column(
                              key: const ValueKey('notification-options'),
                              children: [
                                const SizedBox(height: AppSpacing.md),
                                DailyReminderPreferencePanel(
                                  icon: Icons.schedule_rounded,
                                  title: l10n.dailyRemindersPreferredTime,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      TimeOfDay(
                                        hour: preferences.hour,
                                        minute: preferences.minute,
                                      ).format(context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    trailing: const Icon(
                                      Icons.edit_calendar_rounded,
                                    ),
                                    onTap: () => _pickTime(context, vm),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                DailyReminderPreferencePanel(
                                  icon: Icons.category_outlined,
                                  title: l10n.dailyRemindersCategories,
                                  child: Column(
                                    children: vm.availableKinds.map((kind) {
                                      return CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        secondary: Icon(
                                          dailyReminderKindIcon(kind),
                                        ),
                                        title: Text(
                                          dailyReminderKindLabel(l10n, kind),
                                        ),
                                        value: preferences.enabledKinds
                                            .contains(kind),
                                        onChanged: (enabled) =>
                                            vm.setKindEnabled(
                                              kind,
                                              enabled ?? false,
                                            ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('notifications-off'),
                            ),
                    ),
                    if (preferences.notificationsEnabled) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.dailyRemindersNotificationPolicy,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    DailyRemindersViewModel vm,
  ) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: vm.preferences.hour,
        minute: vm.preferences.minute,
      ),
    );
    if (selected != null) {
      await vm.setReminderTime(selected.hour, selected.minute);
    }
  }
}
