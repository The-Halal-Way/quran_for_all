import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/tasbeeh_repository.dart';
import '../models/tasbeeh_state.dart';

class TasbeehRepositoryImpl implements TasbeehRepository {
  static const _stateKey = 'tasbeeh_state_v1';

  @override
  Future<TasbeehSavedState?> loadState() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_stateKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      return TasbeehSavedState.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  @override
  Future<void> saveState(TasbeehSavedState state) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_stateKey, jsonEncode(state.toMap()));
  }
}
