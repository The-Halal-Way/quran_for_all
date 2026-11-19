import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/prayer_times/prayer_home_widget_bridge.dart';
import 'package:quran_for_all/core/prayer_times/prayer_widget_refresh.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <MethodCall>[];
  const channel = MethodChannel('home_widget');
  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return true;
        });
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test('only the prayer widget refresh URI is accepted', () {
    expect(
      PrayerWidgetRefresh.isRefreshUri(
        Uri.parse('quranforall://prayer-widget/refresh'),
      ),
      isTrue,
    );
    for (final uri in [
      null,
      Uri.parse('https://prayer-widget/refresh'),
      Uri.parse('quranforall://other/refresh'),
      Uri.parse('quranforall://prayer-widget/delete'),
    ]) {
      expect(PrayerWidgetRefresh.isRefreshUri(uri), isFalse);
    }
  });

  for (final fails in [false, true]) {
    test(
      'refresh ${fails ? 'failure' : 'success'} clears busy state and updates native widget',
      () async {
        var attempted = 0;
        await PrayerWidgetRefresh.run(() async {
          attempted++;
          if (fails) throw StateError('test failure');
        });
        expect(attempted, 1);
        final saved = calls.where((c) => c.method == 'saveWidgetData').toList();
        expect(saved[0].arguments['id'], PrayerWidgetRefresh.errorKey);
        expect(saved[0].arguments['data'], fails);
        expect(saved[1].arguments['id'], PrayerWidgetRefresh.busyKey);
        // Remove it rather than replacing a native Long with a codec Int.
        expect(saved[1].arguments['data'], isNull);
        expect(calls.last.method, 'updateWidget');
        expect(
          calls.last.arguments['qualifiedAndroidName'],
          PrayerHomeWidgetBridge.qualifiedAndroidProviderName,
        );
      },
    );
  }
}
