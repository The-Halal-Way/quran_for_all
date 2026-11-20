# Ruqyah & Protection

Implemented 20 November 2026. The original source review and design rationale are in [ruqyah_feature_plan.md](ruqyah_feature_plan.md).

## Entry points and loading

The Dashboard has a compact entry after Explore. Sunnah/Dua opens the same destination. Neither entry reads JSON, initializes an audio player or makes network requests.

Opening the feature loads only `assets/json/ruqyah/index.json` and the small local reading-state record. Quran/dua text loads when the library or reader opens; only the selected English/Bangla language pack loads. Articles load when Learn or an article opens, without loading the reading bank. Large JSON documents are decoded in a worker isolate. The feature works independently of the main Quran download.

## Editable content

- `index.json`: reading titles/categories, routine summaries, knowledge groups, article summaries and featured article IDs.
- `readings.json`: complete Arabic passages, sources, Quran global verse IDs and canonical dua links.
- `readings_en.json`, `readings_bn.json`: pronunciation, meaning, context, audience, background and method. Meanings are app-prepared renderings, not a named published translator's edition.
- `routines.json`: reading steps, instructions and source-supported repetition rules.
- `guides_en.json`, `guides_bn.json`: structured articles with section-level sources, evidence classification, related reading IDs, related method IDs and audio credits.

Every asset has schema version `1`; the expanded edition has `content_revision: 2`. Add stable IDs to both the index and the matching reading/language records. Counted steps require evidence; multi-cycle routines require cycle evidence. Al-Fatihah contains all seven verses and Al-Baqarah 2:285–286 contains both complete verses. Ayyub (21:83), Yunus (21:87) and refuge (23:97–98) also preserve the full verses, including their narrative/introductory wording, so displayed text matches the Quran audio. Existing excerpt entries in the general dua catalogue are untouched.

The bodily-pain routine has separate three- and seven-repetition steps. Bedtime repeats the complete three-surah and blowing/wiping sequence three times. App-arranged reading orders are identified separately from reported routines.

## Progress and reader

`RuqyahLocalStore` stores one small `SharedPreferences` record, `ruqyah_reading_state_v1`: active routine or library order, page, per-page repetition counts, completed pages, bookmarks and display preferences. Writes are serialized. A language-independent sequence signature records step IDs, reading IDs, counts and instructions; incompatible or unsigned old progress starts afresh with an explanation. Language switching preserves compatible progress, and switching after completion cannot recreate an unfinished session. Swiping alone does not mark readings complete. Every expandable source/background panel has its own storage key so expansion state cannot collide with the vertical scroll offset.

Arabic, pronunciation and meaning grow with the page; there are no separately scrolling text panels. Reader preferences control pronunciation, meaning and Arabic size.

## Expanded research edition

The library now has 18 readings, 10 methods and 16 articles in four groups: foundations, practical methods, understanding, and common questions. The overview separates care/comfort from daily protection and links each method to its explanatory article. Learn supports full-content/source search and group filters. Article pages have a section index and links to the associated methods/readings. All content is available in English and Bangla; another language pack is never fetched automatically.

Evidence classifications distinguish reported practice, Quranic context, scholarly guidance and app reading guidance. A combined routine is explicitly an arrangement, even when every component has a source. Source links identify their type and show the attributed grade where supplied. The app does not turn scholarly interpretations into additional narrated rituals.

Source review, checked 20 November 2026:

