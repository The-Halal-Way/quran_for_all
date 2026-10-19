# Bundled app fonts

Manrope, Sora, and Amiri are bundled so the app never downloads fonts at launch.
These files match the variants used by `google_fonts` 6.3.3. Keep their names:
the package resolves bundled fonts using the family and variant filename.

Each family includes its SIL Open Font License in the corresponding `*-OFL.txt`.
Sources: https://fonts.google.com/specimen/Manrope,
https://fonts.google.com/specimen/Sora, https://fonts.google.com/specimen/Amiri.

Runtime font fetching is disabled in `lib/main.dart`.
