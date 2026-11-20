import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_text.dart';
import 'ruqyah_style.dart';

class RuqyahSources extends StatelessWidget {
  const RuqyahSources({super.key, required this.sources});
  final List<RuqyahSource> sources;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final source in sources)
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: RuqyahStyle.accent(context),
            alignment: AlignmentDirectional.centerStart,
          ),
          onPressed: () async {
            var opened = false;
            try {
              opened = await launchUrl(
                Uri.parse(source.url),
                mode: LaunchMode.externalApplication,
              );
            } catch (_) {
              /* Display a recoverable failure below. */
            }
            if (!opened && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.ruqyahSourceFailed)),
              );
            }
          },
          icon: const Icon(Icons.open_in_new_rounded, size: 16),
          label: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(source.label.inLanguage(context.l10n.localeName)),
              if (source.kind != 'reference' || source.grade != null) ...[
                const SizedBox(height: 3),
                Text(
                  [
                    switch (source.kind) {
                      'quran' => context.l10n.ruqyahSourceQuran,
                      'hadith' => context.l10n.ruqyahSourceHadith,
                      'scholarly' => context.l10n.ruqyahScholarlyGuidance,
                      'medical' => context.l10n.ruqyahSourceMedical,
                      'provider' => context.l10n.ruqyahSourceProvider,
                      _ => '',
                    },
                    if (source.grade != null)
                      source.grade!.inLanguage(context.l10n.localeName),
                  ].where((s) => s.isNotEmpty).join(' · '),
                  style: AppTheme.text(context).labelSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
    ],
  );
}
