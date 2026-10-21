import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import '../data/datasources/remote/quran_api_service.dart';
import '../data/models/ayah_model.dart';
import '../domain/repositories/quran_repository.dart';

/// Reads downloaded Quran data when present, otherwise resolves one verse.
/// Nothing is fetched until a lesson's audio button is pressed. Sample metadata
/// stays separate from the reading database so it cannot mark a partial Quran
/// download as complete. AudioService caches the actual MP3 by the same ayah ID.
class LessonAudioSampleResolver {
  LessonAudioSampleResolver({
    required QuranRepository quranRepository,
    required QuranApiService apiService,
  }) : _quranRepository = quranRepository,
       _apiService = apiService;

  final QuranRepository _quranRepository;
  final QuranApiService _apiService;
  final _samples = <String, Future<AyahModel>>{};

  Future<AyahModel> resolve(int surahId, int ayahNumber) {
    if (surahId < 1 || surahId > 114 || ayahNumber < 1) {
      throw ArgumentError('Invalid lesson ayah reference.');
    }
    final key = '$surahId:$ayahNumber';
    return _samples[key] ??= _resolve(surahId, ayahNumber).catchError((
      Object error,
    ) {
      _samples.remove(key);
      throw error;
    });
  }

  Future<AyahModel> _resolve(int surahId, int ayahNumber) async {
    try {
      final local = await _quranRepository.getAyah(surahId, ayahNumber);
      if (local != null && _matches(local, surahId, ayahNumber)) return local;
    } catch (_) {
      // A missing or unavailable reading database must not block lesson audio.
    }
    final cached = await _readCached(surahId, ayahNumber);
    if (cached != null) return cached;

    final data = await _apiService.fetchAyah(
      surahId,
      ayahNumber,
      edition: AppConstants.arabicEdition,
    );
    final ayah = AyahModel.fromMergedApi(
      surahId: surahId,
      arabicAyah: data,
      audioBaseUrl: AppConstants.audioBaseUrl,
    );
    await _cache(ayah);
    return ayah;
  }

  bool _matches(AyahModel ayah, int surahId, int ayahNumber) =>
      ayah.surahId == surahId &&
      ayah.ayahNumber == ayahNumber &&
      ayah.id >= 1 &&
      ayah.id <= 6236 &&
      ayah.audioUrl == '${AppConstants.audioBaseUrl}/${ayah.id}.mp3';

  Future<File> _cacheFile(int surahId, int ayahNumber) async {
    final support = await getApplicationSupportDirectory();
    return File(
      path.join(
        support.path,
        'learn_quran_audio_samples',
        '${surahId}_$ayahNumber.json',
      ),
    );
  }

  Future<AyahModel?> _readCached(int surahId, int ayahNumber) async {
    try {
      final file = await _cacheFile(surahId, ayahNumber);
      if (!await file.exists()) return null;
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final ayah = AyahModel.fromMap(json);
      return _matches(ayah, surahId, ayahNumber) ? ayah : null;
    } catch (_) {
      return null; // A damaged cache can be fetched again on demand.
    }
  }

  Future<void> _cache(AyahModel ayah) async {
    try {
      final file = await _cacheFile(ayah.surahId, ayah.ayahNumber);
      await file.parent.create(recursive: true);
      final temporary = File('${file.path}.tmp');
      await temporary.writeAsString(jsonEncode(ayah.toMap()), flush: true);
      await temporary.rename(file.path);
    } catch (_) {
      // Caching is best effort; storage failure must not prevent playback.
    }
  }
}
