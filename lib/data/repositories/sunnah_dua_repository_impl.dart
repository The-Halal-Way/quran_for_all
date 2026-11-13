import '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../domain/repositories/sunnah_dua_repository.dart';
import '../../l10n/app_localizations.dart';
import '../datasources/local/sunnah_dua/sunnah_morning_content.dart';
import '../datasources/local/sunnah_dua/sunnah_daytime_content.dart';
import '../datasources/local/sunnah_dua/sunnah_evening_content.dart';
import '../datasources/local/sunnah_dua/sunnah_collection_content.dart';

/// A catalog bound to one generated ARB locale; rebuilt when the locale changes.
class SunnahDuaRepositoryImpl implements SunnahDuaRepository {
  SunnahDuaRepositoryImpl(this._strings)
    : collections = List.unmodifiable(sunnahCollectionContent(_strings));

  final AppLocalizations _strings;

  @override
  late final List<SunnahDuaContent> dailyPractices = List.unmodifiable([
    ...sunnahMorningContent(_strings),
    ...sunnahDaytimeContent(_strings),
    ...sunnahEveningContent(_strings),
  ]);

  @override
  final List<SunnahDuaContent> collections;
}
