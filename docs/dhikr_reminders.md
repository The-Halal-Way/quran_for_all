# Dhikr and custom reminders

Durud and Istighfar remain presets. The reminder page also supports creating,
editing, enabling/disabling, testing and deleting personal reminders. Custom
titles and optional subtitles are stored exactly as entered after trimming
outer whitespace; changing the app language does not translate them.

The editor updates its notification preview on every title/subtitle change.
It uses the selected sound's play/stop control. The appearance is illustrative;
the native test notification shows the actual device presentation.

## Persistence and delivery

- Presets retain the existing `dhikr_reminders_v1` preference key.
- Custom records and the monotonically increasing ID counter use
  `custom_dhikr_reminders_v1`. Deleted IDs are not reused.
- Each custom reminder owns separate recurring and test notification IDs in
  the 1500100000–1599999999 range, separate from the two presets and other
  notification features.
- Enabling requests notification permission. Disabled records can be saved
  without permission. A failed save restores the previous native schedule.
- Native repeating requests continue with the app closed. Reopening retains
  their countdown when the payload is unchanged. Revoked permission cancels
  pending delivery while retaining the saved enabled preference for recovery.
- Android channels are version 2, shared by sound and reminder group. Old
  demo sound preferences migrate to the new catalog. iOS capacity is checked
  before adding another request to avoid displacing other scheduled alerts.
- Notification taps route to the correct preset or highlight the matching
  custom reminder. Deletion cancels both recurring and test notifications.

## Audio

The eleven supplied PCM WAV files are shared by both reminder types. Identical
copies are bundled for Flutter previews and native Android/iOS delivery.
See `assets/audio/reminders/README.md` for replacement instructions. New native
resources require a full app rebuild.

`DhikrSoundPreview` lazily creates one audio player and serializes native
commands. Switching, stopping, completion, app suspension and closing clean up
playback. The editor and its sound picker share that player; there is no
background timer or startup audio loading.

## Validation

Scoped tests cover migration, scheduling and permission changes, persistence
rollback, ID allocation, iOS capacity, live preview and editing/deletion,
sound selection and lifecycle, English/Bangla layouts with large text and the
keyboard, WAV integrity and byte-identical native resources.
