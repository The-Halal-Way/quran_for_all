import '../../../data/models/dhikr_reminders/dhikr_reminder.dart';
import '../../../l10n/app_localizations.dart';
import '../../viewmodels/dhikr_reminders/dhikr_reminders_viewmodel.dart';

String dhikrReminderTitle(AppLocalizations l10n, DhikrReminderKind kind) =>
    switch (kind) {
      DhikrReminderKind.durud => l10n.dhikrDurudTitle,
      DhikrReminderKind.istighfar => l10n.dhikrIstighfarTitle,
    };

String dhikrSoundTitle(AppLocalizations l10n, DhikrReminderSound sound) =>
    l10n.dhikrSoundName(sound.name);

String dhikrErrorText(AppLocalizations l10n, DhikrReminderError error) =>
    switch (error) {
      DhikrReminderError.load => l10n.dhikrLoadFailed,
      DhikrReminderError.save => l10n.dhikrSaveFailed,
      DhikrReminderError.permission => l10n.dhikrPermissionRequired,
      DhikrReminderError.unsupported => l10n.dhikrUnsupported,
      DhikrReminderError.test => l10n.dhikrTestFailed,
      DhikrReminderError.capacity => l10n.dhikrScheduleCapacity,
    };
