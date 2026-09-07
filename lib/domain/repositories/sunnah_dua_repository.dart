import '../entities/sunnah_dua/sunnah_dua_content.dart';

abstract interface class SunnahDuaRepository {
  List<SunnahDuaContent> get dailyPractices;
  List<SunnahDuaContent> get collections;
}
