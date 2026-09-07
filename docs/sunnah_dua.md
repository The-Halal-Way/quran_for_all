# Sunnah Dua

The hub has two independent searches: collections and daily practices. The daily
catalog follows morning, daytime and evening, with 22 practices from waking to
sleeping. Situational duas and voluntary fasting live in the shortcut carousel.

## Adding a language

1. Copy `lib/l10n/app_en.arb` to `lib/l10n/app_<locale>.arb`.
2. Set `@@locale` to the new locale and `languageNativeName` to its native name.
3. Translate the values, including the `sunnahDua*`, `sunnahRoutine*` and
   `sunnahRecitation*` entries. Keep the keys and placeholders unchanged. Keep
   Arabic recitations unchanged; translate their pronunciation and meaning.
   `PointsRaw` entries use `||` to separate individual practice points.
4. Run `flutter gen-l10n` and rebuild the app.

The generated locale is automatically included in the app language picker and
can be saved in settings. No Sunnah catalog mappings, language enum cases or
widget changes are needed. The catalog uses generated getters, so missing keys
use Flutter's template-language fallback.

This applies to the Sunnah hub and its detail sheets. The existing Daily Du'a,
Powerful Du'a and 99 Names readers have separate legacy content-localization
systems; adding an ARB file does not translate those datasets.

## Structure

- `domain/entities/sunnah_dua`: content and day phases, without Flutter types.
- `domain/repositories/sunnah_dua_repository.dart`: catalog contract.
- `domain/usecases/sunnah_dua`: locale-independent search, including Arabic mark
  normalization that preserves Bengali vowel signs.
- `data/datasources/local/sunnah_dua`: localized catalogs split by day phase and
  collections; all reading text comes from ARB getters.
- `data/repositories/sunnah_dua_repository_impl.dart`: immutable catalog assembly.
- `presentation/models/sunnah_dua*`: visual mapping and shortcut destinations.
- `presentation/viewmodels/sunnah_dua_viewmodel.dart`: independent query state.
- `presentation/widgets/sunnah_dua/sunnah_dua_view`: hub widgets, one per file.
- `presentation/widgets/sunnah_dua/sunnah_dua_detail`: detail-sheet widgets.

The screen composes the localized repository and refreshes it when the app locale
changes. Content IDs remain stable across languages; searches do not reorder the
routine. Additional practices require a catalog entry and ARB fields, whereas
additional translations only require an ARB file.

## Content references

Every detail displays its references in full. Practice points summarize the
referenced reports; practical reminders are presented separately. Sources include
[waking and sleeping](https://sunnah.com/bukhari:6312),
[answering the adhan](https://sunnah.com/muslim:384),
[post-prayer remembrance](https://sunnah.com/muslim:591),
[morning and evening remembrance](https://sunnah.com/muslim:2692),
[distress](https://sunnah.com/bukhari:6346), and
[gratitude](https://quran.com/27/19).
