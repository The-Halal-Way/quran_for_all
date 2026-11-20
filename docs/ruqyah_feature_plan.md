# Ruqyah feature plan

Planning and source review: 19 November 2026. No product implementation is part of this document.

Implemented 20 November 2026; see [implementation and content notes](ruqyah.md).

## Recommendation and placement

Create one dedicated Ruqyah page, reached through a compact Dashboard card immediately after Explore and before Islamic Knowledge Assessment. Add a secondary entry from Sunnah/Dua to the same destination. The Dashboard has eleven sections already, so its entry should contain only the title, a short description and an opening action.

- English title: Ruqyah & Protection
- Bangla title: রুকইয়াহ ও সুরক্ষা
- Suggested description: Quran and authentic duas for healing and protection.
- Visual direction: the app's fonts and light/dark palette, a restrained mint/teal accent, subtle geometric decoration, clear Arabic text and generous reader spacing. Use a calm visual identity.

The feature teaches recitation and supplication. Its purpose is not to diagnose illness, evil eye, possession or sorcery, or promise a particular health outcome.

## Research foundation and scope

The Quran describes itself as healing and mercy for believers in [17:82](https://quran.com/17/82). The direct hadith principle for permissible ruqyah is that it should contain no shirk: [Sahih Muslim 2200](https://sunnah.com/muslim:2200). A scholarly explanation of conditions includes understandable wording and belief that Allah grants healing, rather than the words operating independently: [Darul Iftaa Chicago](https://daruliftaa.us/fatwa/324/). These are religious teachings and editorial foundations, not clinical efficacy claims.

Maintain three distinct contexts in the interface: ruqyah during illness, bedtime protection, and other protective recitations. A count or method from one context must not automatically be transferred to another.

| Material | Evidence and reported context | Product treatment |
| --- | --- | --- |
| Complete Al-Fatihah | The Prophet approved its use as ruqyah in [Bukhari 5736](https://sunnah.com/bukhari:5736). | Include all of the surah. This citation does not establish a mandatory universal repetition count. |
| Al-Falaq and An-Nas during illness | Recitation and blowing during illness are reported in [Bukhari 5735](https://sunnah.com/bukhari:5735). | Explain the reported practice without borrowing bedtime counts. |
| Al-Ikhlas, Al-Falaq and An-Nas at bedtime | Reciting the surahs, blowing over the cupped hands and wiping the body in a routine repeated three times are described in [Bukhari 5017](https://sunnah.com/bukhari:5017). | Model the complete routine as a repeating cycle, including the physical actions. |
| Supplication for bodily pain | Hand placement, Bismillah three times, then the refuge supplication seven times: [Muslim 2202](https://sunnah.com/muslim:2202). | A two-stage recitation counter, with the instruction attached to its own source. |
| Allahumma Rabba an-nas | A healing supplication and its context are reported in [Bukhari 5743](https://sunnah.com/bukhari:5743). | Preserve the attested wording and identify variants addressed to another person. |
| Bismillahi arqik | Jibril's supplication for the Prophet during illness: [Muslim 2186](https://sunnah.com/muslim:2186). | Include the wording as reported for addressing another person; label any adapted grammatical variant. |
| Supplication for children | Protection sought for Al-Hasan and Al-Husayn: [Bukhari 3371](https://sunnah.com/bukhari:3371). | Identify whether the wording is general, singular or dual. |
| Ayat al-Kursi | Bedtime protection is reported in [Bukhari 2311](https://sunnah.com/bukhari:2311). | Place under bedtime protection, with its full verse and specific context. |
| Complete last two verses of Al-Baqarah | Night recitation and sufficiency are reported in [Bukhari 5009](https://sunnah.com/bukhari:5009). | Include both complete verses; avoid expanding “sufficiency” into an unsupported guarantee. |
| Al-Baqarah recitation in the home | Its reported protective context appears in [Muslim 780](https://sunnah.com/muslim:780). | A related reading recommendation, not a compulsory additional step in every short session. |

These reports do not establish one compulsory combined sequence containing every item above. A sequence assembled by the app should be described as a guided reading arrangement. Identify a specifically reported routine, such as the bedtime cycle, separately.

The app must also distinguish direct reports from later scholarly explanations. [MUIS's guidance on ruqyah](https://www.muis.gov.sg/resources/khutbah-and-religious-advice/fatwa/fatwa-deviant-teachings--english/) discusses clear recitation and religious boundaries. [Mufti Wilayah's discussion of Islamic healers](https://muftiwp.gov.my/en/artikel/irsyad-fatwa/irsyad-fatwa-umum-cat/907-irsyad-al-fatwa-series-189-the-ruling-of-consulting-with-islamic-healers-and-asking-protection-for-help-from-jinn) describes this practice alongside modern treatment. Include a brief reminder that recitation can accompany appropriate medical care.

## Existing content audit

The app already contains relevant records in `assets/json/dua_catalog.json`, including:

- `physical_pain`
- `healing_the_sick`
- `protection_for_children`
- `q_ayat_al_kursi`
- `q_surah_al_ikhlas`, `q_surah_al_falaq`, `q_surah_an_nas`

Reuse verified wording and maintain links to those canonical IDs. Ruqyah needs its own context, instructions and sources rather than duplicating an entire general dua library.

Two existing entries require particular care:

- `q_fatihah_guidance` contains a portion of Al-Fatihah, not the whole surah.
- `q_baqarah_closing_supplications` contains supplication excerpts, not both complete final verses.

Neither excerpt may be presented as a complete recitation. Add complete, source-checked passages to a small Ruqyah reading pack or reuse a verified complete source already available elsewhere in the app. Preserve the original excerpt entries for their existing purposes.

## Main page

Use three clear destinations within the Ruqyah page:

1. **Guided reading**: Start/continue a self-ruqyah reading, a bodily-pain supplication, bedtime protection, or protection for children. Show the purpose in ordinary language and explain reported actions before the user starts.
2. **Quran & duas**: Searchable full passages, with All, Illness & pain, Bedtime, Children and General protection filters. The same passage can appear in several contexts with different practice instructions.
3. **Learn**: What ruqyah means, self-ruqyah, reported practices, source explanations, questions and common misconceptions.

The first screen should lead with a useful Start/Continue action and retain access to the library and guidance. Avoid placing a long article above the practical entry points.

## Reader and session behavior

Each reading screen should present:

1. Purpose and source-supported context.
2. Complete Arabic wording.
3. Pronunciation in the selected English/Bangla language.
4. Meaning in that language.
5. Applicable instructions, reported count and timing.
6. Expandable evidence with collection, reference, relevant wording and external source link.

Use one vertical scrolling surface per page. Text panels must expand naturally rather than trapping vertical gestures in their own scroll areas. Add previous/next controls and horizontal paging with an accessible position indicator.

Counters should reflect reported instructions. For bodily pain, keep the three and seven repetitions as separate steps. For the bedtime practice, represent the entire recite/blow/wipe cycle three times. When the source supplies no fixed count, use Read/Next and optional Repeat controls; do not imply a prescribed count.

Save the current routine, step and repetition progress locally. Reopening offers Continue or Restart. Language switching should preserve the passage, step and counter. Bookmarks and font controls are useful; completion indicates reading progress, not healing or religious merit.

## Content model and lazy loading

Suggested assets:

```
assets/json/ruqyah/
  index.json
  readings.json
  routines.json
  guides_en.json
  guides_bn.json
```

The Dashboard entry is static localized UI and loads none of these files. Load the small index when Ruqyah opens, then load selected reading/routine/guide content on demand. Load only the selected guide language. Keep the core readings usable offline without requiring the main Quran download.

Each reading/routine needs stable IDs and explicit fields for:

- Full Arabic, localized meaning and pronunciation, verse ranges and wording variant.
- Context/category and related canonical dua IDs.
- Source references, URLs, hadith grading where applicable and editorial notes.
- Whether a passage is complete or an excerpt.
- Nullable reported count, timing and the source supporting that rule.
- Whether a count applies to one passage, one instruction or a complete cycle.
- Step type: reading, instruction or grouped cycle.
- Optional audio metadata and content version.

Keep source texts, practice rules and app navigation order distinct. Invalid or incomplete content should produce a recoverable loading state rather than a blank page or invented instruction.

Suggested code boundaries, following the app's recent feature structure:

```
lib/data/models/ruqyah/
lib/data/datasources/local/ruqyah/
lib/data/repositories/ruqyah_repository.dart
lib/presentation/viewmodels/ruqyah/
lib/presentation/views/dashboard/ruqyah/
lib/presentation/widgets/dashboard/ruqyah/
lib/presentation/widgets/ruqyah/{overview,reader,library,guides}/
```

No extra domain abstraction is needed for this feature. Existing page routes, localization, font styles and reusable reading/source widgets can be reused where their behavior fits.

## Audio, pronunciation and translation

Arabic text, English/Bangla pronunciation, meaning and an audio control belong in the core reader design. Meaning and pronunciation should be independently showable/hideable, with readable font controls. Switching language must not reset the current reading or count.

Use checked human recitations with documented reuse permission, reciter identity and attribution. Provide play/pause, seek, replay, repeat and optional offline download, with progress and retry states. Stream/download only after the user chooses audio; reuse the existing audio player, cache and audio-focus handling where suitable. Fetch only the selected passage's recording/metadata, without triggering the main Quran data download. Audio errors must leave the reading usable.

The app already has a lazily initialized audio player and a global audio control bar. Quran passages can use a checked Quran recording source; narrated supplications need their own checked recordings with matching wording. An open API or a freely playable recording does not by itself establish permission to redistribute its files. Include audio in the first-release scope where suitable recordings and reuse terms are confirmed; missing clips must not be substituted with an unverified voice or block access to the text.

Do not use generic Arabic TTS as the pronunciation authority. Present audio as a listening/learning aid, without asserting that playing a recording fulfils every instruction reported about personal recitation. Do not increment a user's personal recitation count solely because a recording finished.

## Editorial boundaries

- Keep reported benefits tied to their conditions and contexts; no guaranteed cures or invented seven-/forty-day programmes.
- Do not turn headaches, yawning, dreams, anxiety or ordinary discomfort into a diagnostic test for unseen causes.
- Treat evil-eye/sorcery explanations as religious educational material, not an app assessment of the user.
- Water/oil practices, additional verse selections and disputed details belong in separately sourced explanations if added later; they are not prerequisites for the initial reader.
- Do not present one combined popular verse list as the Prophet's prescribed sequence without evidence for that precise claim.
- Do not advise stopping medical treatment or use a healing score.

## Delivery sequence and checks

1. Audit source wording, complete passages, variants and context-specific counts; prepare the bilingual core pack.
2. Add the compact Dashboard entry, shared Ruqyah destination and library/guidance navigation.
3. Implement guided reading, cycle-aware counters, bookmarks and resume.
4. Integrate checked Quran/dua recordings, playback controls and optional downloads after checking wording and reuse terms.
5. Verify Arabic/verse completeness, source links, grouped-cycle behavior, selected-language loading, interrupted-session restoration, text scrolling and layout at narrow widths and large English/Bangla font sizes.

Recommended first release: complete sourced Arabic, English/Bangla meaning and pronunciation, introductory guidance, search, guided reading, resume and checked audio for supported entries. Listening and downloading remain user choices; core reading must work without audio or a prior Quran download.
