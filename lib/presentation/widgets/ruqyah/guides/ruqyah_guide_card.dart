import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../shared/ruqyah_evidence_label.dart';
import '../shared/ruqyah_style.dart';

class RuqyahGuideCard extends StatelessWidget {
  const RuqyahGuideCard({
    super.key,
    required this.title,
    required this.summary,
    required this.basis,
    required this.onTap,
  });
  final String title, summary, basis;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = RuqyahStyle.accent(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: accent.withValues(alpha: .16)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RuqyahEvidenceLabel(basis: basis),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: AppTheme.text(context).titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        summary,
                        style: AppTheme.text(context).bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.north_east_rounded, color: accent, size: 19),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
