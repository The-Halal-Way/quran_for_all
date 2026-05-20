import 'dart:convert';

import 'package:http/http.dart' as http;

class QiblaApiService {
  const QiblaApiService();

  Future<double?> fetchQiblaDirection({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      'https://api.aladhan.com/v1/qibla/$latitude/$longitude',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      return null;
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    final dynamic data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      return null;
    }

    final dynamic direction = data['direction'];
    if (direction is num) {
      final normalized = direction.toDouble() % 360;
      return normalized < 0 ? normalized + 360 : normalized;
    }

    return null;
  }
}
