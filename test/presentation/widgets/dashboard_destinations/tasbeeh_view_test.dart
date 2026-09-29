import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/tasbeeh_state.dart';
import 'package:quran_for_all/domain/repositories/settings_repository.dart';
import 'package:quran_for_all/domain/repositories/tasbeeh_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/tasbeeh_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/views/dashboard/tasbeeh/tasbeeh_focus_view.dart';
import 'package:quran_for_all/presentation/views/dashboard/tasbeeh/tasbeeh_view.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/tasbeeh/tasbeeh_counter_ring.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/tasbeeh/tasbeeh_phrase_menu.dart';
import 'package:quran_for_all/presentation/widgets/dashboard/tasbeeh/tasbeeh_undo_button.dart';

void main() {
  late TasbeehViewModel model;
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    model = TasbeehViewModel(repository: _MemoryRepository());
  });
  tearDown(() => model.dispose());

  Future<void> pump(
    WidgetTester tester, {
    bool focus = false,
    String locale = 'en',
    Brightness brightness = Brightness.light,
    double scale = 1,
  }) async {
    await model.load();
    await tester.pumpWidget(
      _TestApp(
        model: model,
        home: focus ? const TasbeehFocusView() : const TasbeehView(),
        locale: locale,
        brightness: brightness,
        scale: scale,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'custom dhikr validates, adds, edits and deletes with protected built-ins',
    (tester) async {
      await pump(tester);
      expect(find.byType(TasbeehPhraseMenu), findsNothing);
      await tapVisible(tester, find.byKey(const ValueKey('tasbeeh_add')));
      await tapVisible(tester, find.text('Save dhikr'));
      expect(find.text('Enter a name for your dhikr'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('tasbeeh_name_field')),
        'Astaghfirullah',
      );
      await tester.enterText(
        find.byKey(const ValueKey('tasbeeh_arabic_field')),
        'أَسْتَغْفِرُ الله',
      );
      await tester.enterText(
        find.byKey(const ValueKey('tasbeeh_meaning_field')),
        'I seek Allah’s forgiveness.',
      );
      await tester.enterText(
        find.byKey(const ValueKey('tasbeeh_target_field')),
        '70',
      );
      await tapVisible(tester, find.text('Save dhikr'));
      final id = model.selectedPhraseId;
      expect(model.phrases, hasLength(5));
      expect(model.target, 70);
      expect(model.selectedPhrase.meaning, 'I seek Allah’s forgiveness.');
      expect(find.text('I seek Allah’s forgiveness.'), findsWidgets);
      model.increment();
      model.increment();
      await tester.pumpAndSettle();
      final menu = find.descendant(
        of: find.byKey(ValueKey(id)),
        matching: find.byType(TasbeehPhraseMenu),
      );
      await tapVisible(tester, menu);
      await tester.tap(find.text('Edit dhikr'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('tasbeeh_name_field')),
        'Daily istighfar',
      );
      await tapVisible(tester, find.text('Save dhikr'));
      expect(model.selectedPhrase.name, 'Daily istighfar');
      expect(model.selectedPhrase.meaning, 'I seek Allah’s forgiveness.');
      expect(model.count, 2);
      await tapVisible(tester, menu);
      await tester.tap(find.text('Delete dhikr'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(model.phrases, hasLength(5));
      await tapVisible(tester, menu);
      await tester.tap(find.text('Delete dhikr'));
      await tester.pumpAndSettle();
      await tester.tap(
        find
            .descendant(
              of: find.byType(AlertDialog),
              matching: find.text('Delete dhikr'),
            )
            .last,
      );
      await tester.pumpAndSettle();
      expect(model.phrases, hasLength(4));
      expect(model.selectedPhraseId, 'subhanAllah');
      expect(find.byType(TasbeehPhraseMenu), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final locale in ['en', 'bn']) {
    testWidgets('a $locale suggestion fills the new dhikr editor', (
      tester,
    ) async {
      await pump(tester, locale: locale);
      await tapVisible(tester, find.byKey(const ValueKey('tasbeeh_add')));
      expect(
        find.text(locale == 'en' ? 'Common dhikr' : 'প্রচলিত জিকির'),
        findsOneWidget,
      );
      await tapVisible(
        tester,
        find.byKey(const ValueKey('tasbeeh_suggestion_0')),
      );
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('tasbeeh_name_field')),
            )
            .controller!
            .text,
        locale == 'en' ? 'Astaghfirullah' : 'আস্তাগফিরুল্লাহ',
      );
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('tasbeeh_arabic_field')),
            )
            .controller!
            .text,
        'أَسْتَغْفِرُ اللَّهَ',
      );
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('tasbeeh_meaning_field')),
            )
            .controller!
            .text,
        locale == 'en'
            ? "I seek Allah's forgiveness."
            : 'আমি আল্লাহর কাছে ক্ষমা চাই।',
      );
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const ValueKey('tasbeeh_target_field')),
            )
            .controller!
            .text,
        '33',
      );
      await tapVisible(
        tester,
        find.text(locale == 'en' ? 'Save dhikr' : 'জিকির সংরক্ষণ'),
      );
      expect(model.selectedPhrase.arabic, 'أَسْتَغْفِرُ اللَّهَ');
      expect(model.selectedPhrase.meaning, isNotEmpty);
      expect(model.target, 33);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('later dhikr suggestions remain selectable by scrolling', (
    tester,
  ) async {
    await pump(tester);
    await tapVisible(tester, find.byKey(const ValueKey('tasbeeh_add')));
    await tester.drag(find.byType(ListView), const Offset(-1400, 0));
    await tester.pumpAndSettle();
    await tapVisible(
      tester,
      find.byKey(const ValueKey('tasbeeh_suggestion_8')),
    );
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('tasbeeh_name_field')),
          )
          .controller!
          .text,
      'Ya Hayyu Ya Qayyum',
    );
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('tasbeeh_arabic_field')),
          )
          .controller!
          .text,
      'يَا حَيُّ يَا قَيُّومُ',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('long vocalized Arabic and meaning save without truncation', (
    tester,
  ) async {
    await pump(tester);
    await tapVisible(tester, find.byKey(const ValueKey('tasbeeh_add')));
    final longArabic = List.filled(
      18,
      'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    ).join(' ');
    expect(longArabic.length, greaterThan(240));
    final arabicField = find.byKey(const ValueKey('tasbeeh_arabic_field'));
    await tester.enterText(
      find.byKey(const ValueKey('tasbeeh_name_field')),
      'Long dhikr',
    );
    await tester.enterText(arabicField, longArabic);
    await tester.enterText(
      find.byKey(const ValueKey('tasbeeh_meaning_field')),
      'Glory and praise be to Allah.',
    );
    await tapVisible(tester, find.text('Save dhikr'));
    expect(model.selectedPhrase.arabic, longArabic);
    expect(model.selectedPhrase.meaning, 'Glory and praise be to Allah.');
    expect(tester.takeException(), isNull);
  });

  testWidgets('new Quranic suggestion fills Arabic and meaning', (
    tester,
  ) async {
    await pump(tester);
    await tapVisible(tester, find.byKey(const ValueKey('tasbeeh_add')));
    await tester.drag(find.byType(ListView), const Offset(-4000, 0));
    await tester.pumpAndSettle();
    await tapVisible(
      tester,
      find.byKey(const ValueKey('tasbeeh_suggestion_13')),
    );
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('tasbeeh_arabic_field')),
          )
          .controller!
          .text,
      startsWith('رَبَّنَا لَا تُزِغْ قُلُوبَنَا'),
    );
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('tasbeeh_meaning_field')),
          )
          .controller!
          .text,
      contains('hearts stray'),
    );
  });

  testWidgets(
    'focus counts background and content taps once; Undo and Exit do not count',
    (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const ValueKey('tasbeeh_enter_focus')));
      await tester.pumpAndSettle();
      for (final point in [
        const Offset(4, 4),
        const Offset(400, 280),
        const Offset(4, 590),
      ]) {
        await tester.tapAt(point);
        await tester.pumpAndSettle();
      }
      expect(model.count, 3);
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(model.count, 2);
      await tester.tap(find.byKey(const ValueKey('tasbeeh_exit_focus')));
      await tester.pumpAndSettle();
      expect(find.byType(TasbeehFocusView), findsNothing);
      expect(model.count, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'enabled Undo text has clear contrast with the real light theme',
    (tester) async {
      await pump(tester);
      model.increment();
      await tester.pumpAndSettle();
      final undo = find.byType(TasbeehUndoButton);
      await tester.ensureVisible(undo);
      await tester.pumpAndSettle();
      final button = tester.widget<FilledButton>(
        find.descendant(
          of: undo,
          matching: find.byWidgetPredicate((widget) => widget is FilledButton),
        ),
      );
      final background = button.style!.backgroundColor!.resolve({})!;
      final paragraph = tester.renderObject<RenderParagraph>(
        find.descendant(of: undo, matching: find.text('Undo')),
      );
      final foreground = paragraph.text.style!.color!;
      final a = foreground.computeLuminance();
      final b = background.computeLuminance();
      final contrast = ((a > b ? a : b) + 0.05) / ((a < b ? a : b) + 0.05);
      expect(foreground.a, 1);
      expect(contrast, greaterThanOrEqualTo(4.5));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets('custom target accepts valid numbers and rejects zero', (
    tester,
  ) async {
    await pump(tester);
    await tapVisible(
      tester,
      find.byKey(const ValueKey('tasbeeh_custom_target')),
    );
    await tester.enterText(
      find.byKey(const ValueKey('tasbeeh_target_field')),
      '0',
    );
    await tapVisible(tester, find.text('Set target'));
    expect(find.text('Enter a target from 1 to 999999'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('tasbeeh_target_field')),
      '125',
    );
    await tapVisible(tester, find.text('Set target'));
    expect(model.target, 125);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editor stays usable above the keyboard on a small phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pump(tester, scale: 1.8);
    await tapVisible(tester, find.byKey(const ValueKey('tasbeeh_add')));
    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('tasbeeh_name_field')),
      'My daily dhikr',
    );
    await tapVisible(tester, find.text('Save dhikr'));
    expect(model.selectedPhrase.name, 'My daily dhikr');
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '$locale $brightness focus fits small portrait and landscape with large text',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(320, 568));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await pump(
            tester,
            focus: true,
            locale: locale,
            brightness: brightness,
            scale: 1.8,
          );
          model.addPhrase(
            name: 'A longer personal dhikr name for a focused session',
            arabic: 'لَا إِلٰهَ إِلَّا الله وَحْدَهُ لَا شَرِيكَ لَهُ',
            target: 125,
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.byType(TasbeehCounterRing), findsOneWidget);
          await tester.binding.setSurfaceSize(const Size(640, 320));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.tapAt(const Offset(4, 4));
          await tester.pumpAndSettle();
          expect(model.count, 1);
        },
      );
    }
  }
}

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.model,
    required this.home,
    required this.locale,
    required this.brightness,
    required this.scale,
  });
  final TasbeehViewModel model;
  final Widget home;
  final String locale;
  final Brightness brightness;
  final double scale;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<TasbeehViewModel>.value(value: model),
      ChangeNotifierProvider<SettingsViewModel>(
        create: (_) => SettingsViewModel(_SettingsRepository()),
      ),
    ],
    child: MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: brightness == Brightness.light
          ? AppTheme.lightTheme
          : AppTheme.darkTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: home,
    ),
  );
}

class _MemoryRepository implements TasbeehRepository {
  TasbeehSavedState? state;
  @override
  Future<TasbeehSavedState?> loadState() async => state;
  @override
  Future<void> saveState(TasbeehSavedState state) async {
    this.state = state;
  }
}

class _SettingsRepository implements SettingsRepository {
  @override
  Future<AppSettings> getSettings() async => AppSettings.defaults();
  @override
  Future<void> saveSettings(AppSettings settings) async {}
}
