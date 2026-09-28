import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Personal reading, remembrance, and daily completion notes.
/// Counts are user goals, never prescribed religious quantities.
class NeedAmalProgressViewModel extends ChangeNotifier {
  NeedAmalProgressViewModel({DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const _dateKey = 'need_amals_date';
  static const _completedKey = 'need_amals_completed';
  static const _juzKey = 'need_amals_khatm_juz';
  static const _yunusKey = 'need_amals_yunus_count';

  final DateTime Function() _now;
  SharedPreferences? _prefs;
  Future<void> _pendingSave = Future.value();
  Set<String> _completed = {};
  int _juz = 0;
  int _yunus = 0;
  String _date = '';
  bool _loaded = false;
  bool _disposed = false;

  bool get isLoaded => _loaded;
  int get juz => _juz;
  int get yunusCount => _yunus;
  int get completedCount => _completed.length;
  bool isCompleted(String id) => _completed.contains(id);

  String _dateOf(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _prefs = prefs;
      final today = _dateOf(_now());
      _date = today;
      if (prefs.getString(_dateKey) == today) {
        _completed = (prefs.getStringList(_completedKey) ?? []).toSet();
        _yunus = (prefs.getInt(_yunusKey) ?? 0).clamp(0, 9999);
      }
      _juz = (prefs.getInt(_juzKey) ?? 0).clamp(0, 30);
    } catch (_) {
      _date = _dateOf(_now());
      // Personal progress remains usable in memory if storage is unavailable.
    } finally {
      _loaded = true;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _resetIfNewDay() {
    final today = _dateOf(_now());
    if (today == _date) return;
    _date = today;
    _completed = {};
    _yunus = 0;
    notifyListeners();
  }

  Future<void> toggleComplete(String id) async {
    if (!_loaded) return;
    _resetIfNewDay();
    if (!_completed.add(id)) _completed.remove(id);
    notifyListeners();
    await _save();
  }

  Future<void> changeJuz(int delta) async {
    if (!_loaded) return;
    final updated = (_juz + delta).clamp(0, 30);
    if (updated == _juz) return;
    _juz = updated;
    notifyListeners();
    await _save();
  }

  Future<void> changeYunusCount(int delta) async {
    if (!_loaded) return;
    _resetIfNewDay();
    final updated = (_yunus + delta).clamp(0, 9999);
    if (updated == _yunus) return;
    _yunus = updated;
    notifyListeners();
    await _save();
  }

  Future<void> _save() {
    _pendingSave = _pendingSave.then((_) async {
      final prefs = _prefs;
      if (prefs == null) return;
      try {
        await prefs.setString(_dateKey, _date);
        await prefs.setStringList(_completedKey, _completed.toList());
        await prefs.setInt(_juzKey, _juz);
        await prefs.setInt(_yunusKey, _yunus);
      } catch (_) {
        // Keep the personal log usable in memory when storage is unavailable.
      }
    });
    return _pendingSave;
  }
}
