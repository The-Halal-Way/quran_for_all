import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/ruqyah/ruqyah_progress.dart';

/// One small local document. Mutations are serialized to avoid stale writes
/// when a reader counter, bookmark and display preference change together.
class RuqyahLocalStore {
  RuqyahLocalStore({Future<SharedPreferences> Function()? preferences})
    : _preferences = preferences ?? SharedPreferences.getInstance;

  static const key = 'ruqyah_reading_state_v1';
  final Future<SharedPreferences> Function() _preferences;
  Future<void>? _loading;
  Future<void>? _writes;
  RuqyahProgress? progress;
  Set<String> bookmarks = {};
  RuqyahReaderPreferences reader = const RuqyahReaderPreferences();

  Future<void> load() => _loading ??= _load().catchError((Object error) {
    _loading = null;
    throw error;
  });

  Future<void> _load() async {
    final prefs = await _preferences();
    final raw = prefs.getString(key);
    if (raw == null) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      progress = RuqyahProgress.tryParse(json['progress']);
      bookmarks =
          (json['bookmarks'] as List?)?.whereType<String>().toSet() ?? {};
      reader = RuqyahReaderPreferences.fromJson(json['reader']);
    } catch (_) {
      // A damaged local record does not prevent opening the offline content.
      progress = null;
      bookmarks = {};
      reader = const RuqyahReaderPreferences();
    }
  }

  Future<void> saveProgress(RuqyahProgress? value) {
    progress = value;
    return _save();
  }

  Future<void> toggleBookmark(String id) {
    bookmarks = Set.of(bookmarks);
    if (!bookmarks.remove(id)) bookmarks.add(id);
    return _save();
  }

  Future<void> saveReader(RuqyahReaderPreferences value) {
    reader = value;
    return _save();
  }

  Future<void> _save() {
    final raw = jsonEncode({
      'progress': progress?.toJson(),
      'bookmarks': bookmarks.toList()..sort(),
      'reader': reader.toJson(),
    });
    Future<void> writeRecord() async {
      final saved = await (await _preferences()).setString(key, raw);
      if (!saved) throw StateError('Could not save Ruqyah progress.');
    }

    final write = _writes == null
        ? writeRecord()
        : _writes!.then((_) => writeRecord());
    _writes = write.catchError((Object _) {});
    return write;
  }
}
