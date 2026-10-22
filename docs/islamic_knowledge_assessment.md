# Islamic Knowledge Assessment

## Entry and loading

`DashboardQuizSection` opens `KnowledgeAssessmentSelectionView`. Both are static:
neither reads config, question banks, or the local database. The catalog offers
Kids, General Learners, and Islamically Educated, each with Beginner,
Intermediate, and Pro levels. All three Kids levels, all three General Learners
levels, and Islamically Educated → Intermediate currently have content.
The other two levels show a localized coming-soon sheet.

Opening a level's `KnowledgeAssessmentView` loads only its config and local
attempt summaries. Starting an assessment loads and validates **only the chosen
language's** banks in a worker isolate. Selecting a different language before
starting does not load any banks. Saved attempts resume from selected-language
snapshots without loading current banks. Results and review use the same fixed
language as their attempt.

Each available level has its own `quiz_config.json` beside its question folders:

- `assets/json/quiz/kids/beginner/`
- `assets/json/quiz/kids/intermediate/`
- `assets/json/quiz/kids/pro/`
- `assets/json/quiz/general/beginner/`
- `assets/json/quiz/general/intermediate/`
- `assets/json/quiz/general/pro/`
- `assets/json/quiz/islamically_educated/intermediate/`

Its `assets.basePath`, `languageDirectories`, and path template resolve the
`english` and `bangla` folders next to it. Category count, difficulty quotas,
total questions, shuffling,
answer controls, time limit, scoring, result/review controls, and retake settings
come from this config. `languageChangeDuringAttempt` is `locked_after_start`.
Unsupported policies or inconsistent quotas fail visibly;
they are not silently replaced. Bank `selectionHints` do not override config.

## Adding content and organization

`lib/core/constants/quiz_catalog.dart` maps each available audience/level to its
config path and database name. Add a definition to `QuizCatalog.assessments` when
a new level is ready. Give it its own config, banks, and database name, and declare
the asset folders in `pubspec.yaml`. Placeholders need no dummy JSON files.

Quiz widgets live in `lib/presentation/widgets/quiz/`: `dashboard/`, `selection/`,
and `shared/`, with the reusable assessment renderer split under
`assessment/{overview,questions,results,shared}/`. All available levels share
this renderer, with their own config and isolated persistence.
The feature has no domain-layer dependency.

## Kids Beginner banks

Kids → Beginner uses schema-3 banks with `audienceId: kids` and
`levelId: beginner`. There are six subjects with 60 questions each in English
and Bangla. Its config selects 24 questions: two `familiar_fact`, one
`broader_basic`, and one `everyday_application` per subject, following the
four-per-subject recommendation in the supplied banks. There is no time limit.

The existing localized assessment UI provides language selection before start,
the separate “I'm not sure” action, resume, results and answer review. Only the
chosen language's banks are read when starting. No Kids banks are read while
browsing the dashboard or audience/level picker. Its independent
`quiz_kids_beginner_v1.db` keeps attempts and exposure history separate from
General Learners and Islamically Educated assessments. The supplied questions
and review statuses are kept as authored; the existing draft-content policy
also applies to this level.

## Kids Intermediate banks

Kids → Intermediate also uses schema-3 banks for six subjects, with 60 questions
per subject in English and Bangla. The source banks identify the level as `mid`;
the config preserves that ID while the UI displays Intermediate. Question IDs,
options, explanations, references and review statuses are not rewritten.

The level selects 24 questions without a time limit: two `familiar_fact`, one
`broader_basic`, and one `everyday_application` per subject. It uses the shared
localized assessment UI and lazy selected-language loading. Its independent
`quiz_kids_intermediate_v1.db` stores progress, completed attempts and exposure
history separately from every other level. Language stays fixed during an
attempt and its results/review. The existing draft-content policy applies to
Intermediate's supplied banks.

## Kids Pro banks

Kids → Pro uses schema-3 banks with `audienceId: kids` and `levelId: pro`.
English and Bangla each contain 60 questions in each of six subjects. Its
config selects 24 questions without a time limit: two `familiar_fact`, one
`broader_basic`, and one `everyday_application` per subject. Question content,
IDs, options, explanations, references and review statuses remain as authored.

