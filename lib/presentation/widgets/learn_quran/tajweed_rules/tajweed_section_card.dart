import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';

class TajweedSectionCard extends StatelessWidget {
  const TajweedSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.learnText(title),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text(
              context.learnText(subtitle),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
