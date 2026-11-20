import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/datasources/local/ruqyah/ruqyah_asset_loader.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/repositories/ruqyah_repository.dart';
import 'package:quran_for_all/domain/repositories/settings_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/dashboard/ruqyah/ruqyah_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/ruqyah/ruqyah_reader_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/ruqyah/ruqyah_guide_view.dart';
import 'package:quran_for_all/presentation/widgets/ruqyah/guides/ruqyah_guide_card.dart';
import 'package:quran_for_all/presentation/widgets/ruqyah/guides/ruqyah_article_section.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/ruqyah/dashboard_ruqyah_section.dart';

import '../../../support/ruqyah_test_support.dart';

void main() {
  late RuqyahTestBundle bundle;
  late RuqyahRepository repository;
  late SettingsViewModel settings;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    bundle = RuqyahTestBundle();
    repository = RuqyahRepository(assets: RuqyahAssetLoader(bundle: bundle));
    settings = SettingsViewModel(_SettingsRepository());
  });
  tearDown(() {
    settings.dispose();
  });

  testWidgets('dashboard destination is compact and does not load content', (
    tester,
  ) async {
    await tester.pumpWidget(
      _App(
        settings: settings,
        child: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: DashboardRuqyahSection(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(bundle.loaded, isEmpty);
    expect(
      tester.getSize(find.byType(DashboardRuqyahSection)).height,
      lessThan(140),
    );
    expect(tester.takeException(), isNull);
  });

  for (final language in [AppLanguage.english, AppLanguage.bangla]) {
    for (final dark in [false, true]) {
      testWidgets(
        'hub fits 320px with enlarged ${language.code} text, dark=$dark',
        (tester) async {
          tester.view.physicalSize = const Size(320, 760);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await settings.setLanguage(language);
          await tester.pumpWidget(
            _App(
              settings: settings,
              scale: 1.6,
              dark: dark,
              child: RuqyahView(repository: repository),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(bundle.loaded, ['assets/json/ruqyah/index.json']);
          final l10n = lookupAppLocalizations(language.locale);
          await tester.tap(find.text(l10n.ruqyahLibrary));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.byKey(const ValueKey('ruqyah-search')), findsOneWidget);
          // Isolate parsing must finish in real async time before settling frames.
          await tester.runAsync(
            () => repository.assets.loadGuides(language.code),
          );
          await tester.tap(find.text(l10n.ruqyahLearn));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.enterText(
            find.byKey(const ValueKey('ruqyah-guide-search')),
            language == AppLanguage.english ? 'purity' : 'পবিত্রতা',
          );
          await tester.pumpAndSettle();
          final questions = (await repository.assets.loadIndex()).guideGroups
              .firstWhere((g) => g.id == 'questions')
              .title
              .inLanguage(language.code);
          final questionFilter = find.widgetWithText(ChoiceChip, questions);
          await tester.ensureVisible(questionFilter);
          await tester.tap(questionFilter);
          await tester.pumpAndSettle();
          expect(find.byType(RuqyahGuideCard), findsOneWidget);
          expect(
            bundle.loaded.any(
              (s) =>
                  s.endsWith(language.code == 'en' ? '_bn.json' : '_en.json'),
            ),
            isFalse,
          );
        },
      );
    }
  }

  for (final language in [AppLanguage.english, AppLanguage.bangla]) {
    testWidgets(
      'article has navigable sections and opens related reading in ${language.code}',
      (tester) async {
        tester.view.physicalSize = const Size(320, 760);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await settings.setLanguage(language);
        await tester.runAsync(
          () => repository.assets.loadGuides(language.code),
        );
        await tester.pumpWidget(
          _App(
            settings: settings,
            scale: 1.6,
            dark: true,
            child: RuqyahGuideView(
              repository: repository,
              guideId: 'pain_method',
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(RuqyahArticleSection), findsNWidgets(4));
        expect(bundle.loaded.any((p) => p.contains('readings')), isFalse);
        // The table of contents scrolls the surrounding page; source expansion
        // has its own storage key, independent of that scroll position.
        final lastChip = find.byType(ActionChip).last;
        await tester.ensureVisible(lastChip);
        await tester.tap(lastChip);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final l10n = lookupAppLocalizations(language.locale);
        final source = find
            .widgetWithText(ExpansionTile, l10n.ruqyahSources)
            .last;
        await tester.ensureVisible(source);
        await tester.tap(source);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final readingTitle = (await repository.assets.loadIndex()).readings
            .firstWhere((r) => r.id == 'pain_refuge')
            .title
            .inLanguage(language.code);
        final readingLink = find.widgetWithText(ListTile, readingTitle);
        await tester.ensureVisible(readingLink);
        await tester.tap(readingLink);
        await tester.pumpAndSettle();
        expect(find.byType(RuqyahReaderView), findsOneWidget);
        expect(tester.takeException(), isNull);
        expect(
          bundle.loaded.any(
            (p) => p.endsWith(language.code == 'en' ? '_bn.json' : '_en.json'),
          ),
          isFalse,
        );
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
      },
    );
  }

  testWidgets(
    'reader swipes, scrolls from text and preserves its place when language changes',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _App(
          settings: settings,
          child: RuqyahReaderView(repository: repository, routineId: 'self'),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final title = find.text('Al-Fatihah');
      final top = tester.getTopLeft(title).dy;
      await tester.dragFrom(const Offset(170, 350), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(title).dy, lessThan(top));
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(repository.store.progress!.index, 1);
      await settings.setLanguage(AppLanguage.bangla);
      await tester.pumpAndSettle();
      expect(repository.store.progress!.index, 1);
      expect(find.text('সূরা আল-ফালাক'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'pain reader has visible three/seven counters and survives enlarged Bengali text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await settings.setLanguage(AppLanguage.bangla);
      await tester.pumpWidget(
        _App(
          settings: settings,
          scale: 1.6,
          dark: true,
          child: RuqyahReaderView(repository: repository, routineId: 'pain'),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = lookupAppLocalizations(const Locale('bn'));
      for (var n = 0; n < 3; n++) {
        await tester.tap(find.textContaining(l10n.ruqyahCountTap));
        await tester.pumpAndSettle();
      }
      expect(repository.store.progress!.counts[0], 3);
      await tester.tap(find.widgetWithText(FilledButton, l10n.ruqyahNext));
      await tester.pumpAndSettle();
      expect(find.textContaining('০ / ৭'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    },
  );
}

class _App extends StatelessWidget {
  const _App({
    required this.settings,
    required this.child,
    this.scale = 1,
    this.dark = false,
  });
  final SettingsViewModel settings;
  final Widget child;
  final double scale;
  final bool dark;
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: settings,
    child: ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        locale: settings.settings.language.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: child,
      ),
    ),
  );
}

class _SettingsRepository implements SettingsRepository {
  AppSettings settings = AppSettings.defaults();
  @override
  Future<AppSettings> getSettings() async => settings;
  @override
  Future<void> saveSettings(AppSettings value) async {
    settings = value;
  }
}
