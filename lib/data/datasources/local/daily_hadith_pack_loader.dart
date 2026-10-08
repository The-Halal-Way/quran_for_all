import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';

import 'daily_hadith_pack_parser.dart';

typedef DailyHadithAssetLoader = Future<String> Function(String path);
typedef DailyHadithParserRunner =
    Future<DailyHadithPack> Function(String raw);

class DailyHadithPackLoader {
  DailyHadithPackLoader({
    DailyHadithAssetLoader? assetLoader,
    DailyHadithParserRunner? parserRunner,
  }) : _assetLoader = assetLoader ?? rootBundle.loadString,
       _parserRunner = parserRunner ?? _parseInBackground;

  static const assetPath = 'assets/json/daily_hadith.json';

  final DailyHadithAssetLoader _assetLoader;
  final DailyHadithParserRunner _parserRunner;
  DailyHadithPack? _cache;
  Future<DailyHadithPack>? _inFlight;

  DailyHadithPack? get cachedPack => _cache;

  Future<DailyHadithPack> load({bool forceRefresh = false}) {
    if (!forceRefresh && _cache != null) return Future.value(_cache);
    if (_inFlight != null) return _inFlight!;
    final operation = _loadAndParse();
    _inFlight = operation;
    operation.whenComplete(() => _inFlight = null);
    return operation;
  }

  Future<DailyHadithPack> _loadAndParse() async {
    try {
      final raw = await _assetLoader(assetPath);
      final parsed = await _parserRunner(raw);
      _cache = parsed;
      return parsed;
    } catch (_) {
      final validCache = _cache;
      if (validCache != null) return validCache;
      rethrow;
    }
  }

  // Flutter's compute uses a worker isolate on native platforms. On web it
  // preserves behavior but runs on the browser event loop (no native isolate).
  static Future<DailyHadithPack> _parseInBackground(String raw) =>
      compute(parseDailyHadithPack, raw, debugLabel: 'daily-reminder-pack');
}
