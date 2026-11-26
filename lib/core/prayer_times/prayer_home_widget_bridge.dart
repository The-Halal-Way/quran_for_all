import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class PrayerHomeWidgetBridge {
  static const snapshotKey = 'prayer_times_widget_snapshot';
  static const iOSAppGroupId = 'group.com.example.quranForAll';
  static const qualifiedAndroidProviderName =
      'com.example.quran_for_all.PrayerTimesHomeWidgetProvider';
  static const qualifiedAndroidElderlyProviderName =
      'com.example.quran_for_all.PrayerTimesElderlyHomeWidgetProvider';
  static const qualifiedAndroidModernProviderName =
      'com.example.quran_for_all.PrayerTimesModernHomeWidgetProvider';
  static const qualifiedAndroidModernElderlyProviderName =
      'com.example.quran_for_all.PrayerTimesModernElderlyHomeWidgetProvider';
  static const qualifiedAndroidFocusProviderName =
      'com.example.quran_for_all.PrayerTimesFocusHomeWidgetProvider';
  static const qualifiedAndroidFocusElderlyProviderName =
      'com.example.quran_for_all.PrayerTimesFocusElderlyHomeWidgetProvider';
  static const iOSWidgetName = 'PrayerTimesHomeWidget';
  static const iOSFocusWidgetName = 'PrayerTimesFocusHomeWidget';
  static const iOSFocusElderlyWidgetName = 'PrayerTimesFocusElderlyHomeWidget';

  static bool get _isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static Future<void> saveSnapshot(String snapshotJson) async {
    if (!_isSupportedPlatform) {
      return;
    }

    try {
      await _configure();
      await HomeWidget.saveWidgetData<String>(
        snapshotKey,
        snapshotJson,
        appGroupId: _appGroupIdForCurrentPlatform,
      );
      await HomeWidget.updateWidget(
        qualifiedAndroidName: qualifiedAndroidProviderName,
        iOSName: iOSWidgetName,
      );
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await HomeWidget.updateWidget(iOSName: iOSFocusWidgetName);
        await HomeWidget.updateWidget(iOSName: iOSFocusElderlyWidgetName);
      }
    } catch (error) {
      debugPrint('Prayer widget snapshot sync failed: $error');
    }
  }

  static Future<String?> readSnapshot() async {
    if (!_isSupportedPlatform) {
      return null;
    }

    try {
      await _configure();
      return HomeWidget.getWidgetData<String>(
        snapshotKey,
        appGroupId: _appGroupIdForCurrentPlatform,
      );
    } catch (error) {
      debugPrint('Prayer widget snapshot read failed: $error');
      return null;
    }
  }

  static Future<void> _configure() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await HomeWidget.setAppGroupId(iOSAppGroupId);
    }
  }

  static String? get _appGroupIdForCurrentPlatform {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iOSAppGroupId;
    }

    return null;
  }
}
