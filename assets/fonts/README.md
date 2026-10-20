# Bundled app fonts

Manrope, Sora, and Amiri are bundled so the app never downloads fonts at launch.
These files match the variants used by `google_fonts` 6.3.3. Families and weights
are registered in `pubspec.yaml` and used directly by `AppTheme`, avoiding runtime
FontLoader calls and font-related relayouts during startup.

Each family includes its SIL Open Font License in the corresponding `*-OFL.txt`.
Sources: https://fonts.google.com/specimen/Manrope,
https://fonts.google.com/specimen/Sora, https://fonts.google.com/specimen/Amiri.

App code uses registered font families directly; there is no runtime font
fetching or `google_fonts` initialization at launch.
