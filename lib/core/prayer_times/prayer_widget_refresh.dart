import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import '../../data/datasources/local/offline_prayer_calculator.dart';
import '../../data/datasources/local/prayer_times_local_data_source.dart';
import '../../data/datasources/local/prayer_times_preferences_store.dart';
import '../../data/repositories/prayer_times_repository_impl.dart';
import 'prayer_home_widget_bridge.dart';

/// Invoked by home_widget's headless engine, without creating the app UI.
@pragma('vm:entry-point')
Future<void> prayerWidgetRefreshCallback(Uri? uri) async {
  if (!PrayerWidgetRefresh.isRefreshUri(uri)) return;
  WidgetsFlutterBinding.ensureInitialized();
  final local = PrayerTimesLocalDataSource(singleInstance: false);
  try {
    final repository = PrayerTimesRepositoryImpl(
      localDataSource: local,
      preferencesStore: PrayerTimesPreferencesStore(),
      calculator: const OfflinePrayerCalculator(),
    );
    await PrayerWidgetRefresh.run(() async {
      // A background callback may use an existing location permission, but
      // cannot show a permission prompt. The resolver retains saved GPS data.
      await repository.handleAppResumed();
      await repository.warmUpcomingPrayerDays(forceRefresh: true);
    });
  } finally {
    await local.close();
  }
}

class PrayerWidgetRefresh {
  const PrayerWidgetRefresh._();

  static const busyKey = 'prayer_widget_refreshing_until';
  static const errorKey = 'prayer_widget_refresh_error';

  static bool isRefreshUri(Uri? uri) =>
      uri?.scheme == 'quranforall' &&
      uri?.host == 'prayer-widget' &&
      uri?.path == '/refresh';

  static Future<void> register() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await HomeWidget.registerInteractivityCallback(
        prayerWidgetRefreshCallback,
      );
    } catch (error) {
      debugPrint('Prayer widget interaction registration failed: $error');
    }
  }

  /// Always release the native busy indicator, including after a failed refresh.
  static Future<void> run(Future<void> Function() refresh) async {
    var failed = false;
    try {
      await refresh();
    } catch (error) {
      failed = true;
      debugPrint('Prayer widget refresh failed: $error');
    } finally {
      await HomeWidget.saveWidgetData<bool>(errorKey, failed);
      await HomeWidget.saveWidgetData<int>(busyKey, null);
      await HomeWidget.updateWidget(
        qualifiedAndroidName:
            PrayerHomeWidgetBridge.qualifiedAndroidProviderName,
        iOSName: PrayerHomeWidgetBridge.iOSWidgetName,
      );
    }
  }
}
