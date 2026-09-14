import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/prayer/prayer_detail_models.dart';
import 'package:quran_for_all/presentation/models/sunnah_dua_item.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/widgets/prayer/prayer_view/prayer_timeline_grid.dart';
import 'package:quran_for_all/presentation/widgets/settings/settings_view/settings_choice_segment.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_card.dart';
import 'package:quran_for_all/presentation/widgets/sunnah_dua/sunnah_dua_view/sunnah_dua_grid.dart';

void main() {
  testWidgets('prayer rhythm remains readable on a compact phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _TestApp(width: 288, child: PrayerTimelineGrid(items: _prayerItems)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fajr'), findsOneWidget);
    expect(find.text('5:04 AM'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dua cards keep long Bengali titles inside a two-column grid', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SunnahDuaItem? selectedItem;

    await tester.pumpWidget(
      _TestApp(
        width: 288,
        child: SunnahDuaGrid(
          items: _duaItems,
          kindLabelBuilder: (_) => 'দুয়া',
          onItemTap: (item) => selectedItem = item,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SunnahDuaCard), findsNWidgets(2));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text(_duaItems.first.title));
    expect(selectedItem, _duaItems.first);
  });

  testWidgets('settings choices scale long labels without overflowing', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var selectedValue = 0;

    await tester.pumpWidget(
      _TestApp(
        width: 288,
        child: Row(
          children: [
            for (var value = 0; value < 3; value++) ...[
              Expanded(
                child: SettingsChoiceSegment<int>(
                  value: value,
                  selectedValue: selectedValue,
                  label: _settingsLabels[value],
                  icon: Icons.language_rounded,
                  accent: Colors.teal,
                  onSelected: (value) => selectedValue = value,
                ),
              ),
              if (value < 2) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.tap(find.text(_settingsLabels.last));
    expect(selectedValue, 2);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: width, child: child),
        ),
      ),
    );
  }
}

const _prayerItems = [
  PrayerTimelineItem(
    prayer: PrayerKey.fajr,
    name: 'Fajr',
    time: '5:04 AM',
    isCurrent: true,
    isFocus: true,
    isPassed: false,
  ),
  PrayerTimelineItem(
    prayer: PrayerKey.sunrise,
    name: 'Sunrise',
    time: '6:18 AM',
    isCurrent: false,
    isFocus: false,
    isPassed: false,
  ),
];

const _duaItems = [
  SunnahDuaItem(
    id: 'morning',
    kind: SunnahDuaKind.dua,
    icon: Icons.wb_sunny_outlined,
    accent: Colors.teal,
    gradientColors: [Colors.teal, Colors.green],
    title: 'সকালের দীর্ঘ ও বরকতময় দোয়া',
    subtitle: 'দিনের শুরুতে পড়ার জন্য',
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    pronunciation: 'Rabbi zidni ilma',
    translation: 'My Lord, increase me in knowledge.',
    practice: 'Read in the morning.',
    source: 'Quran 20:114',
  ),
  SunnahDuaItem(
    id: 'evening',
    kind: SunnahDuaKind.dhikr,
    icon: Icons.nights_stay_outlined,
    accent: Colors.deepPurple,
    gradientColors: [Colors.deepPurple, Colors.indigo],
    title: 'সন্ধ্যার স্মরণ ও প্রশান্তির যিকির',
    subtitle: 'দিন শেষে পড়ার জন্য',
    arabic: 'سُبْحَانَ اللَّهِ',
    pronunciation: 'SubhanAllah',
    translation: 'Glory be to Allah.',
    practice: 'Read in the evening.',
    source: 'Sahih Muslim',
  ),
];

const _settingsLabels = ['সিস্টেম অনুযায়ী', 'উজ্জ্বল থিম', 'গাঢ় থিম'];
