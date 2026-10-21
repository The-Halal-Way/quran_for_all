import 'package:flutter_tts/flutter_tts.dart';

enum PronunciationFailure { arabicVoiceUnavailable, playbackFailed }

class PronunciationException implements Exception {
  const PronunciationException(this.failure);
  final PronunciationFailure failure;

  @override
  String toString() => 'PronunciationException(${failure.name})';
}

/// Selects a real Arabic voice, preferring installed offline voices. A generic
/// language request alone can leave an engine using its default English voice.
Future<Map<String, String>> selectArabicPronunciationVoice(
  FlutterTts tts,
) async {
  final raw = await tts.getVoices;
  final voices =
      <Map<String, String>>[
        if (raw is List)
          for (final item in raw)
            if (item is Map)
              item.map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
      ].where((voice) {
        final language = (voice['locale'] ?? '')
            .replaceAll('_', '-')
            .toLowerCase()
            .split('-')
            .first;
        final features = (voice['features'] ?? '').toLowerCase();
        return const {'ar', 'ara'}.contains(language) &&
            (voice['name'] ?? '').isNotEmpty &&
            !features.contains('notinstalled') &&
            !features.contains('not_installed');
      }).toList();
  voices.sort((a, b) {
    int rank(Map<String, String> voice) =>
        (voice['network_required'] == '1' ? 10 : 0) +
        (voice['locale'] == 'ar-SA' ? 0 : 1);
    return rank(a).compareTo(rank(b));
  });
  for (final voice in voices) {
    if (await tts.setLanguage(voice['locale']!) != 1) continue;
    final selected = {
      'name': voice['name']!,
      'locale': voice['locale']!,
      'identifier': ?voice['identifier'],
    };
    if (await tts.setVoice(selected) == 1) return selected;
  }
  throw const PronunciationException(
    PronunciationFailure.arabicVoiceUnavailable,
  );
}
