import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/data/models/daily_reminders/daily_reminder_pack.dart';
import 'package:quran_for_all/presentation/viewmodels/daily_reminders/daily_reminders_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/daily_reminders/daily_reminders_view/daily_reminder_card.dart';

import '../../support/daily_reminder_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DailyReminderPack pack;

  setUpAll(() async {
    pack = await loadDraftPack();
  });

  testWidgets('reminder card renders in dark mode with large text', (
    tester,
  ) async {
    final item = pack.items.first;
    final record = DailyReminderRecord(
      item: item,
      schedule: pack.schedule.first,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.dark,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              child: DailyReminderCard(
                record: record,
                edition: item.resolveEdition('en')!,
                l10n: AppLocalizations.of(context)!,
                dateLabel: '13 September',
                isRead: false,
                isSaved: false,
                onOpen: () {},
                onToggleSaved: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Renew your intention'), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.bookmark), findsOneWidget);
  });
}
