import 'dart:convert';

import 'package:http/http.dart' as http;

class QuranApiService {
  QuranApiService(
    this._client, {
    this.requestTimeout = const Duration(seconds: 25),
  });

  final http.Client _client;
  final Duration requestTimeout;

  static const String _baseUrl = 'https://api.alquran.cloud/v1/quran';

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