It shares the localized assessment UI, selected-language lazy loading, fixed
attempt language, unknown response, resume, results and review flow. Its own
`quiz_kids_pro_v1.db` keeps progress, completed attempts and exposure history
separate from other levels. Pro is the highest level within Kids; it does not
change the audience to Islamically Educated. The supplied banks retain their
draft status and follow the existing content-review policy.

## General Learners banks

The new General Learners banks use schema 3: `audienceId`, `levelId`,
`questionStyle`, and `questionStyleCounts`. The parser checks the audience and
level against the selected config and verifies every declared style count.
Intermediate's source `levelId` is `mid`; its config preserves that ID while the
UI calls the level Intermediate. Question content and IDs are not rewritten.

All three General Learners levels configure 24 questions: six subjects, each with two `familiar_fact`,
one `broader_basic`, and one `everyday_application`. Styles describe task types,
not difficulty. Their question chips, mix, and result breakdowns use localized
style labels. The existing Islamically Educated banks remain schema 1 and retain
their configured difficulty quotas and breakdowns. The same selection algorithm
handles either quota dimension while enforcing concept uniqueness.

For another content language, add its code to `supportedLanguages`, its native
display name to `languageNames`, and its folder to `assets.languageDirectories`.
Declare and supply that folder's banks. The loader never reads other language
folders. Current-language validation remains mandatory; translation IDs and
grading metadata must be kept aligned when authoring the banks. App chrome
uses its matching translation when supported, otherwise English. Adding a
content language does not require loading another question language.

## Selection

`quiz_selection.dart` uses minimum-cost flow between concept IDs and
category/difficulty quota groups. Each concept has capacity one. Residual paths
can revise previous assignments, avoiding the dead ends of greedy sampling.
Cost bands prioritize the configured first tier, then avoid the last tier,
with least-recent exposure and randomized ties within each tier.

The supplied order is unseen, seen outside the last three completed attempts,
then seen in those attempts. When unseen questions run out, recency alone is
relaxed. Quotas, distinct question IDs, and distinct concepts stay mandatory.
An impossible assignment blocks starting with a localized message.

## Persistence

Each level opens its own SQLite database lazily. Full snapshots do not enlarge
the app-wide SharedPreferences used at launch. Answer changes, navigation,
language, unknown responses, and question exposure are saved before the UI
publishes the updated state. Display exposure is recorded after a question's
first frame, once per attempt, and kept when an attempt is abandoned.

SQLite transactions keep exposure and attempt updates together. A unique index
and transaction checks permit one incomplete attempt. Writes are serialized by
the view model; failed writes leave the last saved UI state unchanged.
Completed payloads are retained locally; history loads small summaries and only
decodes a full historical snapshot when opened. No automatic deletion is applied.

Language is selected before starting and cannot change during an attempt,
after submission, or in review. The controller enforces this in addition to
the UI. A new attempt can use another language; question exposure/history uses
stable IDs across languages. Saved question and option order, responses, and
grading remain unchanged on resume.

Kids Beginner uses `quiz_kids_beginner_v1.db`; Kids Intermediate uses
`quiz_kids_intermediate_v1.db`; Kids Pro uses `quiz_kids_pro_v1.db`.
General Beginner uses `quiz_general_beginner_v1.db`; General Intermediate uses
`quiz_general_intermediate_v1.db`; General Pro uses `quiz_general_pro_v1.db`.
Resuming, exposure avoidance, and history are
isolated between levels; within a level, question history spans languages by ID.

Islamically Educated → Intermediate retains `islamic_knowledge_assessment_v1.db`, preserving all
previous attempts and exposure history. Schema-1 snapshots are read in their
saved language and the unused translations are dropped from the decoded model.
Subsequent saves use schema 2 with only the selected language. Completed legacy
attempts remain readable without rewriting or deleting their records.

## Results and content review

Answers are graded by option ID, never by the displayed A–D position. Unknown
and unanswered are separate statuses and counts. No answers are revealed before
submission. Results describe only the sampled questions, with no faith, piety,
mastery, or scholarly qualification labels.

The supplied banks and config are marked `draft_for_scholarly_review`. Debug
and profile builds allow a labeled development preview. Release builds reject
unapproved banks and unapproved saved snapshots, following the config's release
policy. After actual editorial and scholarly review, update each bank's
`review.status` and the config's `contentReview.currentBankStatus` to a status in
`contentReview.approvedStatuses` (currently `editorial_and_scholarly_approved`).
This implementation does not certify the religious content or change any
questions, answers, explanations, or references.
