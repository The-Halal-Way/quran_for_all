import 'package:flutter/foundation.dart';

import '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../domain/repositories/sunnah_dua_repository.dart';
import '../../domain/usecases/sunnah_dua/search_sunnah_content.dart';

class SunnahDuaViewModel extends ChangeNotifier {
  SunnahDuaViewModel(this._repository);

  SunnahDuaRepository _repository;
  final _search = const SearchSunnahContent();
  String _routineQuery = '';

  String get routineQuery => _routineQuery;
  int get totalPractices => _repository.dailyPractices.length;
  List<SunnahDuaContent> get practices =>
      _search(_repository.dailyPractices, _routineQuery);
  List<SunnahDuaContent> get collections => _repository.collections
      .where((item) => item.kind != SunnahDuaKind.quranAyah)
      .toList(growable: false);
  List<SunnahDuaContent> get quranRecitations => _repository.collections
      .where((item) => item.kind == SunnahDuaKind.quranAyah)
      .toList(growable: false);

  void updateRepository(SunnahDuaRepository repository) {
    _repository = repository;
    // Called from didChangeDependencies, which already schedules a build.
  }

  void searchRoutine(String query) {
    if (_routineQuery == query) return;
    _routineQuery = query;
    notifyListeners();
  }
}
