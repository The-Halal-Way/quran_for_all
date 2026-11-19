import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';
import 'dhikr_interval_sheet.dart';
import 'dhikr_reminder_card.dart';
import 'dhikr_sound_sheet.dart';

class DhikrPresetsSection extends StatelessWidget {
  const DhikrPresetsSection({super.key, this.initialKind});
  final DhikrReminderKind? initialKind;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DhikrRemindersViewModel>();
    final order = [
      ?initialKind,
      ...DhikrReminderKind.values.where((kind) => kind != initialKind),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.dhikrPresetReminders,
          style: AppTheme.text(
            context,
          ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final kind in order) ...[
          DhikrReminderCard(
            key: ValueKey(kind),
            kind: kind,
            reminder: vm.reminder(kind),
            busy: vm.busy || !vm.supported,
            highlighted: initialKind == kind,
            onToggle: (enabled) =>
                vm.update(kind, vm.reminder(kind).copyWith(enabled: enabled)),
            onInterval: () async {
              final minutes = await showDhikrIntervalSheet(
                context,
                vm.reminder(kind).intervalMinutes,
              );
              if (minutes != null && context.mounted) {
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
              if (sound != null && context.mounted) {
                await vm.update(kind, vm.reminder(kind).copyWith(sound: sound));
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
      ],
    );
  }
}
