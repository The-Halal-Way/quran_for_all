import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_hadith_viewmodel.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_responsive.dart';
import '../../models/daily_hadith_presenter.dart';
import '../../widgets/common/app_ios_picker.dart';
import '../../widgets/common/app_premium_page_background.dart';
import '../../widgets/daily_hadith/daily_hadith_preferences/daily_hadith_delivery_note.dart';
import '../../widgets/daily_hadith/daily_hadith_preferences/daily_hadith_permission_badge.dart';
import '../../widgets/daily_hadith/daily_hadith_preferences/daily_hadith_preference_panel.dart';

class DailyHadithPreferencesView extends StatelessWidget {
  const DailyHadithPreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyHadithViewModel>();
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
                          icon: const Icon(CupertinoIcons.chevron_back),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l10n.dailyHadithPreferencesTitle,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    DailyHadithDeliveryNote(
                      title: l10n.dailyHadithInAppDeliveryTitle,
                      message: l10n.dailyHadithInAppDeliveryMessage,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DailyHadithPreferencePanel(
                      icon: CupertinoIcons.bell,
                      title: l10n.dailyHadithNotifyToggle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.dailyHadithNotifySubtitle),
                            value: preferences.notificationsEnabled,
                            onChanged: vm.setNotificationsEnabled,
                          ),
                          if (preferences.notificationsEnabled) ...[
                            const Divider(),
                            const SizedBox(height: AppSpacing.sm),
                            Text(l10n.dailyHadithPermission),
                            const SizedBox(height: AppSpacing.sm),
                            DailyHadithPermissionBadge(
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
                                DailyHadithPreferencePanel(
                                  icon: CupertinoIcons.clock,
                                  title: l10n.dailyHadithPreferredTime,
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
                                      CupertinoIcons.clock_fill,
                                    ),
                                    onTap: () => _pickTime(context, vm),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                DailyHadithPreferencePanel(
                                  icon: CupertinoIcons.square_grid_2x2,
                                  title: l10n.dailyHadithCategories,
                                  child: Column(
                                    children: vm.availableKinds.map((kind) {
                                      return CheckboxListTile(
                                        contentPadding: EdgeInsets.zero,
                                        secondary: Icon(
                                          dailyHadithKindIcon(kind),
                                        ),
                                        title: Text(
                                          dailyHadithKindLabel(l10n, kind),
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
                        l10n.dailyHadithNotificationPolicy,
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

  Future<void> _pickTime(BuildContext context, DailyHadithViewModel vm) async {
    final selected = await showAppTimePicker(
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
