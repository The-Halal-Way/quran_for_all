import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class RuqyahTestBundle extends CachingAssetBundle {
  final loaded = <String>[];
  final overrides = <String, String>{};

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loaded.add(key);
    return overrides[key] ?? File(key).readAsStringSync();
  }

  @override
  Future<ByteData> load(String key) async => ByteData.sublistView(
    Uint8List.fromList(utf8.encode(await loadString(key))),
  );
}
