# Lazy Android speech engine

This is the runtime source of `flutter_tts` 4.2.5, copied from the published
package at https://pub.dev/packages/flutter_tts/versions/4.2.5. Its upstream
license is retained in `LICENSE`. Examples and generated build files are omitted.

Only `android/src/main/kotlin/com/eyedeadevelopment/fluttertts/FlutterTtsPlugin.kt`
is patched:

- Register the method channel without constructing Android `TextToSpeech`.
- Construct the engine on the first method call that needs it. Existing pending
  method handling waits for initialization, preserving the public Dart API.
- A stop request or engine detach before first use does not create TTS.
- Ignore initialization callbacks after detach and allow null-safe teardown.

The unmodified plugin initializes speech on engine attachment even when no Dart
speech service has been created. Android startup sampling on the development
emulator measured approximately 195 ms in its initialization callback on the
platform main thread. This patch moves that work to actual pronunciation use.

The app uses a path dependency override so `flutter pub get` and full rebuilds
retain the fix. When upgrading, compare this file against upstream and remove
the override when upstream provides lazy initialization. Other platform sources
and the Dart API are unchanged.
