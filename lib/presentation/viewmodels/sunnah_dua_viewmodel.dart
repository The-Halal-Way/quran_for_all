import 'package:flutter/foundation.dart';

import '../../domain/entities/sunnah_dua/sunnah_dua_content.dart';
import '../../domain/repositories/sunnah_dua_repository.dart';
import '../../domain/usecases/sunnah_dua/search_sunnah_content.dart';

class SunnahDuaViewModel extends ChangeNotifier {
  SunnahDuaViewModel(this._repository);

  SunnahDuaRepository _repository;
  final _search = const SearchSunnahContent();
  String _routineQuery = '';
  String _collectionQuery = '';

  String get routineQuery => _routineQuery;
  String get collectionQuery => _collectionQuery;
  int get totalPractices => _repository.dailyPractices.length;
  List<SunnahDuaContent> get practices =>
      _search(_repository.dailyPractices, _routineQuery);
  List<SunnahDuaContent> get collections => _repository.collections;

  void updateRepository(SunnahDuaRepository repository) {
    _repository = repository;
    // Called from didChangeDependencies, which already schedules a build.
  }

  void searchRoutine(String query) {
    if (_routineQuery == query) return;
    _routineQuery = query;
    notifyListeners();
  }

  void searchCollections(String query) {
    if (_collectionQuery == query) return;
    _collectionQuery = query;
    notifyListeners();
  }
}