| Topic | Source and implementation decision |
| --- | --- |
| Permissible ruqyah | [Muslim 2200](https://sunnah.com/muslim:2200); the foundation article explains the no-shirk boundary and attributes scholarly conditions separately. |
| Self-reading and illness | [Bukhari 5736](https://sunnah.com/bukhari:5736) and [5735](https://sunnah.com/bukhari:5735); complete passages, gentle actions, and an explicitly arranged short selection. |
| Bodily pain | [Muslim 2202](https://sunnah.com/muslim:2202); hand-placement context and distinct counters of three then seven. |
| Bedtime | [Bukhari 5017](https://sunnah.com/bukhari:5017); three complete three-surah/blowing/wiping cycles. |
| Morning/evening | [Abu Dawud 5082](https://sunnah.com/abudawud:5082), Hasan per Al-Albani, and [5088](https://sunnah.com/abudawud:5088), Sahih per Al-Albani; counts and time spans stay attached to their respective reports. |
| Stopping at a place/evening | [Muslim 2708a](https://sunnah.com/muslim:2708a) and [2708b/2709a](https://sunnah.com/muslim:2708b); no fixed count is invented from these reports. |
| Visiting the ill | [Abu Dawud 3106](https://sunnah.com/abudawud:3106), Sahih per Al-Albani; sevenfold invocation retains the report's condition about the appointed time. Patient-addressed wording is explained. |
| Children | [Bukhari 3371](https://sunnah.com/bukhari:3371); source wording, no invented counter, and calm caregiver guidance. |
| Unpleasant dreams/prayer whispering | [Muslim 2262](https://sunnah.com/muslim:2262) and [2203a](https://sunnah.com/muslim:2203a); separate contexts and physical actions. The conventional refuge formula has its own wording source, [Bukhari 6115](https://sunnah.com/bukhari:6115). |
| Home/night | [Muslim 780](https://sunnah.com/muslim:780), [Bukhari 2311](https://sunnah.com/bukhari:2311) and [5009](https://sunnah.com/bukhari:5009); the whole-surah report is distinct from the complete short night passages. |
| Evil eye and sihr | [Muslim 2188](https://sunnah.com/muslim:2188), [Quran 2:102](https://quran.com/2/102) and [Al-Falaq](https://quran.com/113); evidence is explained without assigning an unseen diagnosis or accusing an individual. |
| Water/oil | [Jordan Iftaa 672](https://www.aliftaa.jo/en-fatwas/672/DefaultEn.aspx) and [Mufti Wilayah 829](https://muftiwp.gov.my/en/artikel/irsyad-fatwa/irsyad-fatwa-umum-cat/5848-irsyad-hukum-siri-ke-829-ruqyah-menggunakan-air-rendaman-kertas-yang-mengandungi-ayat-suci-al-quran); attributed scholarly guidance, no mandatory product or ingestion recipe. |
| Purity/menstruation | [Egypt Dar Al-Ifta 7815](https://dar-alifta.org/en/fatwa/details/7815/is-it-permissible-for-a-menstruating-woman-to-recite-the-quran-from-the-computer) and [Jordan Iftaa 1064](https://www.aliftaa.jo/en-fatwas/1064/DefaultEn.aspx); distinguish dua/dhikr, tilawah and a physical Mushaf, and acknowledge differing scholarly positions. |
| Trustworthy help | [MUIS guidance](https://www.muis.gov.sg/resources/khutbah-and-religious-advice/fatwa/fatwa-deviant-teachings--english/) and [Bukhari 5736](https://sunnah.com/bukhari:5736); explain transparent wording, consent/boundaries and fees without treating compensation alone as evidence of fraud. |

The articles also explain the themes of the Quran passages, the supplications of Ayyub and Yunus in their full-verse contexts, reading evidence critically, and continued care when recovery takes time. There are no symptom-based possession tests, spiritual ranks, recovery guarantees or unsourced compulsory repetition programs. The supported readings do not replace assessment or treatment for illness.

## Audio

Quran playback uses human recordings by Mishary Rashid Alafasy from the [Al Quran Cloud CDN](https://alquran.cloud/cdn), in the same `ar.alafasy` edition used elsewhere in the app. Selected passages map to global verse IDs; no Quran API/data download is needed before playback. The native player initializes only on Play. It stops the shared Quran player first, handles audio interruptions and pauses on leaving the foreground. Playback never increments a personal recitation counter.

Play/pause, verse navigation, seeking, passage repeat and explicit offline download are available. Offline files live in application support under `ruqyah_audio/ar.alafasy`. Downloads validate status, content type, audio headers and response length, then atomically publish the file. Incomplete files cannot be used as completed downloads. Text remains readable when networking or audio fails.

The provider's [terms](https://alquran.cloud/terms-and-conditions), checked 19 November 2026, allow streaming, embedding and downloading recitations for personal and educational use; copyright remains with the reciters and commercial use remains subject to their rights. Attribution is in the reader and Learn page. No recording is bundled into the APK. Supplication recordings are deliberately absent until checked recordings with matching wording and suitable reuse terms are available; the reader explains this.

## Code and validation

Models, asset loading, local storage, repository, viewmodels, audio cache, views and independent widgets are split into feature folders. There is no new domain layer or package dependency.

Tests cover selected-language lazy loading, complete passages, incompatible assets, cycle semantics, interrupted-session restoration, concurrent persistence, Arabic/Bangla search, invalid audio downloads, stale playback requests and narrow layouts with enlarged English/Bangla text in both themes.

Initial-edition validation on 20 November 2026:

- 24 Ruqyah and Quran first-launch checks pass.
- Full `flutter analyze` is clean; Android debug APK builds successfully.
- Android emulator: opened from Dashboard, restored the saved reading, played all seven Al-Fatihah recordings in sequence and explicitly downloaded exactly those seven MP3s. The reader showed the final verse and offline-ready state. Playback requests audio focus only through the native player, avoiding self-interruption from duplicate focus requests.
- A broader run of the existing Dashboard/Sunnah/Dua widget suites still fails on older fixtures, including a settings mock missing `isLoading` and tests targeting routine/search widgets that have already moved out of the Sunnah/Dua landing page. Those unrelated tests were left unchanged.

Expanded-edition validation on 20 November 2026:

- All 30 Ruqyah tests pass: asset compatibility, selected-language loading, article references/actions, exact counts/cycles, complete verse/audio IDs, progress signatures, completed-session language changes, audio behavior and persistence.
- The hub, searchable guide filters, article navigation/source expansion and reader pass at 320px with enlarged English/Bangla text; hub checks cover both themes.
- Full `flutter analyze` reports no issues and the Android debug APK builds successfully.
- The updated APK was installed on the Android emulator with existing app data preserved. The overview, expanded Learn library and detailed self-ruqyah article were opened and inspected.
