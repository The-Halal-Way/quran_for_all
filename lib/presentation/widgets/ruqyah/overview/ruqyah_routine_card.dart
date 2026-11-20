import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/ruqyah/ruqyah_index.dart';
import '../shared/ruqyah_style.dart';

class RuqyahRoutineCard extends StatelessWidget {
  const RuqyahRoutineCard({
    super.key,
    required this.routine,
    required this.index,
    required this.onTap,
    required this.onMethod,
  });
  final RuqyahRoutineSummary routine;
  final int index;
  final VoidCallback onTap, onMethod;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = RuqyahStyle.accent(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: BorderSide(color: accent.withValues(alpha: .16)),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    RuqyahStyle.number(context, index + 1),
                    style: AppTheme.text(
                      context,
                    ).titleLarge.copyWith(color: accent),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.title.inLanguage(context.l10n.localeName),
                        style: AppTheme.text(
                          context,
                        ).titleSmall.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        routine.description.inLanguage(context.l10n.localeName),
                        style: AppTheme.text(context).bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        routine.reported
                            ? context.l10n.ruqyahReported
                            : context.l10n.ruqyahArrangement,
                        style: AppTheme.text(
                          context,
                        ).labelSmall.copyWith(color: accent),
                      ),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: onMethod,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: accent,
                          alignment: AlignmentDirectional.centerStart,
                        ),
                        icon: const Icon(Icons.auto_stories_outlined, size: 16),
                        label: Text(context.l10n.ruqyahReadMethod),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.north_east_rounded, color: accent, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
