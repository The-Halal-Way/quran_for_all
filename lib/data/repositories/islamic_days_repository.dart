import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/islamic_days/islamic_day.dart';
import '../models/islamic_days/islamic_days_preferences.dart';

/// Local feature storage; the feature deliberately has no domain layer.
class IslamicDaysRepository {
  static const _prefix = 'islamic_days_v1_';

  Future<List<IslamicDay>> loadCatalog() async {
    final raw = await rootBundle.loadString('assets/json/islamic_days.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    if (decoded['schemaVersion'] != 1) {
      throw const FormatException('Unsupported Islamic Days catalog');
    }
    final events = (decoded['events'] as List)
        .map((entry) => IslamicDay.fromJson(entry as Map<String, dynamic>))
        .toList();
    if (events.map((event) => event.id).toSet().length != events.length) {
      throw const FormatException('Duplicate Islamic day ID');
    }
    return List.unmodifiable(events);
  }

  Future<IslamicDaysPreferences> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_prefix}preferences');
    if (raw == null) return const IslamicDaysPreferences();
    try {
      return IslamicDaysPreferences.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const IslamicDaysPreferences();
    }
  }

  Future<void> savePreferences(IslamicDaysPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(
      '${_prefix}preferences',
      jsonEncode(preferences.toJson()),
    )) {
      throw StateError('Could not save Islamic Days preferences');
    }
  }

  Future<Set<String>> loadSet(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('$_prefix$name') ?? const <String>[]).toSet();
  }

  Future<void> saveSet(String name, Set<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setStringList('$_prefix$name', values.toList()..sort())) {
      throw StateError('Could not save Islamic Days $name');
    }
  }
}
