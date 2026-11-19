import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../services/dhikr_reminders/dhikr_sound_preview.dart';

class DhikrSoundPreviewButton extends StatelessWidget {
  const DhikrSoundPreviewButton({
    super.key,
    required this.preview,
    required this.sound,
  });
  final DhikrSoundPreview preview;
  final DhikrReminderSound sound;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: preview,
    builder: (context, _) {
      final active = preview.activeSound == sound;
      return IconButton(
        color: Theme.of(context).colorScheme.onSurface,
        tooltip: active
            ? context.l10n.dhikrStopPreview
            : context.l10n.dhikrPreview,
        onPressed: () => preview.toggle(sound),
        icon: active && preview.loading
            ? SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            : Icon(
                active
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outline_rounded,
              ),
      );
    },
  );
}
