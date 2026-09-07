import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/domain/repositories/settings_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_destination_header.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_bottom_bar.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_header.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/hadith/common/hadith_reader_language_builder.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/daily_duah/daily_duah_card.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/daily_duah/daily_duah_data.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/powerful_duah/powerful_duah_data.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/duah/powerful_duah/powerful_duah_grid.dart';

void main() {
  testWidgets('dashboard destination hero fits compact Bengali content', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    var wentBack = false;

    await tester.pumpWidget(
      _TestApp(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppDestinationHeader(
            eyebrow: 'দোয়ার সংগ্রহ',
            title: 'প্রতিদিনের প্রয়োজনীয় দোয়া',
            subtitle: 'প্রতিটি মুহূর্তের জন্য সংক্ষিপ্ত দোয়া',
            artworkLabel: 'دعاء',
            icon: Icons.auto_awesome_rounded,
            accent: Colors.teal,
            onBack: () => wentBack = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    expect(wentBack, isTrue);
  });

  testWidgets('daily dua preview stays concise on a compact phone', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    var opened = false;

    await tester.pumpWidget(
      _TestApp(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DailyDuahCard(item: _dailyDuah, onTap: () => opened = true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.tap(find.text(_dailyDuah.title));
    expect(opened, isTrue);
  });

  testWidgets('powerful dua grid switches to one compact column', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    PowerfulDuah? opened;

    await tester.pumpWidget(
      _TestApp(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PowerfulDuahGrid(
            items: const [_powerfulDuah],
            onItemTap: (item) => opened = item,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.tap(find.text(_powerfulDuah.title));
    expect(opened, _powerfulDuah);
  });

  testWidgets('shared Hadith reader chrome fits Bengali navigation', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    var isBangla = true;
    var movedNext = false;

    await tester.pumpWidget(
      _TestApp(
        child: Column(
          children: [
            HadithReaderHeader(
              title: 'ইমাম নববীর চল্লিশ হাদিস',
              subtitle: 'সহজ পাঠ ও অনুশীলন',
              progressLabel: 'হাদিস ১২ • ১২/৪২',
              accent: Colors.pink,
              isBangla: isBangla,
              onBack: () {},
              onLanguageChanged: (value) => isBangla = value,
              onSearch: () {},
            ),
            const Spacer(),
            HadithReaderBottomBar(
              previousLabel: 'পূর্ববর্তী',
              nextLabel: 'পরবর্তী',
              centerLabel: 'ভূমিকা',
              centerIcon: Icons.menu_book_rounded,
              accent: Colors.pink,
              canPrevious: true,
              canNext: true,
              onPrevious: () {},
              onNext: () => movedNext = true,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('পরবর্তী'));
    expect(movedNext, isTrue);
    await tester.tap(find.text('বাং'));
    expect(isBangla, isFalse);
  });

  testWidgets('Hadith readers inherit and update the global language', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    final repository = _FakeSettingsRepository(
      AppSettings.defaults().copyWith(language: AppLanguage.bangla),
    );
    final viewModel = SettingsViewModel(repository);
    await viewModel.loadSettings();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: _TestApp(
          child: HadithReaderLanguageBuilder(
            builder: (context, isBangla, onLanguageChanged) => TextButton(
              onPressed: () => onLanguageChanged(!isBangla),
              child: Text(isBangla ? 'বাংলা সক্রিয়' : 'English active'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('বাংলা সক্রিয়'), findsOneWidget);
    await tester.tap(find.text('বাংলা সক্রিয়'));
    await tester.pump();

    expect(viewModel.settings.language, AppLanguage.english);
    expect(find.text('English active'), findsOneWidget);
    expect(repository.savedSettings?.language, AppLanguage.english);
  });
}

Future<void> _setCompactSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(320, 700));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }
}

const _dailyDuah = DuahItem(
  title: 'Before eating',
  arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
  pronunciation: 'Bismillahir Rahmanir Rahim',
  translation: 'In the name of Allah, the Most Merciful.',
);

const _powerfulDuah = PowerfulDuah(
  number: 1,
  title: 'Goodness in this life and the next',
  arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً',
  pronunciation: 'Rabbana atina fid-dunya hasanah',
  translation: 'Our Lord, give us good in this life and in the next.',
  situations: [DuahSituation.all],
  source: 'Qur\'an 2:201',
  isFeatured: true,
);

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this._settings);

  AppSettings _settings;
  AppSettings? savedSettings;

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    savedSettings = settings;
  }
}
