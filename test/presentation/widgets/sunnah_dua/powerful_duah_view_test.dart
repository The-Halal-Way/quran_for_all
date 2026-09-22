import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/domain/repositories/settings_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/sunnah_dua/duah/powerful_duah_view.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/powerful_duah/powerful_duah_data.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/powerful_duah/powerful_duah_grid.dart';

void main() {
  testWidgets('searches Powerful Duahs across Arabic and localized content', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final settings = SettingsViewModel(const _FakeSettingsRepository());
    await settings.loadSettings();
    addTearDown(settings.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsViewModel>.value(
        value: settings,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: const PowerfulDuahView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final search = find.descendant(
      of: find.byKey(const ValueKey('powerful-duah-search')),
      matching: find.byType(TextField),
    );
    expect(search, findsOneWidget);
    expect(
      tester.widget<PowerfulDuahGrid>(find.byType(PowerfulDuahGrid)).items,
      hasLength(PowerfulDuahData.all.length),
    );

    await tester.enterText(search, 'رب زدني علما');
    await tester.pump();
    expect(
      tester
          .widget<PowerfulDuahGrid>(find.byType(PowerfulDuahGrid))
          .items
          .map((item) => item.number),
      [5],
    );

    await tester.enterText(search, 'ঋণ দারিদ্র্য');
    await tester.pump();
    expect(
      tester
          .widget<PowerfulDuahGrid>(find.byType(PowerfulDuahGrid))
          .items
          .map((item) => item.number),
      [4],
    );

    await tester.enterText(search, 'no-such-powerful-duah');
    await tester.pump();
    expect(find.byType(PowerfulDuahGrid), findsNothing);
    expect(find.text('No matches found'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(
      tester.widget<PowerfulDuahGrid>(find.byType(PowerfulDuahGrid)).items,
      hasLength(PowerfulDuahData.all.length),
    );
    expect(tester.takeException(), isNull);
  });
}

class _FakeSettingsRepository implements SettingsRepository {
  const _FakeSettingsRepository();

  @override
  Future<AppSettings> getSettings() async => AppSettings.defaults();

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
