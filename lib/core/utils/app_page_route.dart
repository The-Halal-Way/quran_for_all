import 'package:flutter/cupertino.dart';

/// The app's standard iOS route with an edge-swipe back gesture.
///
/// Usage: `Navigator.of(context).push(AppPageRoute(builder: (_) => MyPage()))`
class AppPageRoute<T> extends CupertinoPageRoute<T> {
  AppPageRoute({required super.builder, super.settings});
}
