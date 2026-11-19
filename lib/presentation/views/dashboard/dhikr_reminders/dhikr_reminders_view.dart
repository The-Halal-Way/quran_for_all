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
import '../../../widgets/dhikr_reminders/custom_dhikr_reminders_section.dart';
import '../../../widgets/dhikr_reminders/dhikr_presets_section.dart';
import '../../../widgets/dhikr_reminders/dhikr_reminder_labels.dart';
import '../../../widgets/dhikr_reminders/dhikr_reminders_intro.dart';
import '../../../widgets/dhikr_reminders/dhikr_reminders_notice.dart';

class DhikrRemindersView extends StatefulWidget {
  const DhikrRemindersView({super.key, this.initialKind, this.initialCustomId});
  final DhikrReminderKind? initialKind;
  final int? initialCustomId;

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
              const DhikrRemindersIntro(),
              const SizedBox(height: AppSpacing.lg),
              if (vm.busy) const LinearProgressIndicator(),
              if (vm.error != null) ...[
                DhikrRemindersNotice(
                  message: dhikrErrorText(l10n, vm.error!),
                  action: vm.error == DhikrReminderError.load
                      ? l10n.quizRetry
                      : null,
                  onAction: () => vm.configure(l10n, checkPermission: true),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (!vm.supported)
                DhikrRemindersNotice(message: l10n.dhikrUnsupported)
              else if (vm.permission == AppNotificationPermission.denied) ...[
                DhikrRemindersNotice(
                  message: l10n.dhikrPermissionRequired,
                  action: l10n.dhikrNotificationSettings,
                  onAction: vm.openNotificationSettings,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (!vm.ready && vm.error == null)
                const Center(child: CircularProgressIndicator()),
              if (vm.ready) ...[
                CustomDhikrRemindersSection(initialId: widget.initialCustomId),
                const SizedBox(height: AppSpacing.xxl),
                DhikrPresetsSection(initialKind: widget.initialKind),
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
