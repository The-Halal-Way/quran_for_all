import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import 'dhikr_reminder_labels.dart';

Future<DhikrReminderSound?> showDhikrSoundSheet(
  BuildContext context,
  DhikrReminderSound current,
) => showModalBottomSheet<DhikrReminderSound>(
  context: context,
  showDragHandle: true,
  useSafeArea: true,
  isScrollControlled: true,
  builder: (_) => _SoundSheet(current: current),
);

class _SoundSheet extends StatefulWidget {
  const _SoundSheet({required this.current});
  final DhikrReminderSound current;

  @override
  State<_SoundSheet> createState() => _SoundSheetState();
}

class _SoundSheetState extends State<_SoundSheet> {
  late DhikrReminderSound _selected = widget.current;
  AudioPlayer? _player;

  Future<void> _preview(DhikrReminderSound sound) async {
    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      if (!mounted) return;
      await player.play(AssetSource(sound.assetPath));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.dhikrPreviewFailed)),
        );
      }
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.dhikrSoundTitle,
            style: AppTheme.text(context).titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(context.l10n.dhikrSoundHelp),
          const SizedBox(height: AppSpacing.md),
          for (final sound in DhikrReminderSound.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Material(
                color: _selected == sound
                    ? scheme.primaryContainer
                    : scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  selected: _selected == sound,
                  leading: Icon(
                    _selected == sound
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(dhikrSoundTitle(context.l10n, sound)),
                  onTap: () => setState(() => _selected = sound),
                  trailing: IconButton(
                    tooltip: context.l10n.dhikrPreview,
                    icon: const Icon(Icons.play_circle_outline_rounded),
                    onPressed: () => _preview(sound),
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: Text(context.l10n.dhikrApply),
          ),
        ],
      ),
    );
  }
}
