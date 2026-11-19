import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_page_route.dart';
import '../../../data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import '../../viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';
import '../../views/dashboard/dhikr_reminders/custom_dhikr_reminder_editor_view.dart';
import 'custom_dhikr_reminder_card.dart';

class CustomDhikrRemindersSection extends StatelessWidget {
  const CustomDhikrRemindersSection({super.key, this.initialId});
  final int? initialId;

  void _edit(BuildContext context, [CustomDhikrReminder? reminder]) =>
      Navigator.of(context).push(
        AppPageRoute<bool>(
          builder: (_) => CustomDhikrReminderEditorView(reminder: reminder),
        ),
      );

  Future<void> _delete(
    BuildContext context,
    CustomDhikrReminder reminder,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dhikrDeleteCustom),
        content: Text(l10n.dhikrDeleteCustomBody(reminder.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.dhikrCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.dhikrDeleteAction,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<DhikrRemindersViewModel>().deleteCustom(reminder.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DhikrRemindersViewModel>();
    final l10n = context.l10n;
    final busy = vm.busy;
    final order = [
      ...vm.customReminders.where((item) => item.id == initialId),
      ...vm.customReminders.reversed.where((item) => item.id != initialId),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.dhikrCustomReminders,
                style: AppTheme.text(
                  context,
                ).titleSmall.copyWith(fontWeight: AppTheme.weightBold),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: busy ? null : () => _edit(context),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.dhikrAddCustom),
                ),
              ),
            ),
          ],
        ),
        if (order.isEmpty)
          Card(
            margin: EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              onTap: busy ? null : () => _edit(context),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.dhikrCustomEmpty,
                  style: AppTheme.text(context).bodyMedium,
                ),
              ),
            ),
          ),
        for (final item in order)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: CustomDhikrReminderCard(
              key: ValueKey('custom-reminder-${item.id}'),
              reminder: item,
              highlighted: initialId == item.id,
              busy: busy || !vm.supported,
              onToggle: (enabled) => vm.saveCustom(
                id: item.id,
                title: item.title,
                subtitle: item.subtitle,
                settings: item.settings.copyWith(enabled: enabled),
              ),
              onEdit: () => _edit(context, item),
              onDelete: () => _delete(context, item),
              onTest: () async {
                final sent = await vm.testCustom(item.id);
                if (sent && context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.dhikrTestSent)));
                }
              },
            ),
          ),
      ],
    );
  }
}
