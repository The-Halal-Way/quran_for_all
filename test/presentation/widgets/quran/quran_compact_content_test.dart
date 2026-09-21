import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/enums/app_language.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/learn_quran_content.dart';
import 'package:quran_for_all/data/models/surah_model.dart';
import 'package:quran_for_all/domain/repositories/settings_repository.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/quran/learn_quran/arabic_letters/arabic_letters_shape_family_section.dart';
import 'package:quran_for_all/presentation/widgets/quran/learn_quran/learn_header_card.dart';
import 'package:quran_for_all/presentation/widgets/quran/learn_quran/learn_lesson_tile.dart';
import 'package:quran_for_all/presentation/widgets/quran/learn_quran/learn_module_card.dart';
import 'package:quran_for_all/presentation/widgets/quran/learn_quran/learn_next_lesson_card.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/home/continue_reading_card.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/home/read_quran_top_banner.dart';
import 'package:quran_for_all/presentation/widgets/quran/read_quran/home/surah_card.dart';

void main() {
  testWidgets('compact Quran rows fit Bengali with enlarged text', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    final settings = await _settingsViewModel(AppLanguage.bangla);
    addTearDown(settings.dispose);

    await tester.pumpWidget(
      _TestApp(
        settings: settings,
        locale: const Locale('bn'),
        child: Column(
          children: [
            ReadQuranTopBanner(onSearchTap: () {}, surahCount: 114),
            const SizedBox(height: 12),
            ContinueReadingCard(surah: _surah, ayahNumber: 7, onTap: () {}),
            const SizedBox(height: 12),
            SurahCard(
              surah: _surah,
              onTap: () {},
              isBookmarked: false,
              onToggleBookmark: () {},
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(SurahCard), matching: find.byType(Card)),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('learning modules use compact icon tiles without overflow', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    final settings = await _settingsViewModel(AppLanguage.bangla);
    addTearDown(settings.dispose);
    final module = LearnQuranContent.modules.first;

    await tester.pumpWidget(
      _TestApp(
        settings: settings,
        locale: const Locale('bn'),
        brightness: Brightness.dark,
        child: Column(
          children: [
            LearnHeaderCard(
              overallProgress: 0.35,
              completedLessons: 3,
              totalLessons: 8,
              completedModules: 1,
              totalModules: 7,
              streakDays: 4,
            ),
            const SizedBox(height: 12),
            LearnNextLessonCard(
              nextLesson: module.lessons.first,
              onStart: () {},
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 140,
              child: LearnModuleCard(
                module: module,
                completedLessons: 3,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(LearnModuleCard),
        matching: find.byType(Card),
      ),
      findsNothing,
    );
    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic letter samples retain contrast in dark mode', (
    tester,
  ) async {
    await _setCompactSurface(tester);
    final settings = await _settingsViewModel(AppLanguage.english);
    addTearDown(settings.dispose);

    await tester.pumpWidget(
      _TestApp(
        settings: settings,
        locale: const Locale('en'),
        brightness: Brightness.dark,
        child: const ArabicLettersShapeFamilySection(),
      ),
    );
    await tester.pumpAndSettle();

    final letterFinder = find.text('ب').first;
    final letter = tester.widget<Text>(letterFinder);
    final darkScheme = AppTheme.darkTheme.colorScheme;

    expect(letter.style?.color, darkScheme.onSurface);

    final letterContainers = tester.widgetList<Container>(
      find.ancestor(of: letterFinder, matching: find.byType(Container)),
    );
    expect(
      letterContainers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration! as BoxDecoration).color ==
                darkScheme.surface,
      ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('lesson metadata remains readable in dark mode', (tester) async {
    await _setCompactSurface(tester);
    final settings = await _settingsViewModel(AppLanguage.english);
    addTearDown(settings.dispose);
    final lesson = LearnQuranContent.modules.first.lessons[4];

    await tester.pumpWidget(
      _TestApp(
        settings: settings,
        locale: const Locale('en'),
        brightness: Brightness.dark,
        child: LearnLessonTile(
          lesson: lesson,
          isCompleted: false,
          isAudioPlaying: false,
          onCompletionChanged: (_) {},
          onAudioTap: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final duration = tester.widget<Text>(
      find.text('${lesson.durationMinutes} min'),
    );
    final audioGuided = tester.widget<Text>(find.text('Audio guided'));
    final expectedColor = AppTheme.darkTheme.colorScheme.onSurfaceVariant;

    expect(duration.style?.color, expectedColor);
    expect(audioGuided.style?.color, expectedColor);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _setCompactSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(320, 700));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

Future<SettingsViewModel> _settingsViewModel(AppLanguage language) async {
  final viewModel = SettingsViewModel(
    _FakeSettingsRepository(
      AppSettings.defaults().copyWith(language: language),
    ),
  );
  await viewModel.loadSettings();
  return viewModel;
}

class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.settings,
    required this.locale,
    required this.child,
    this.brightness = Brightness.light,
  });

  final SettingsViewModel settings;
  final Locale locale;
  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsViewModel>.value(
      value: settings,
      child: MaterialApp(
        locale: locale,
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
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _FakeSettingsRepository implements SettingsRepository {
  const _FakeSettingsRepository(this.settings);

  final AppSettings settings;

  @override
  Future<AppSettings> getSettings() async => settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}

const _surah = SurahModel(
  id: 1,
  nameArabic: 'الفاتحة',
  nameEnglish: 'Al-Fatihah',
  nameTranslated: 'The Opening',
  revelationType: 'Meccan',
  totalAyahs: 7,
);
