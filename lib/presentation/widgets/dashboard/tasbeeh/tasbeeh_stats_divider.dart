import 'package:flutter/material.dart';

class TasbeehStatsDivider extends StatelessWidget {
  const TasbeehStatsDivider({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 42,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    color: Theme.of(context).colorScheme.outlineVariant,
  );
}
