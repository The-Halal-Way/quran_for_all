import '../../../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../../../l10n/app_localizations.dart';
import 'sunnah_content_builder.dart';

List<SunnahDuaContent> sunnahEveningContent(AppLocalizations l10n) => [
  sunnahContent(
    id: 'evening_remembrance',
    phase: SunnahDayPhase.evening,
    title: l10n.sunnahRoutineEveningTitle,
    subtitle: l10n.sunnahRoutineEveningSubtitle,
    points: l10n.sunnahRoutineEveningPointsRaw,
    practice: l10n.sunnahRoutineEveningPractice,
    source: l10n.sunnahRoutineEveningSource,
  ),
  sunnahContent(
    id: 'night_safety',
    phase: SunnahDayPhase.evening,
    title: l10n.sunnahRoutineNightSafetyTitle,
    subtitle: l10n.sunnahRoutineNightSafetySubtitle,
    points: l10n.sunnahRoutineNightSafetyPointsRaw,
    practice: l10n.sunnahRoutineNightSafetyPractice,
    source: l10n.sunnahRoutineNightSafetySource,
  ),
  sunnahContent(
    id: 'bedtime_recitation',
    phase: SunnahDayPhase.evening,
    title: l10n.sunnahRoutineBedtimeRecitationTitle,
    subtitle: l10n.sunnahRoutineBedtimeRecitationSubtitle,
    points: l10n.sunnahRoutineBedtimeRecitationPointsRaw,
    practice: l10n.sunnahRoutineBedtimeRecitationPractice,
    source: l10n.sunnahRoutineBedtimeRecitationSource,
  ),
  sunnahContent(
    id: 'sleeping_sunnahs',
    phase: SunnahDayPhase.evening,
    title: l10n.sunnahRoutineSleepTitle,
    subtitle: l10n.sunnahRoutineSleepSubtitle,
    points: l10n.sunnahRoutineSleepPointsRaw,
    practice: l10n.sunnahRoutineSleepPractice,
    source: l10n.sunnahRoutineSleepSource,
    arabic: l10n.sunnahRecitationSleepArabic,
    pronunciation: l10n.sunnahRecitationSleepPronunciation,
    translation: l10n.sunnahRecitationSleepTranslation,
  ),
];
