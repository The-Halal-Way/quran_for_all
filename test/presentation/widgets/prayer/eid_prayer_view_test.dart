import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/views/prayer/eid_prayer/eid_prayer_view.dart';
import 'package:quran_for_all/presentation/widgets/prayer/eid_prayer/eid_kind_switcher.dart';

void main() {
  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '$locale $brightness shows the whole Eid guide on a small phone',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(320, 700));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: brightness == Brightness.dark
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.8)),
                child: child!,
              ),
              home: const EidPrayerView(),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.text(locale == 'bn' ? 'ঈদুল ফিতর' : 'Eid al-Fitr'),
            findsWidgets,
          );
          expect(
            find.text(
              locale == 'bn' ? 'ফিতরের বিশেষ আমল' : 'The Fitr distinction',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              locale == 'bn' ? 'আযহার বিশেষ আমল' : 'The Adha distinction',
            ),
            findsNothing,
          );
          expect(tester.takeException(), isNull);

          final adhaChoice = find.descendant(
            of: find.byType(EidKindSwitcher),
            matching: find.text(locale == 'bn' ? 'ঈদুল আযহা' : 'Eid al-Adha'),
          );
          await tester.tap(adhaChoice);
          await tester.pumpAndSettle();
          expect(
            find.text(
              locale == 'bn' ? 'আযহার বিশেষ আমল' : 'The Adha distinction',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              locale == 'bn' ? 'ফিতরের বিশেষ আমল' : 'The Fitr distinction',
            ),
            findsNothing,
          );

          for (final label in [
            locale == 'bn' ? 'নামাজের নিয়ম' : 'Prayer steps',
            locale == 'bn' ? 'দিনের আমল' : 'Day plan',
            locale == 'bn' ? 'যিকির ও দোয়া' : 'Dhikr & duas',
          ]) {
            await tester.ensureVisible(find.text(label));
            await tester.tap(find.text(label));
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            if (label == (locale == 'bn' ? 'দিনের আমল' : 'Day plan')) {
              expect(
                find.text(
                  locale == 'bn'
                      ? 'ঈদুল আযহার তালিকা'
                      : 'Eid al-Adha checklist',
                ),
                findsOneWidget,
              );
              expect(
                find.text(
                  locale == 'bn'
                      ? 'ঈদুল ফিতরের তালিকা'
                      : 'Eid al-Fitr checklist',
                ),
                findsNothing,
              );
            }
          }

          expect(
            find.text(locale == 'bn' ? 'কবুলের দোয়া' : 'Ask for acceptance'),
            findsOneWidget,
          );
          expect(
            find.text(
              locale == 'bn'
                  ? 'আযহায় কখন পাঠ করবেন'
                  : 'When to recite for Adha',
            ),
            findsOneWidget,
          );
          expect(
            find.text(locale == 'bn' ? 'উচ্চারণ' : 'PRONUNCIATION'),
            findsWidgets,
          );
        },
      );
    }
  }
}
