import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../../viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';

String dhikrReminderTitle(AppLocalizations l10n, DhikrReminderKind kind) =>
    switch (kind) {
      DhikrReminderKind.durud => l10n.dhikrDurudTitle,
      DhikrReminderKind.istighfar => l10n.dhikrIstighfarTitle,
    };

String dhikrSoundTitle(AppLocalizations l10n, DhikrReminderSound sound) =>
    switch (sound) {
      DhikrReminderSound.glass => l10n.dhikrSoundGlass,
      DhikrReminderSound.bell => l10n.dhikrSoundBell,
      DhikrReminderSound.chime => l10n.dhikrSoundChime,
    };

String dhikrErrorText(AppLocalizations l10n, DhikrReminderError error) =>
    switch (error) {
      DhikrReminderError.load => l10n.dhikrLoadFailed,
      DhikrReminderError.save => l10n.dhikrSaveFailed,
      DhikrReminderError.permission => l10n.dhikrPermissionRequired,
      DhikrReminderError.unsupported => l10n.dhikrUnsupported,
      DhikrReminderError.test => l10n.dhikrTestFailed,
    };
