import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/domain/repositories/quran_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/splash_viewmodel.dart';
import 'package:quran_for_all/presentation/views/splash/splash_view.dart';
import 'package:quran_for_all/presentation/widgets/quran/quran_download_panel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final locale in ['en', 'bn']) {
    testWidgets('$locale splash fits a compact phone with enlarged text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final repository = _SplashQuranRepository();
      final viewModel = SplashViewModel(quranRepository: repository);
      addTearDown(viewModel.dispose);

      await tester.pumpWidget(
        _SplashTestApp(viewModel: viewModel, locale: Locale(locale)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home opened'), findsOneWidget);
      expect(viewModel.isDownloading, isTrue);
      expect(viewModel.hasQuranData, isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('failed first download still opens home with retry available', (
    tester,
  ) async {
    final repository = _SplashQuranRepository(fail: true);
    final viewModel = SplashViewModel(quranRepository: repository);
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      _SplashTestApp(viewModel: viewModel, locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home opened'), findsOneWidget);
    expect(viewModel.isDownloading, isFalse);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AnimatedBuilder(
            animation: viewModel,
            builder: (context, _) => viewModel.hasQuranData
                ? const Text('Quran ready')
                : QuranDownloadPanel(model: viewModel),
          ),
        ),
      ),
    );
    expect(find.text('Retry Quran download'), findsOneWidget);
    repository.fail = false;
    repository.completeDownload();
    await tester.tap(find.text('Retry Quran download'));
    await tester.pumpAndSettle();
    expect(find.text('Quran ready'), findsOneWidget);
    expect(repository.importCalls, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saved Quran opens immediately while optional sync is pending', (
    tester,
  ) async {
    final repository = _SplashQuranRepository()..hasData = true;
    final viewModel = SplashViewModel(quranRepository: repository);
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      _SplashTestApp(viewModel: viewModel, locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home opened'), findsOneWidget);
    expect(viewModel.hasQuranData, isTrue);
    expect(viewModel.isDownloading, isTrue);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'bn']) {
    testWidgets('$locale Quran retry panel fits compact large text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final viewModel = SplashViewModel(
        quranRepository: _SplashQuranRepository(fail: true),
      );
      addTearDown(viewModel.dispose);
      await viewModel.initialize();
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuranDownloadPanel(model: viewModel),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}

class _SplashTestApp extends StatelessWidget {
  const _SplashTestApp({required this.viewModel, required this.locale});

  final SplashViewModel viewModel;
  final Locale locale;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: viewModel,
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.6)),
        child: child!,
      ),
      home: const SplashView(
        destination: Scaffold(body: Center(child: Text('Home opened'))),
      ),
    ),
  );
}

class _SplashQuranRepository implements QuranRepository {
  _SplashQuranRepository({this.fail = false});

  bool fail;
  bool hasData = false;
  int importCalls = 0;
  final Completer<void> _pending = Completer<void>();

  void completeDownload() => _pending.complete();

  @override
  Future<void> importDataIfNeeded({
    void Function(String status)? onProgress,
    void Function()? onCoreDataReady,
  }) async {
    importCalls++;
    if (fail) throw StateError('offline');
    await _pending.future;
    hasData = true;
    onCoreDataReady?.call();
  }

  @override
  Future<bool> hasLocalData() async => hasData;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
