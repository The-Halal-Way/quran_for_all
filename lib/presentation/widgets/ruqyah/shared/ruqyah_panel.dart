import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class RuqyahPanel extends StatelessWidget {
  const RuqyahPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      borderRadius: BorderRadius.circular(AppRadius.xl),
    ),
    child: child,
  );
}
