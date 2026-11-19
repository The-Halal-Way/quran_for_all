import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../services/dhikr_reminders/dhikr_sound_preview.dart';
import 'dhikr_reminder_labels.dart';
import 'dhikr_sound_preview_button.dart';

Future<DhikrReminderSound?> showDhikrSoundSheet(
  BuildContext context,
  DhikrReminderSound current, {
  DhikrSoundPreview? preview,
}) => showModalBottomSheet<DhikrReminderSound>(
  context: context,
  showDragHandle: true,
  useSafeArea: true,
  isScrollControlled: true,
  builder: (_) => DhikrSoundPicker(current: current, preview: preview),
);

class DhikrSoundPicker extends StatefulWidget {
  const DhikrSoundPicker({super.key, required this.current, this.preview});
  final DhikrReminderSound current;
  final DhikrSoundPreview? preview;

  @override
  State<DhikrSoundPicker> createState() => _DhikrSoundPickerState();
}

class _DhikrSoundPickerState extends State<DhikrSoundPicker> {
  late DhikrReminderSound _selected = widget.current;
  late final _preview = widget.preview ?? DhikrSoundPreview();

  @override
  void dispose() {
    if (widget.preview == null) {
      _preview.dispose();
    } else {
      // The editor owns this player; teardown must not rebuild its listeners.
      unawaited(_preview.stop(notify: false));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (didPop, _) {
      if (didPop) unawaited(_preview.stop());
    },
    child: FractionallySizedBox(
      heightFactor: .85,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.dhikrSoundTitle,
              style: AppTheme.text(context).titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(context.l10n.dhikrSoundHelp),
            AnimatedBuilder(
              animation: _preview,
              builder: (context, _) => _preview.failed
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        context.l10n.dhikrPreviewFailed,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.separated(
                itemCount: DhikrReminderSound.values.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final sound = DhikrReminderSound.values[index];
                  final selected = _selected == sound;
                  final scheme = Theme.of(context).colorScheme;
                  return Material(
                    color: selected
                        ? scheme.primaryContainer
                        : scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      selected: selected,
                      leading: Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(dhikrSoundTitle(context.l10n, sound)),
                      onTap: () async {
                        await _preview.stop();
                        if (mounted) setState(() => _selected = sound);
                      },
                      trailing: DhikrSoundPreviewButton(
                        preview: _preview,
                        sound: sound,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () async {
                await _preview.stop();
                if (context.mounted) Navigator.pop(context, _selected);
              },
              child: Text(context.l10n.dhikrApply),
            ),
          ],
        ),
      ),
    ),
  );
}
