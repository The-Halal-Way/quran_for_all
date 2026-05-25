import 'package:flutter/material.dart';

/// A smooth slide + fade page route used for navigation transitions.
///
/// Usage: `Navigator.of(context).push(AppPageRoute(builder: (_) => MyPage()))`
class AppPageRoute<T> extends MaterialPageRoute<T> {
  AppPageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curve = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(curve),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(curve),
        child: child,
      ),
    );
  }
}
