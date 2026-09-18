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
import 'package:quran_for_all/presentation/widgets/splash/splash_backdrop.dart';
import 'package:quran_for_all/presentation/widgets/splash/splash_branding.dart';

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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byType(SplashBackdrop), findsOneWidget);
      expect(find.byType(SplashBranding), findsOneWidget);
      expect(
        find.text(locale == 'bn' ? 'কুরআন ফর অল' : 'Quran For All'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('failed first setup shows the refined retry state', (
    tester,
  ) async {
    final repository = _SplashQuranRepository(fail: true);
    final viewModel = SplashViewModel(quranRepository: repository);
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      _SplashTestApp(viewModel: viewModel, locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Setup needs internet'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    expect(find.text('Retry setup'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
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
      home: const SplashView(),
    ),
  );
}

class _SplashQuranRepository implements QuranRepository {
  _SplashQuranRepository({this.fail = false});

  final bool fail;
  final Completer<void> _pending = Completer<void>();

  @override
  Future<void> importDataIfNeeded({void Function(String status)? onProgress}) {
    if (fail) return Future<void>.error(StateError('offline'));
    return _pending.future;
  }

  @override
  Future<bool> hasLocalData() async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
