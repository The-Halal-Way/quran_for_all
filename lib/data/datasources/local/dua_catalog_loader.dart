import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../models/dua/dua_catalog.dart';

/// The dashboard and Sunnah tab never open this asset. Reading begins only
/// after the user enters the dua library; decoding runs outside the UI isolate.
class DuaCatalogLoader {
  DuaCatalogLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  static Future<DuaCatalog>? _cached;

  Future<DuaCatalog> load() {
    if (!identical(_bundle, rootBundle)) return _load();
    return _cached ??= _load().catchError((Object error) {
      _cached = null;
      throw error;
    });
  }

  Future<DuaCatalog> _load() async {
    final raw = await _bundle.loadString('assets/json/dua_catalog.json');
    return compute(_parse, raw, debugLabel: 'dua-catalog');
  }
}

DuaCatalog _parse(String raw) => DuaCatalog.fromJson(duaMap(jsonDecode(raw)));
