import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import 'dhikr_reminder_labels.dart';

class DhikrReminderCard extends StatelessWidget {
  const DhikrReminderCard({
    super.key,
    required this.kind,
    required this.reminder,
    required this.busy,
    required this.onToggle,
    required this.onInterval,
    required this.onSound,
    required this.onTest,
    this.highlighted = false,
  });

  final DhikrReminderKind kind;
  final DhikrReminder reminder;
  final bool busy, highlighted;
  final ValueChanged<bool> onToggle;
  final VoidCallback onInterval, onSound, onTest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    final durud = kind == DhikrReminderKind.durud;
    final base = durud ? const Color(0xFF177A6B) : const Color(0xFF5263A7);
    final accent = Theme.of(context).brightness == Brightness.dark
        ? Color.lerp(base, Colors.white, .4)!
        : base;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            Color.alphaBlend(accent.withValues(alpha: .1), scheme.surface),
            scheme.surface,
          ],
        ),
        border: Border.all(
          color: accent.withValues(alpha: highlighted ? .65 : .24),
          width: highlighted ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  durud ? Icons.favorite_outline_rounded : Icons.spa_outlined,
                  color: accent,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  dhikrReminderTitle(l10n, kind),
                  style: text.titleLarge.copyWith(
                    fontWeight: AppTheme.weightBold,
                  ),
                ),
              ),
              Semantics(
                label: dhikrReminderTitle(l10n, kind),
                child: Switch.adaptive(
                  value: reminder.enabled,
                  onChanged: busy ? null : onToggle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            durud ? 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ' : 'أَسْتَغْفِرُ اللَّهَ',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 30,
              color: accent,
              height: 1.7,
            ),
          ),
          Text(
            durud ? l10n.dhikrDurudDescription : l10n.dhikrIstighfarDescription,
            textAlign: TextAlign.center,
            style: text.bodySmall.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingRow(
            icon: Icons.timer_outlined,
            label: l10n.dhikrIntervalTitle,
            value: l10n.dhikrEveryMinutes(
              NumberFormat.decimalPattern(
                l10n.localeName,
              ).format(reminder.intervalMinutes),
            ),
            onTap: busy ? null : onInterval,
          ),
          const SizedBox(height: AppSpacing.xs),
          _SettingRow(
            icon: Icons.music_note_outlined,
            label: l10n.dhikrSoundTitle,
            value: dhikrSoundTitle(l10n, reminder.sound),
            onTap: busy ? null : onSound,
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: busy ? null : onTest,
              icon: const Icon(Icons.notifications_active_outlined, size: 18),
              label: Text(l10n.dhikrTestNotification),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });
  final IconData icon;
  final String label, value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(AppRadius.md),
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      leading: Icon(icon),
      title: Text(label, style: AppTheme.text(context).labelSmall),
      subtitle: Text(
        value,
        style: AppTheme.text(
          context,
        ).bodyMedium.copyWith(fontWeight: AppTheme.weightBold),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    ),
  );
}
