# Learn Quran pronunciation audio

## Recorded alphabet

The alphabet buttons use 29 bundled letter-name recordings from **Waikato
Islamic School of Education**, *Lesson 1: The Arabic Alphabet* (2015).

- [Original lesson](https://www.youtube.com/watch?v=0Isyy_ZvZR8)
- [Source and license record on Wikimedia Commons](https://commons.wikimedia.org/wiki/File:The_Arabic_Alphabet-0Isyy_ZvZR8.webm)
- [Creative Commons Attribution 3.0 Unported](https://creativecommons.org/licenses/by/3.0/)

Changes: excerpts from the first alphabet reading, trimmed with a short silence
before and after each letter, converted to mono MP3 at 22.05 kHz / 64 kbit/s.
The recordings retain the original voice, speed and pitch. The files occupy
257,032 bytes in total. No endorsement by the source author is implied.

The first pass of the source lesson visually highlights each letter as it is
read. `learn_quran_audio_sources.json` records those excerpt boundaries, asset
paths and SHA-256 checksums. The video and media tools are not shipped in the app.

## Playback and coverage

`RecordedPronunciationCatalog` maps bare letter symbols to asset paths. Groups
such as `ب / ت / ث` play those recordings in sequence. Tatweel in a display form
such as `هـ` is ignored. Diacritics are preserved: `بَ` does **not** resolve to
the letter-name clip for `ب`.

Other pronunciation exercises (vowel drills, words and phrases) continue using
the device's Arabic text-to-speech voice. Quran verse samples continue using
the existing recitation service. Neither path is replaced with alphabet clips.

`RecordedPronunciationPlayer` creates its native player on the first recording
tap. It reads only the requested asset, supports stop/switch, and reuses the
player. The recordings need no network request or installed TTS voice. App
startup does not preload the clips or initialize the player.

English and Bangla source credits, links, license and edit disclosure appear
under **Alphabet audio** in the Arabic Letters module.

## Changing or extending recordings

1. Put licensed MP3 files in `assets/audio/learn_quran/letters/`, preserving the
   existing filenames to replace the speaker without changing UI code.
2. For a new sound, add an exact matching entry to the catalog. A vowelled sound
   must have its own recording; do not map it to a bare letter name.
3. Keep source, author, license, edit details and any required notices with the
   files. Update the in-app credits and source manifest when changing authors.
4. New directories must also be registered under `flutter.assets` in
   `pubspec.yaml`. A full restart/build is needed after adding asset entries.
