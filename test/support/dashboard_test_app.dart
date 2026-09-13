import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/data/models/app_settings.dart';
import 'package:quran_for_all/data/models/daily_task_model.dart';
import 'package:quran_for_all/data/models/learn_quran_content.dart';
import 'package:quran_for_all/domain/repositories/daily_tracker_repository.dart';
import 'package:quran_for_all/domain/usecases/add_custom_task_usecase.dart';
import 'package:quran_for_all/domain/usecases/delete_custom_task_usecase.dart';
import 'package:quran_for_all/domain/usecases/get_daily_tasks_usecase.dart';
import 'package:quran_for_all/domain/usecases/toggle_task_usecase.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard/daily_tracker_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/dashboard_prayer_times_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/learn_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/read_quran/read_quran_viewmodel.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';

/// Uses the real tracker use cases with isolated, in-memory persistence.
class DashboardTestState {
  DashboardTestState() {
    tracker = DailyTrackerViewModel(
      getDailyTasksUseCase: GetDailyTasksUseCase(repository),
      toggleTaskUseCase: ToggleTaskUseCase(repository),
      addCustomTaskUseCase: AddCustomTaskUseCase(repository),
      deleteCustomTaskUseCase: DeleteCustomTaskUseCase(repository),
    );
  }

  final repository = MemoryTrackerRepository();
  late final DailyTrackerViewModel tracker;
  final prayer = TestPrayerViewModel();
  final read = _TestReadViewModel();
  final learn = _TestLearnViewModel();
  final settings = _TestSettingsViewModel();

  void dispose() {
    tracker.dispose();
    prayer.dispose();
    read.dispose();
    learn.dispose();
    settings.dispose();
  }
}

class DashboardTestApp extends StatelessWidget {
  const DashboardTestApp({
    super.key,
    required this.state,
    required this.home,
    this.locale = 'en',
    this.brightness = Brightness.light,
    this.scale = 1,
    this.theme,
  });

  final DashboardTestState state;
  final Widget home;
  final String locale;
  final Brightness brightness;
  final double scale;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<DailyTrackerViewModel>.value(value: state.tracker),
      ChangeNotifierProvider<DashboardPrayerTimesViewModel>.value(
        value: state.prayer,
      ),
      ChangeNotifierProvider<ReadQuranViewModel>.value(value: state.read),
      ChangeNotifierProvider<LearnQuranViewModel>.value(value: state.learn),
      ChangeNotifierProvider<SettingsViewModel>.value(value: state.settings),
    ],
    child: MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme ?? ThemeData(brightness: brightness),
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

class MemoryTrackerRepository implements DailyTrackerRepository {
  Map<String, DailyTaskProgress> progress = {};
  List<DailyTask> customTasks = [];

  @override
  Future<List<DailyTask>> loadCustomTasks() async => List.of(customTasks);
  @override
  Future<Map<String, DailyTaskProgress>> loadProgress() async =>
      Map.of(progress);
  @override
  Future<void> saveCustomTasks(List<DailyTask> tasks) async {
    customTasks = List.of(tasks);
  }

  @override
  Future<void> saveProgress(Map<String, DailyTaskProgress> value) async {
    progress = Map.of(value);
  }
}

class TestPrayerViewModel extends ChangeNotifier
    implements DashboardPrayerTimesViewModel {
  int refreshes = 0;
  @override
  Map<String, String> get prayerTimes => const {
    'Fajr': '4:30 AM',
    'Dhuhr': '12:05 PM',
    'Asr': '4:25 PM',
    'Maghrib': '6:15 PM',
    'Isha': '7:30 PM',
  };
  @override
  Map<String, String> get prayerTimeRanges => const {
    'Asr': '4:25 PM - 6:15 PM',
  };
  @override
  String get currentPrayer => 'Asr';
  @override
  bool get isLoading => false;
  @override
  String get error => '';
  @override
  PrayerTimesErrorType get errorType => PrayerTimesErrorType.none;
  @override
  Future<void> loadPrayerTimes({bool forceRefresh = false}) async {
    if (forceRefresh) refreshes++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestReadViewModel extends ChangeNotifier implements ReadQuranViewModel {
  @override
  Null get lastRead => null;
  @override
  Null get lastReadSurah => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestLearnViewModel extends ChangeNotifier
    implements LearnQuranViewModel {
  @override
  Null get nextLesson => null;
  @override
  List<LearnQuranModule> get modules => const [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestSettingsViewModel extends ChangeNotifier
    implements SettingsViewModel {
  @override
  AppSettings get settings => AppSettings.defaults();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
