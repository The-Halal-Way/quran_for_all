# Demo notification sounds

Source: **Interface Sounds 1.0**, created/distributed by Kenney (www.kenney.nl).

- Original pack: https://kenney.nl/assets/interface-sounds
- Author's mirror: https://opengameart.org/content/interface-sounds
- Download: https://opengameart.org/sites/default/files/kenney_interfaceSounds.zip
- License: Creative Commons Zero (CC0 1.0 Universal)
- License URL: https://creativecommons.org/publicdomain/zero/1.0/

| App file | Original pack file |
| --- | --- |
| reminder_glass.wav | Audio/glass_001.ogg |
| reminder_bell.wav | Audio/bong_001.ogg |
| reminder_chime.wav | Audio/confirmation_001.ogg |

Converted to 16-bit PCM WAV at the original 44.1 kHz. Each is shorter than one second.
These are demo alert tones, not recordings of Durud or Istighfar.

Identical copies live in Android `res/raw` and iOS Runner resources, because
native notification delivery cannot play a Flutter asset directly when the
app is terminated. Keep those copies in sync when replacing a sound.
For Android, increment the channel suffix in `DhikrReminderService` when
replacing an existing sound: a channel retains its original sound settings.
