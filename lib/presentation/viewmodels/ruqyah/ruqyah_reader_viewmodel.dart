import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../../../data/models/ruqyah/ruqyah_progress.dart';
import '../../../data/models/ruqyah/ruqyah_reading.dart';
import '../../../data/models/ruqyah/ruqyah_routine.dart';
import '../../../data/repositories/ruqyah_repository.dart';

class RuqyahReaderViewModel extends ChangeNotifier {
  RuqyahReaderViewModel({
    required this.repository,
    this.routineId,
    this.readingIds = const [],
    this.initialIndex = 0,
    this.resume,
  });
  final RuqyahRepository repository;
  final String? routineId;
  final List<String> readingIds;
  final int initialIndex;
  final RuqyahProgress? resume;
  RuqyahRoutine? routine;
  Map<String, RuqyahReading> readings = {};
  List<RuqyahStep> librarySteps = [];
  int index = 0;
  final Map<int, int> counts = {};
  final Set<int> completed = {};
  bool loading = true, failed = false, saveFailed = false, finished = false;
  bool progressUpdated = false;
  bool _disposed = false, _initialized = false;
  int _request = 0;
  int get length => routine?.length ?? librarySteps.length;
  RuqyahStep stepAt(int value) => routine?.stepAt(value) ?? librarySteps[value];
  RuqyahStep get step => stepAt(index);
  RuqyahReading? readingAt(int value) => readings[stepAt(value).readingId];
  RuqyahReading? get reading => readingAt(index);
  int get count => counts[index] ?? 0;
  bool get canAdvance => step.count == null || count >= step.count!;
  RuqyahReaderPreferences get preferences => repository.store.reader;
  bool get bookmarked =>
      reading != null && repository.store.bookmarks.contains(reading!.id);
  String get sequence => jsonEncode([
    for (var i = 0; i < length; i++)
      {
        'id': stepAt(i).id,
        'reading': stepAt(i).readingId,
        'count': stepAt(i).count,
        'instruction': stepAt(i).instruction?.values,
      },
  ]);

  Future<void> load(String language) async {
    final ticket = ++_request;
    loading = true;
    failed = false;
    _notify();
    try {
      final result = await repository.assets.loadReadings(language);
      final definition = routineId == null
          ? null
          : await repository.assets.loadRoutine(routineId!);
      await repository.store.load();
      if (_disposed || ticket != _request) return;
      readings = result;
      routine = definition;
      librarySteps = readingIds
          .map((id) {
            if (!result.containsKey(id)) {
              throw const FormatException('Missing reading.');
            }
            return RuqyahStep.fromJson({'id': id, 'reading_id': id});
          })
          .toList(growable: false);
      if (length < 1) throw const FormatException('Empty reader.');
      if (!_initialized) {
        index = initialIndex.clamp(0, length - 1);
        final old = resume;
        if (old != null &&
            old.routineId == routineId &&
            old.length == length &&
            old.sequence == sequence &&
            listEquals(old.readingIds, readingIds)) {
          index = old.index;
          for (final entry in old.counts.entries) {
            final limit = stepAt(entry.key).count;
            if (limit != null) counts[entry.key] = entry.value.clamp(0, limit);
          }
          completed.addAll(
            old.completed.where(
              (i) =>
                  stepAt(i).count == null ||
                  (counts[i] ?? 0) >= stepAt(i).count!,
            ),
          );
        } else if (old != null) {
          progressUpdated = true;
        }
        _initialized = true;
      }
      await _save();
    } catch (_) {
      if (ticket == _request) failed = true;
    }
    if (ticket != _request || _disposed) return;
    loading = false;
    _notify();
  }

  void goTo(int value) {
    if (value < 0 || value >= length) return;
    index = value;
    _save();
    _notify();
  }

  void increment() {
    final target = step.count;
    if (target == null || count >= target) return;
    counts[index] = count + 1;
    if (count == target) completed.add(index);
    _save();
    _notify();
  }

  void undo() {
    if (count == 0) return;
    counts[index] = count - 1;
    completed.remove(index);
    _save();
    _notify();
  }

  void advance() {
    if (!canAdvance) return;
    completed.add(index);
    if (index < length - 1) {
      index++;
      _save();
    } else if (completed.length == length) {
      finished = true;
      _persist(() => repository.store.saveProgress(null));
    } else {
      index = List.generate(
        length,
        (i) => i,
      ).firstWhere((i) => !completed.contains(i));
      _save();
    }
    _notify();
  }

  void restart() {
    index = 0;
    counts.clear();
    completed.clear();
    finished = false;
    _save();
    _notify();
  }

  void dismissProgressNotice() {
    progressUpdated = false;
    _notify();
  }

  Future<void> toggleBookmark() async {
    if (reading == null) return;
    await _persist(() => repository.store.toggleBookmark(reading!.id));
    _notify();
  }

  void setPreferences(RuqyahReaderPreferences value) {
    _persist(() => repository.store.saveReader(value));
    _notify();
  }

  Future<void> _save() async {
    if (finished) return;
    await _persist(
      () => repository.store.saveProgress(
        RuqyahProgress(
          routineId: routineId,
          readingIds: readingIds,
          index: index,
          counts: Map.of(counts),
          completed: Set.of(completed),
          length: length,
          sequence: sequence,
        ),
      ),
    );
  }

  Future<void> _persist(Future<void> Function() operation) async {
    try {
      await operation();
      saveFailed = false;
    } catch (_) {
      saveFailed = true;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
