import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/enums/reading_view_mode.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/domain/repositories/settings_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/audio_control_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/surah_details_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/ayah_tile.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_ayah_list.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/surah_details/surah_bismillah_card.dart';

import '../../../../support/quran_reader_fakes.dart';

void main() {
  late ReaderAudioRepository audio;
  late AudioControlViewModel controls;
  late SurahDetailsViewModel model;
  late SettingsViewModel settings;
  late ScrollController scroll;

  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    audio = ReaderAudioRepository();
    controls = AudioControlViewModel(audioRepository: audio);
    model = SurahDetailsViewModel(
      quranRepository: ReaderQuranRepository(),
      audioRepository: audio,
      audioControlViewModel: controls,
    );
    settings = SettingsViewModel(_SettingsRepository());
    scroll = ScrollController();
  });
  tearDown(() async {
    model.dispose();
    controls.dispose();
    settings.dispose();
    scroll.dispose();
    await audio.dispose();
  });

  Future<void> pump(
    WidgetTester tester, {
    int surah = 2,
    AppLanguage language = AppLanguage.english,
    ReadingViewMode mode = ReadingViewMode.detailsView,
    Brightness brightness = Brightness.light,
    double scale = 1,
  }) async {
    await model.openSurah(readerSurah(surah));
    await settings.loadSettings();
    await settings.setLanguage(language);
    await settings.setReadingViewMode(mode);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: model),
            ChangeNotifierProvider.value(value: controls),
            ChangeNotifierProvider.value(value: settings),
          ],
          child: MaterialApp(
            locale: Locale(language == AppLanguage.bangla ? 'bn' : 'en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: brightness == Brightness.dark
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: Scaffold(
              body: SurahAyahList(
                controller: scroll,
                ayahKeys: {},
                highlightedAyahNumber: null,
                onLastReadMarked: (_) {},
                playAyahWithFeedback: (_, vm, ayah) => vm.playAyah(ayah),
                playBismillahWithFeedback: (_, vm) => vm.playBismillah(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'opening is a separate unnumbered card with working play and stop',
    (tester) async {
      await pump(tester);
      expect(find.byType(SurahBismillahCard), findsOneWidget);
      expect(find.text(bismillahArabic), findsOneWidget);
      expect(find.text(baqaraArabic), findsOneWidget);
      expect(find.text('2:1'), findsOneWidget);
      expect(find.text('2:0'), findsNothing);
      expect(find.text('1:1'), findsNothing);
      final opening = find.byType(SurahBismillahCard);
      final verse = find.byType(AyahTile);
      expect(
        tester.getTopLeft(opening).dy,
        lessThan(tester.getTopLeft(verse).dy),
      );
      await tester.tap(find.byTooltip('Play Bismillah'));
      await tester.pumpAndSettle();
      expect(audio.tracks.single.id, 1);
      expect(find.byTooltip('Stop Bismillah'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      await tester.tap(find.byTooltip('Stop Bismillah'));
      await tester.pumpAndSettle();
      expect(model.isPlayingBismillah, isFalse);
      expect(find.byTooltip('Play Bismillah'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'regular reading mode separates the opening from the verse text',
    (tester) async {
      await pump(tester, mode: ReadingViewMode.regularView);
      expect(find.byType(SurahBismillahCard), findsOneWidget);
      expect(find.text(bismillahArabic), findsOneWidget);
      final verse = tester.widget<Text>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              (widget.textSpan?.toPlainText().contains(baqaraArabic) ?? false),
        ),
      );
      expect(verse.textSpan!.toPlainText(), isNot(contains(bismillahArabic)));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'pronunciation and translation toggles also apply to the opening',
    (tester) async {
      await pump(tester);
      final opening = find.byType(SurahBismillahCard);
      final source = model.openingBismillah!.source;
      expect(
        find.descendant(
          of: opening,
          matching: find.text(source.transliterationEn),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: opening, matching: find.text(source.translationEn)),
        findsOneWidget,
      );
      await settings.setShowPronunciation(false);
      await settings.setShowTranslation(false);
      await tester.pumpAndSettle();
      expect(find.text(source.transliterationEn), findsNothing);
      expect(find.text(source.translationEn), findsNothing);
      expect(find.text(bismillahArabic), findsOneWidget);
      expect(find.byTooltip('Play Bismillah'), findsOneWidget);
    },
  );

  for (final surah in [1, 9]) {
    testWidgets('surah $surah has no extra Bismillah card or control', (
      tester,
    ) async {
      await pump(tester, surah: surah);
      expect(find.byType(SurahBismillahCard), findsNothing);
      expect(find.byTooltip('Play Bismillah'), findsNothing);
      expect(find.text('$surah:1'), findsOneWidget);
      expect(
        find.text(bismillahArabic),
        surah == 1 ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final language in AppLanguage.values) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'opening fits 320px with enlarged $language text in $brightness',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(320, 700));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await pump(
            tester,
            language: language,
            brightness: brightness,
            scale: 1.8,
          );
          final source = model.openingBismillah!.source;
          expect(
            find.text(source.transliterationFor(language)),
            findsOneWidget,
          );
          expect(
            find.text(
              language == AppLanguage.bangla
                  ? source.translationBn
                  : source.translationEn,
            ),
            findsOneWidget,
          );
          final arabic = tester.widget<Text>(find.text(bismillahArabic));
          final scheme = brightness == Brightness.dark
              ? AppTheme.darkTheme.colorScheme
              : AppTheme.lightTheme.colorScheme;
          expect(arabic.style?.color, scheme.onSurface);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

class _SettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> getSettings() async => AppSettings.defaults();
  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
