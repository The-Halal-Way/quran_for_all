import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../../services/notifications/app_notification_coordinator.dart';
import '../../../viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';
import '../../../viewmodels/settings_viewmodel.dart';
import '../../../widgets/common/app_language_action_button.dart';
import '../../../widgets/common/app_page_scrollbar.dart';
import '../../../widgets/common/app_premium_page_background.dart';
import '../../../widgets/dhikr_reminders/dhikr_interval_sheet.dart';
import '../../../widgets/dhikr_reminders/dhikr_reminder_card.dart';
import '../../../widgets/dhikr_reminders/dhikr_reminder_labels.dart';
import '../../../widgets/dhikr_reminders/dhikr_sound_sheet.dart';

class DhikrRemindersView extends StatefulWidget {
  const DhikrRemindersView({super.key, this.initialKind});
  final DhikrReminderKind? initialKind;

  @override
  State<DhikrRemindersView> createState() => _DhikrRemindersViewState();
}

class _DhikrRemindersViewState extends State<DhikrRemindersView>
    with WidgetsBindingObserver {
  String? _locale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_locale == context.l10n.localeName) return;
    _locale = context.l10n.localeName;
    _refresh();
  }

  void _refresh() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      context.read<DhikrRemindersViewModel>().configure(
        context.l10n,
        checkPermission: true,
      );
    }
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DhikrRemindersViewModel>();
    final settings = context.watch<SettingsViewModel>();
    final l10n = context.l10n;
    final order = [
      if (widget.initialKind != null) widget.initialKind!,
      ...DhikrReminderKind.values.where((kind) => kind != widget.initialKind),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dhikrRemindersTitle),
        actions: [
          AppLanguageActionButton(
            current: settings.settings.language,
            onSelected: settings.setLanguage,
            tooltip: l10n.settingsLanguagePanelTitle,
          ),
        ],
      ),
      body: AppPremiumPageBackground(
        child: AppPageScrollbar(
          builder: (context, controller) => ListView(
            controller: controller,
            padding: EdgeInsets.all(AppResponsive.of(context).padding),
            children: [
              _Intro(),
              const SizedBox(height: AppSpacing.lg),
              if (vm.busy) const LinearProgressIndicator(),
              if (vm.error != null) ...[
                _Notice(
                  message: dhikrErrorText(l10n, vm.error!),
                  action: vm.error == DhikrReminderError.load
                      ? l10n.quizRetry
                      : null,
                  onAction: () => vm.configure(l10n, checkPermission: true),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (!vm.supported)
                _Notice(message: l10n.dhikrUnsupported)
              else if (vm.permission == AppNotificationPermission.denied) ...[
                _Notice(
                  message: l10n.dhikrPermissionRequired,
                  action: l10n.dhikrNotificationSettings,
                  onAction: vm.openNotificationSettings,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (!vm.ready && vm.error == null)
                const Center(child: CircularProgressIndicator()),
              if (vm.ready)
                for (final kind in order) ...[
                  DhikrReminderCard(
                    key: ValueKey(kind),
                    kind: kind,
                    reminder: vm.reminder(kind),
                    busy: vm.busy || !vm.supported,
                    highlighted: widget.initialKind == kind,
                    onToggle: (enabled) => vm.update(
                      kind,
                      vm.reminder(kind).copyWith(enabled: enabled),
                    ),
                    onInterval: () async {
                      final minutes = await showDhikrIntervalSheet(
                        context,
                        vm.reminder(kind).intervalMinutes,
                      );
                      if (minutes != null && mounted) {
                        await vm.update(
                          kind,
                          vm.reminder(kind).copyWith(intervalMinutes: minutes),
                        );
                      }
                    },
                    onSound: () async {
                      final sound = await showDhikrSoundSheet(
                        context,
                        vm.reminder(kind).sound,
                      );
                      if (sound != null && mounted) {
                        await vm.update(
                          kind,
                          vm.reminder(kind).copyWith(sound: sound),
                        );
                      }
                    },
                    onTest: () async {
                      final sent = await vm.test(kind);
                      if (sent && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.dhikrTestSent)),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              Text(
                l10n.dhikrTimingNotice,
                style: AppTheme.text(context).bodySmall,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF123B43), Color(0xFF353963)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppRadius.xl),
    ),
    child: Row(
      children: [
        const Icon(
          Icons.notifications_active_outlined,
          color: Color(0xFF9ADACD),
          size: 34,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            context.l10n.dhikrRemindersSubtitle,
            style: AppTheme.text(
              context,
            ).bodyLarge.copyWith(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.message, this.action, this.onAction});
  final String message;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    ),
  );
}
