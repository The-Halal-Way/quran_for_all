import '../../models/islamic_days/islamic_day_occurrence.dart';
import '../../repositories/islamic_days_repository.dart';

class IslamicDaysProgressStore {
  IslamicDaysProgressStore(this.repository);

  final IslamicDaysRepository repository;
  Set<String> _saved = {};
  Set<String> _completed = {};
  Set<String> _tracked = {};
  Future<void> _writes = Future.value();

  Set<String> get saved => Set.unmodifiable(_saved);
  bool completed(String key) => _completed.contains(key);
  bool tracked(IslamicDayOccurrence occurrence) =>
      _tracked.contains(occurrence.key);

  Future<void> load() async {
    final results = await Future.wait([
      repository.loadSet('saved'),
      repository.loadSet('completed'),
      repository.loadSet('tracked'),
    ]);
    _saved = results[0];
    _completed = results[1];
    _tracked = results[2];
  }

  Future<void> toggleSaved(String id) => _enqueue(() async {
    final updated = {..._saved};
    if (!updated.remove(id)) updated.add(id);
    await repository.saveSet('saved', updated);
    _saved = updated;
  });

  Future<void> toggleCompleted(String key) => _enqueue(() async {
    final updated = {..._completed};
    if (!updated.remove(key)) updated.add(key);
    await repository.saveSet('completed', updated);
    _completed = updated;
  });

  Future<void> addToTracker(IslamicDayOccurrence occurrence) =>
      _enqueue(() async {
        final updated = {..._tracked, occurrence.key};
        await repository.saveSet('tracked', updated);
        _tracked = updated;
      });

  Future<void> _enqueue(Future<void> Function() write) {
    final operation = _writes.then((_) => write());
    _writes = operation.catchError((Object _) {});
    return operation;
  }
}
