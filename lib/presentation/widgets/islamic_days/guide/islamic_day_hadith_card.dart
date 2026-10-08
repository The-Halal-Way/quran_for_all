import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/islamic_days/islamic_day.dart';
import '../shared/islamic_day_badge.dart';

class IslamicDayHadithCard extends StatelessWidget {
  const IslamicDayHadithCard({super.key, required this.hadith});
  final IslamicDayHadith hadith;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.primary.withValues(alpha: .18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              IslamicDayBadge(
                label: hadith.reference,
                icon: Icons.menu_book_outlined,
                color: scheme.primary,
              ),
              IslamicDayBadge(
                label: hadith.grade,
                icon: Icons.verified_outlined,
                color: scheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Text(
              hadith.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: AppTheme.text(context).hadithArabicBody,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.islamicDaysHadithExcerpt,
            style: AppTheme.text(
              context,
            ).labelSmall.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            hadith.meaning.resolve(context.l10n.localeName),
            style: AppTheme.text(context).bodyLarge.copyWith(height: 1.65),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => _openReference(context),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(context.l10n.islamicDaysSource),
          ),
        ],
      ),
    );
  }

  Future<void> _openReference(BuildContext context) async {
    var opened = false;
    try {
      opened = await launchUrl(Uri.parse(hadith.url));
    } catch (_) {}
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.islamicDaysSourceError)),
      );
    }
  }
}
