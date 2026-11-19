import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/dhikr_reminders/custom_dhikr_reminder.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../services/dhikr_reminders/dhikr_sound_preview.dart';
import 'dhikr_reminder_labels.dart';
import 'dhikr_sound_preview_button.dart';

class CustomReminderFields extends StatelessWidget {
  const CustomReminderFields({
    super.key,
    required this.title,
    required this.subtitle,
    required this.settings,
    required this.preview,
    required this.busy,
    required this.onChanged,
    required this.onEnabled,
    required this.onInterval,
    required this.onSound,
  });
  final TextEditingController title, subtitle;
  final DhikrReminder settings;
  final DhikrSoundPreview preview;
  final bool busy;
  final VoidCallback onChanged, onInterval, onSound;
  final ValueChanged<bool> onEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const ValueKey('custom-reminder-title'),
          controller: title,
          enabled: !busy,
          maxLength: CustomDhikrReminder.maxTitleLength,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          textInputAction: TextInputAction.next,
          onChanged: (_) => onChanged(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: l10n.dhikrCustomTitle,
            hintText: l10n.dhikrCustomTitleHint,
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? l10n.dhikrCustomTitleRequired
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          key: const ValueKey('custom-reminder-subtitle'),
          controller: subtitle,
          enabled: !busy,
          maxLength: CustomDhikrReminder.maxSubtitleLength,
          minLines: 2,
          maxLines: 4,
          onChanged: (_) => onChanged(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            labelText: l10n.dhikrCustomSubtitle,
            hintText: l10n.dhikrCustomSubtitleHint,
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: Text(l10n.dhikrIntervalTitle),
                subtitle: Text(
                  l10n.dhikrEveryMinutes(
                    NumberFormat.decimalPattern(
                      l10n.localeName,
                    ).format(settings.intervalMinutes),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: busy ? null : onInterval,
              ),
              const Divider(
                height: 1,
                indent: AppSpacing.lg,
                endIndent: AppSpacing.lg,
              ),
              ListTile(
                leading: const Icon(Icons.music_note_outlined),
                title: Text(l10n.dhikrSoundTitle),
                subtitle: Text(dhikrSoundTitle(l10n, settings.sound)),
                trailing: busy
                    ? null
                    : DhikrSoundPreviewButton(
                        preview: preview,
                        sound: settings.sound,
                      ),
                onTap: busy ? null : onSound,
              ),
              SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                title: Text(l10n.dhikrEnableReminder),
                value: settings.enabled,
                onChanged: busy ? null : onEnabled,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
