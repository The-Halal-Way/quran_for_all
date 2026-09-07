import '../../../../domain/entities/sunnah_dua/sunnah_dua_content.dart';

SunnahDuaContent sunnahContent({
  required String id,
  required String title,
  required String subtitle,
  required String points,
  required String practice,
  required String source,
  SunnahDayPhase? phase,
  SunnahDuaKind kind = SunnahDuaKind.sunnah,
  String arabic = '',
  String pronunciation = '',
  String translation = '',
}) => SunnahDuaContent(
  id: id,
  title: title,
  subtitle: subtitle,
  points: List.unmodifiable(
    points
        .split('||')
        .map((point) => point.trim())
        .where((point) => point.isNotEmpty),
  ),
  practice: practice,
  source: source,
  phase: phase,
  kind: kind,
  arabic: arabic,
  pronunciation: pronunciation,
  translation: translation,
);
