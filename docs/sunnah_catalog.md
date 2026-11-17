# Sunnah catalog

Runtime source: `assets/json/sunnah_catalog.json` (schema 1), currently 247
entries and 51 categories. The November expansion adds 112 entries and 14
categories. The supplied `sunnah_new_entry_ids.json` is a merge/audit manifest,
not a second runtime content source. Its entries, category indexes and group
additions were already present in the asset. Existing entry objects and their
order are preserved.

The model is split into `sunnah_catalog.dart`, `sunnah_entry.dart`, and
`sunnah_references.dart`. It retains bilingual text, practice types, ordered
category indexes, related Sunnah IDs, linked Dua IDs, hadith grading status and
attribution, report relationships, original collections, and typed Quran verse
ranges/counts. Null repetition counts stay unspecified.

Validation checks unique IDs, category counts, integration totals, both sides
of category membership, group coverage, featured IDs, practice type labels,
related Sunnah references, All coverage, verse ranges, and repetition counts.
The reader displays the supplied summaries and source metadata without creating
new religious content or changing the JSON text.

Loading remains on demand: `SunnahCatalogLoader` reads the asset and decodes,
validates and indexes it with `compute` only after the library opens. Dua data
is separately loaded only when its link is tapped. The landing card has no
hardcoded count; the opened library derives totals from the parsed catalog.

Search uses both languages and the complete supplied fields, including titles,
practice, keywords and sources. Swipe navigation follows the selected category's
full `entryIds` order. Entry IDs remain the stable identity across languages.
