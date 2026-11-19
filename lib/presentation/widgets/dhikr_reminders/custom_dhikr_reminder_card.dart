import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import 'dhikr_reminder_labels.dart';

class CustomDhikrReminderCard extends StatelessWidget {
  const CustomDhikrReminderCard({
    super.key,
    required this.reminder,
    required this.busy,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onTest,
    this.highlighted = false,
  });
  final CustomDhikrReminder reminder;
  final bool busy, highlighted;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit, onDelete, onTest;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: scheme.primary.withValues(alpha: highlighted ? .65 : .2),
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.edit_notifications_outlined, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  reminder.title,
                  style: text.titleSmall.copyWith(
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
              Switch.adaptive(
                value: reminder.settings.enabled,
                onChanged: busy ? null : onToggle,
              ),
            ],
          ),
          if (reminder.subtitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(reminder.subtitle, style: text.bodyMedium),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.dhikrEveryMinutes(
              NumberFormat.decimalPattern(
                l10n.localeName,
              ).format(reminder.settings.intervalMinutes),
            ),
            style: text.labelMedium.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            dhikrSoundTitle(l10n, reminder.settings.sound),
            style: text.bodySmall.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: busy ? null : onTest,
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      size: 18,
                    ),
                    label: Text(l10n.dhikrTestNotification),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                enabled: !busy,
                onSelected: (action) =>
                    action == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(l10n.dhikrEditAction),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.dhikrDeleteAction),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
