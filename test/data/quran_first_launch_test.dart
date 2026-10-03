import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:quran_for_all/core/constants/app_constants.dart';
import 'package:quran_for_all/data/datasources/local/app_database.dart';
import 'package:quran_for_all/data/datasources/remote/quran_api_service.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/data/models/surah_model.dart';
import 'package:quran_for_all/data/repositories/quran_repository_impl.dart';

class _MemoryQuranDatabase extends AppDatabase {
  bool hasData = false;
  List<AyahModel> insertedAyahs = [];

  @override
  Future<bool> hasQuranData() async => hasData;

  @override
  Future<bool> hasLocalizedTafsirData() async => false;

  @override
  Future<void> insertQuranData({
    required List<SurahModel> surahs,
    required List<AyahModel> ayahs,
  }) async {
    insertedAyahs = ayahs;
    hasData = true;
  }

  @override
  Future<void> saveTafsirData({
    required Map<int, String> tafsirEnByAyahId,
    required Map<int, String> tafsirBnByAyahId,
  }) async {}
}

class _EditionService extends QuranApiService {
  _EditionService(this.optionalEdition)
    : super(MockClient((_) async => http.Response('{}', 500)));

  final Completer<Map<String, dynamic>?> optionalEdition;

  @override
  Future<Map<String, dynamic>> fetchEdition(String edition) async => {
    'surahs': [
      {
        'number': 1,
        'name': 'الفاتحة',
        'englishName': 'Al-Fatiha',
        'ayahs': [
          {
            'number': 1,
            'numberInSurah': 1,
            'juz': 1,
            'hizbQuarter': 1,
            'page': 1,
            'text': edition == AppConstants.arabicEdition
                ? 'بِسْمِ ٱللَّهِ'
                : 'In the name of Allah',
          },
        ],
      },
    ],
  };

  @override
  Future<Map<String, dynamic>?> tryFetchEdition(String edition) {
    if (edition == AppConstants.transliterationBnEdition) {
      return Future.value(null);
    }
    if (edition == AppConstants.additionalEnglishEdition) {
      return optionalEdition.future;
    }
    return Future.value(null);
  }
}

void main() {
  test('Quran request times out when the server never responds', () async {
    final pending = Completer<http.Response>();
    final client = MockClient((_) => pending.future);
    final service = QuranApiService(
      client,
      requestTimeout: const Duration(milliseconds: 20),
    );

    await expectLater(
      service.fetchEdition(AppConstants.arabicEdition),
      throwsA(isA<TimeoutException>()),
    );
    await expectLater(
      service.tryFetchEdition(AppConstants.additionalEnglishEdition),
      completion(isNull),
    );
    client.close();
  });

  test(
    'core Quran becomes available before optional translations finish',
    () async {
      final database = _MemoryQuranDatabase();
      final optional = Completer<Map<String, dynamic>?>();
      final service = _EditionService(optional);
      final repository = QuranRepositoryImpl(
        database: database,
        apiService: service,
      );
      final ready = Completer<void>();
      var finished = false;
      final import = repository.importDataIfNeeded(
        onCoreDataReady: ready.complete,
      )..then((_) => finished = true);

      await ready.future;
      expect(await database.hasQuranData(), isTrue);
      expect(database.insertedAyahs, hasLength(1));
      expect(database.insertedAyahs.single.tafsirEn, isEmpty);
      expect(finished, isFalse);

      optional.complete(null);
      await import;
      expect(finished, isTrue);
    },
  );
}
