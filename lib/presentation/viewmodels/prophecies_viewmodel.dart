import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/datasources/local/prophecies_pack_loader.dart';
import '../../data/models/prophecies/prophecy_book.dart';

class PropheciesViewModel extends ChangeNotifier {
  PropheciesViewModel(this._loader) {
    unawaited(load());
  }

  final PropheciesPackLoader _loader;
  ProphecyBook? _book;
  Object? _error;
  bool _loading = true;
  bool _disposed = false;

  ProphecyBook? get book => _book;
  Object? get error => _error;
  bool get loading => _loading;

  Future<void> load({bool forceRefresh = false}) async {
    if (_disposed) return;
    _loading = true;
    _error = null;
    _notify();
    try {
      _book = await _loader.load(forceRefresh: forceRefresh);
    } catch (error) {
      _error = error;
    } finally {
      _loading = false;
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
