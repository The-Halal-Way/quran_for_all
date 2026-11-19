import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class DashboardFeatureMark extends StatelessWidget {
  const DashboardFeatureMark({
    super.key,
    required this.start,
    required this.end,
    required this.child,
  });

  final Color start, end;
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [start, end],
      ),
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    child: SizedBox.square(dimension: 48, child: Center(child: child)),
  );
}
