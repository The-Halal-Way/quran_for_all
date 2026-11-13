import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../models/sunnah/sunnah_catalog.dart';

/// The catalog stays off the Sunnah landing page's startup path. It is read
/// and indexed only after the user opens the Sunnah library.
class SunnahCatalogLoader {
  SunnahCatalogLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/json/sunnah_catalog.json';
  static Future<SunnahCatalog>? _rootCache;
  final AssetBundle _bundle;

  Future<SunnahCatalog> load() {
    if (!identical(_bundle, rootBundle)) return _load();
    return _rootCache ??= _load().catchError((Object error) {
      _rootCache = null;
      throw error;
    });
  }

  Future<SunnahCatalog> _load() async {
    final raw = await _bundle.loadString(assetPath);
    return compute(_parseSunnahCatalog, raw, debugLabel: 'sunnah-catalog');
  }
}

SunnahCatalog _parseSunnahCatalog(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! Map) throw const FormatException('Invalid Sunnah catalog');
  return SunnahCatalog.fromJson(Map<String, dynamic>.from(decoded));
}
