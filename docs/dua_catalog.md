# Dua library

SunnahDuaView opens a dedicated category browser through its Dua library card.
Morning, Evening and All shortcuts open the matching category directly. The
library supports 26 categories, category filtering, and search across titles,
Arabic, pronunciation, meaning, aliases and references in both supplied
languages. Arabic search ignores recitation marks; Bengali vowel signs remain
part of the searchable words. Search within a category keeps the query while
switching categories. The All list follows its ordered IDs and shows each main
entry once.

Opening a dua starts a horizontal page reader at that entry. It follows the full
category order even when the item was found through search; source-note readers
use their own reference IDs. Previous/next buttons, a localized position count
and a window of up to seven dots show progress through the category. Each entry
keeps its own vertical reading position and occasion choice while the reader is
open. Copy and language controls apply to the currently visible entry. Related
entries in the same sequence jump to their page; other related entries open a
separate reader.

## Data and loading

`assets/json/dua_catalog.json` is the source of the category and reading data.
The static Sunnah-page entry card never loads this JSON. `DuaCatalogLoader`
opens it on entry to the library, parses and indexes it in an isolate, and
caches the result. Failed loads are retryable. Categories and details reuse
the parsed catalog; searching does not read the asset again. Lists build their
reading tiles lazily. The English and Bangla content lives together in this
single bilingual asset, with the configured English fallback for other app
languages.

The data models and loader live under `data/models/dua/` and
`data/datasources/local/`. `DuaLibraryViewModel` owns navigation/filter state.
Views are in `presentation/views/sunnah_dua/catalog/`; independent widgets are
in `presentation/widgets/sunnah_dua/catalog/`. The feature adds no domain-layer
dependency and requires no network access to read the collection.

## Reading rules

- Main entries follow `categories[].entryIds`; the five reference-only entries
  are available through the separate Reports & source notes tab. Their notes
  and original grading stay visible in details.
- Category-specific titles resolve through `categoryDisplayTitles`.
- Ordered segments use their own repetition counts. Other counts come from
  `repetitionsByOccasion`, then `repetitionsPerOccasion`. Unspecified counts
  are not converted to zero or one.
- An occasion selector separates the outward and return journeys, and evening
  remembrance from stopping at a lodging place. Occasion-specific segments
  appear only for the selected occasion.
- `forReferenceOnly` segments and `referenceVariant` stay in a context section.
  They are excluded from the main reading and its copy action.
- Alternate wording, Quran references, hadith summaries and grades, notes and
  source links render from the asset. Source and recitation links open in the
  external browser. No TTS voice is used for Quran or dua pronunciation.
- The guide includes long-vowel examples, articulation notes and the linked
  recitation reference. Entry-specific examples use the same guide.

## Migration from More

The twelve former More items have moved to the JSON catalog. Seven use entries
already present; five were added with their complete original English and
Bangla context. `integration.legacyMoreEntryIds` records the mapping.

| Former ID | Catalog ID |
| --- | --- |
| morning_evening | subhanallah_wa_bihamdihi |
| gratitude | q_sulayman_gratitude_and_good_deeds |
| when_angry | refuge_from_shaytan |
| during_loss | when_struck_by_calamity |
| after_fajr | beneficial_knowledge_after_fajr |
| ending_gathering | ending_a_gathering |
| bedtime_dhikr | bedtime_tasbih |
| seeking_forgiveness | seeking_forgiveness |
| difficulty | difficulty |
| siyam_sunnahs | siyam_sunnahs |
| after_salah | after_salah |
| salawat | salawat |

The five additions preserve localized `context.subtitle`, `context.practice`,
`context.points` and `sourceText`. The fasting reminder is a `sunnah_practice`,
and its Arabic is labeled as a hadith statement. No new grading is assigned to
the migrated material. Counts now total 141 records: 136 main entries and five
reference entries. Quran-recitation shortcuts and daily Sunnah routines remain
in their existing sections.
