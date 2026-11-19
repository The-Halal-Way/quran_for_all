import 'package:flutter/widgets.dart';
import 'dart:async';

import 'app.dart';
import 'core/prayer_times/prayer_widget_refresh.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuranForAllApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(PrayerWidgetRefresh.register());
  });
}
