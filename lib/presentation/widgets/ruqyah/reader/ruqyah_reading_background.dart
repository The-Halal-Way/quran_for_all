import 'package:flutter/material.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_reading.dart';
import '../shared/ruqyah_panel.dart';

class RuqyahReadingBackground extends StatelessWidget {
  const RuqyahReadingBackground({super.key, required this.reading});
  final RuqyahReading reading;
  @override
  Widget build(BuildContext context) => RuqyahPanel(
    padding: EdgeInsets.zero,
    child: ExpansionTile(
      key: PageStorageKey('ruqyah-background-${reading.id}'),
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(
        context.l10n.ruqyahMethodBackground,
        style: AppTheme.text(context).titleSmall,
      ),
      childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      children: [
        for (final entry in {
          context.l10n.ruqyahAudience: reading.details.audience,
          context.l10n.ruqyahBackground: reading.details.background,
          context.l10n.ruqyahMethod: reading.details.method,
        }.entries)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  entry.key,
                  style: AppTheme.text(
                    context,
                  ).labelLarge.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.value,
                  style: AppTheme.text(
                    context,
                  ).bodyMedium.copyWith(height: 1.7),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
