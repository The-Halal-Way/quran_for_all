# Reminder sounds

The eleven user-supplied notification recordings replace the three demo tones.
All are mono, 16-bit PCM WAV. Durations range from 8.96 to 29.9 seconds, below
the iOS custom notification sound limit of 30 seconds. The supplied audio is
kept unchanged.

`DhikrReminderSound` is the sound catalog. Both presets and custom reminders
use this same catalog. The picker and notification preview share a player
that stops on switching, closing or leaving the app.

Keep identical copies in:

- `assets/audio/reminders/` for in-app playback
- `android/app/src/main/res/raw/` for native notifications
- `ios/Runner/ReminderSounds/` for native notifications

Register new files in the iOS Runner Resources build phase and Android raw
keep list. Native notifications cannot use Flutter asset paths directly.
Increment the channel version in `DhikrReminderService` when replacing audio
under an existing sound name, because Android retains channel sound settings.
Legacy glass/bell/chime preferences migrate to Ar-Rahman/Ramadan/Rahman.
