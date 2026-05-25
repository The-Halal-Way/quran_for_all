import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quran_for_all/data/models/dashboard/ninety_nine_names.dart';

class NintyNineNamesViewModel extends ChangeNotifier {
  static const String assetPath = 'assets/json/ninty_nine_names.json';

  NintyNineNames? _data;
  bool _isLoading = false;
  String? _error;

  NintyNineNames? get data => _data;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _data != null;

  List<String> get categories {
    final names = _data?.names ?? const <Name>[];
    return names.map((name) => name.category).toSet().toList()..sort();
  }

  Future<void> load() async {
    if (_isLoading || _data != null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final rawJson = await rootBundle.loadString(assetPath);
      _data = nintyNineNamesFromJson(rawJson);
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reload() async {
    _data = null;
    await load();
  }
}
