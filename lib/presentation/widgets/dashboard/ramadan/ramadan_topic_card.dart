import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/dashboard/ramadan/ramadan_models.dart';

class RamadanTopicCard extends StatelessWidget {
  const RamadanTopicCard({
    super.key,
    required this.topic,
    required this.isBangla,
    required this.index,
  });

  final RamadanTopic topic;
  final bool isBangla;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = index.isEven ? scheme.tertiary : scheme.secondary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: ExpansionTile(
          key: ValueKey('ramadan_topic_$index'),
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(topic.section.icon, color: accent, size: 19),
          ),
          title: Text(
            topic.title.of(isBangla),
            style: AppTheme.text(
              context,
            ).titleSmall.copyWith(fontWeight: AppTheme.weightExtraBold),
          ),
          subtitle: Text(
            topic.summary.of(isBangla),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.text(
              context,
            ).bodySmall.copyWith(color: scheme.onSurfaceVariant, height: 1.4),
          ),
          children: [
            for (final point in topic.points)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 5, color: accent),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        point.of(isBangla),
                        style: AppTheme.text(
                          context,
                        ).bodySmall.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            if (topic.reference != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(topic.reference!.url),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: Text(
                    '${ramadanLabel(isBangla, 'Source', 'সূত্র')}: ${topic.reference!.label}',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
