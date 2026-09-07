import '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../domain/repositories/sunnah_dua_repository.dart';
import '../../l10n/app_localizations.dart';
import '../datasources/local/sunnah_dua/sunnah_morning_content.dart';
import '../datasources/local/sunnah_dua/sunnah_daytime_content.dart';
import '../datasources/local/sunnah_dua/sunnah_evening_content.dart';
import '../datasources/local/sunnah_dua/sunnah_collection_content.dart';

/// A catalog bound to one generated ARB locale; rebuilt when the locale changes.
class SunnahDuaRepositoryImpl implements SunnahDuaRepository {
  SunnahDuaRepositoryImpl(AppLocalizations strings)
    : dailyPractices = List.unmodifiable([
        ...sunnahMorningContent(strings),
        ...sunnahDaytimeContent(strings),
        ...sunnahEveningContent(strings),
      ]),
      collections = List.unmodifiable(sunnahCollectionContent(strings));

  @override
  final List<SunnahDuaContent> dailyPractices;

  @override
  final List<SunnahDuaContent> collections;
}
