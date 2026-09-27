import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/ayah_model.dart';
import 'package:quran_for_all/data/models/surah_model.dart';
import 'package:quran_for_all/domain/repositories/settings_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/audio_control_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/quran/read_quran/surah_details_view.dart';
import 'package:quran_for_all/presentation/views/quran/read_quran/read_quran_view.dart';
import 'package:quran_for_all/presentation/widgets/ayah_tile.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_ayah_list.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/home/surah_card.dart';

import '../../../../support/quran_reader_fakes.dart';

void main() {
  late _LongSurahRepository quran;
  late ReaderAudioRepository audio;
  late AudioControlViewModel controls;
  late SurahDetailsViewModel model;
  late SettingsViewModel settings;
  late ReadQuranViewModel readQuran;
  late ScrollController scroll;

  setUp(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    quran = _LongSurahRepository();
    audio = ReaderAudioRepository();
    controls = AudioControlViewModel(audioRepository: audio);
    model = SurahDetailsViewModel(
      quranRepository: quran,
      audioRepository: audio,
      audioControlViewModel: controls,
    );
    settings = SettingsViewModel(_SettingsRepository());
    readQuran = ReadQuranViewModel(quran);
    scroll = ScrollController();
    await model.openSurah(readerSurah(2));
    await settings.loadSettings();
    await readQuran.load();
  });

  tearDown(() async {
    model.dispose();
    controls.dispose();
    settings.dispose();
    readQuran.dispose();
    scroll.dispose();
    await audio.dispose();
  });

  Widget app(Widget child) => ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (context, _) => MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: model),
        ChangeNotifierProvider.value(value: controls),
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: readQuran),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: Scaffold(body: child),
      ),
    ),
  );

  testWidgets('long surah only builds cards near the viewport', (tester) async {
    await tester.pumpWidget(
      app(
        SurahAyahList(
          controller: scroll,
          ayahKeys: {},
          highlightedAyahNumber: null,
          onLastReadMarked: (_) {},
          playAyahWithFeedback: (_, vm, ayah) => vm.playAyah(ayah),
          playBismillahWithFeedback: (_, vm) => vm.playBismillah(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(model.ayahs.length, 286);
    expect(find.byType(AyahTile).evaluate().length, lessThan(10));
    expect(find.text('2:1'), findsOneWidget);
    expect(find.text('2:286'), findsNothing);

    unawaited(model.playAyah(model.ayahs.first));
    await tester.pumpAndSettle();
    final otherAyah = find.byWidgetPredicate(
      (widget) => widget is AyahTile && widget.ayah.ayahNumber == 2,
    );
    final before = tester.widget<AyahTile>(otherAyah);

    audio.durations.add(const Duration(seconds: 10));
    audio.positions.add(const Duration(seconds: 5));
    await tester.pump();

    expect(identical(before, tester.widget<AyahTile>(otherAyah)), isTrue);
    final playing = tester.widget<AyahTile>(
      find.byWidgetPredicate(
        (widget) => widget is AyahTile && widget.ayah.ayahNumber == 1,
      ),
    );
    expect(playing.playbackProgress, 0.5);

    await model.stopPlayback();
    scroll.jumpTo(scroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(find.byType(AyahTile).evaluate().length, lessThan(10));
    expect(find.text('2:286'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('initial jump reaches a distant ayah in the lazy list', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(SurahDetailsView(surah: readerSurah(2), initialAyahNumber: 250)),
    );
    for (var i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 40));
    }

    expect(find.text('2:250'), findsOneWidget);
    expect(find.byType(AyahTile).evaluate().length, lessThan(10));
    expect(tester.takeException(), isNull);
  });

  testWidgets('switching reading modes keeps ayah anchors valid', (
    tester,
  ) async {
    final keys = <int, GlobalKey>{};
    await settings.setReadingViewMode(ReadingViewMode.regularView);
    await tester.pumpWidget(
      app(
        SurahAyahList(
          controller: scroll,
          ayahKeys: keys,
          highlightedAyahNumber: null,
          onLastReadMarked: (_) {},
          playAyahWithFeedback: (_, vm, ayah) => vm.playAyah(ayah),
          playBismillahWithFeedback: (_, vm) => vm.playBismillah(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(keys[250]?.currentContext, isNotNull);

    await settings.setReadingViewMode(ReadingViewMode.detailsView);
    await tester.pumpAndSettle();
    expect(find.byType(AyahTile).evaluate().length, lessThan(10));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Quran library builds only visible surah rows', (tester) async {
    await tester.pumpWidget(app(const ReadQuranView()));
    await tester.pumpAndSettle();

    expect(readQuran.surahs, hasLength(114));
    expect(find.byType(SurahCard).evaluate().length, lessThan(20));
    expect(find.text('Surah 114'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opening a surah displays a named loading state', (tester) async {
    model.dispose();
    final gatedQuran = _GatedLongSurahRepository();
    model = SurahDetailsViewModel(
      quranRepository: gatedQuran,
      audioRepository: audio,
      audioControlViewModel: controls,
    );

    final opening = model.openSurah(readerSurah(2));
    await tester.pumpWidget(app(SurahDetailsView(surah: readerSurah(2))));
    await tester.pump();
    expect(find.text('Opening surah'), findsOneWidget);
    expect(find.text('Loading ayahs from offline storage...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    gatedQuran.release.complete();
    await opening;
    await tester.pumpAndSettle();
    expect(find.byType(AyahTile), findsWidgets);
  });

  testWidgets('tafsir is fetched when its sheet opens', (tester) async {
    await tester.pumpWidget(
      app(
        SurahAyahList(
          controller: scroll,
          ayahKeys: {},
          highlightedAyahNumber: null,
          onLastReadMarked: (_) {},
          playAyahWithFeedback: (_, vm, ayah) => vm.playAyah(ayah),
          playBismillahWithFeedback: (_, vm) => vm.playBismillah(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(quran.tafsirReads, 0);

    await tester.tap(find.text('Tafsir').first);
    await tester.pumpAndSettle();
    expect(quran.tafsirReads, 1);
    expect(find.text('A short tafsir for the selected ayah.'), findsOneWidget);
  });
}

class _LongSurahRepository extends ReaderQuranRepository {
  int tafsirReads = 0;

  @override
  Future<List<SurahModel>> getAllSurahs() async =>
      List.generate(114, (index) => readerSurah(index + 1));

  @override
  Future<Set<int>> getBookmarkedSurahIds() async => {};

  @override
  Future<AyahModel?> getAyah(int surahId, int ayahNumber) async {
    if (surahId == 1) return super.getAyah(surahId, ayahNumber);
    tafsirReads++;
    final ayah = readerAyah(surahId: surahId, number: ayahNumber);
    return AyahModel(
      id: ayah.id,
      surahId: ayah.surahId,
      ayahNumber: ayah.ayahNumber,
      juzNumber: ayah.juzNumber,
      hizbQuarter: ayah.hizbQuarter,
      pageNumber: ayah.pageNumber,
      arabicText: ayah.arabicText,
      transliterationEn: ayah.transliterationEn,
      transliterationBn: ayah.transliterationBn,
      translationEn: ayah.translationEn,
      translationBn: ayah.translationBn,
      tafsirEn: 'A short tafsir for the selected ayah.',
      tafsirBn: '',
      audioUrl: ayah.audioUrl,
    );
  }

  @override
  Future<List<AyahModel>> getAyahsBySurah(int surahId) async => List.generate(
    286,
    (index) => readerAyah(
      id: index + 8,
      surahId: surahId,
      number: index + 1,
      arabic: List.filled(index % 4 + 1, baqaraArabic).join(' '),
    ),
  );
}

class _GatedLongSurahRepository extends _LongSurahRepository {
  final release = Completer<void>();

  @override
  Future<List<AyahModel>> getAyahsBySurah(int surahId) async {
    await release.future;
    return super.getAyahsBySurah(surahId);
  }
}

class _SettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> getSettings() async => AppSettings.defaults();
  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
