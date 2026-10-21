import 'dart:convert';

import 'package:http/http.dart' as http;

class QuranApiService {
  QuranApiService(
    this._client, {
    this.requestTimeout = const Duration(seconds: 25),
  });

  final http.Client _client;
  final Duration requestTimeout;

  static const String _apiRoot = 'https://api.alquran.cloud/v1';
  static const String _baseUrl = '$_apiRoot/quran';

  /// Resolves a lesson sample without downloading a whole Quran edition.
  /// API reference: https://alquran.cloud/api (GET /ayah/{reference}/{edition}).
  Future<Map<String, dynamic>> fetchAyah(
    int surahId,
    int ayahNumber, {
    required String edition,
  }) async {
    if (surahId < 1 || surahId > 114 || ayahNumber < 1) {
      throw ArgumentError('Invalid ayah reference: $surahId:$ayahNumber');
    }
    final response = await _client
        .get(Uri.parse('$_apiRoot/ayah/$surahId:$ayahNumber/$edition'))
        .timeout(requestTimeout);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch ayah: $surahId:$ayahNumber');
    }
    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'];
    if (payload['status'] != 'OK' ||
        data is! Map<String, dynamic> ||
        data['surah'] is! Map ||
        data['surah']['number'] != surahId ||
        data['numberInSurah'] != ayahNumber ||
        data['number'] is! int ||
        (data['number'] as int) < 1 ||
        (data['number'] as int) > 6236 ||
        data['text'] is! String ||
        (data['text'] as String).trim().isEmpty) {
      throw const FormatException('Invalid lesson ayah response.');
    }
    return data;
  }

  Future<Map<String, dynamic>> fetchEdition(String edition) async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/$edition'))
        .timeout(requestTimeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch edition: $edition');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if ((data['status'] as String?) != 'OK') {
      throw Exception('Invalid API response for edition: $edition');
    }

    return data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> tryFetchEdition(String edition) async {
    try {
      return await fetchEdition(edition);
    } catch (_) {
      return null;
    }
  }
}
