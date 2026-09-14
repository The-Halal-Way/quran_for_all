import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../models/daily_reminders/daily_reminder_pack.dart';
import 'daily_reminder_pack_parser.dart';

typedef DailyReminderAssetLoader = Future<String> Function(String path);
typedef DailyReminderParserRunner =
    Future<DailyReminderPack> Function(String raw);

class DailyReminderPackLoader {
  DailyReminderPackLoader({
    DailyReminderAssetLoader? assetLoader,
    DailyReminderParserRunner? parserRunner,
  }) : _assetLoader = assetLoader ?? rootBundle.loadString,
       _parserRunner = parserRunner ?? _parseInBackground;

  static const assetPath = 'assets/json/daily_reminders.json';

  final DailyReminderAssetLoader _assetLoader;
  final DailyReminderParserRunner _parserRunner;
  DailyReminderPack? _cache;
  Future<DailyReminderPack>? _inFlight;

  DailyReminderPack? get cachedPack => _cache;

  Future<DailyReminderPack> load({bool forceRefresh = false}) {
    if (!forceRefresh && _cache != null) return Future.value(_cache);
    if (_inFlight != null) return _inFlight!;
    final operation = _loadAndParse();
    _inFlight = operation;
    operation.whenComplete(() => _inFlight = null);
    return operation;
  }

  Future<DailyReminderPack> _loadAndParse() async {
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
  static Future<DailyReminderPack> _parseInBackground(String raw) =>
      compute(parseDailyReminderPack, raw, debugLabel: 'daily-reminder-pack');
}
