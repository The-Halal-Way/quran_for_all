import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../views/prayer/eid_prayer/eid_prayer_models.dart';
import 'eid_guide_style.dart';

class EidKindOption extends StatelessWidget {
  const EidKindOption({
    super.key,
    required this.kind,
    required this.selected,
    required this.bangla,
    required this.onTap,
  });

  final EidKind kind;
  final bool selected;
  final bool bangla;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = EidGuideStyle.accent(kind);
    final title = kind == EidKind.fitr
        ? const EidText('Eid al-Fitr', 'ঈদুল ফিতর')
        : const EidText('Eid al-Adha', 'ঈদুল আযহা');
    final date = kind == EidKind.fitr
        ? const EidText('1 Shawwal', '১ শাওয়াল')
        : const EidText('10 Dhul Hijjah', '১০ জিলহজ');
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      selected: selected,
      excludeSemantics: true,
      label: '${title.inLanguage(bangla)}, ${date.inLanguage(bangla)}',
      child: Material(
        color: selected
            ? accent.withValues(alpha: dark ? 0.22 : 0.11)
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: selected ? accent : colors.outlineVariant,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.17),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    kind == EidKind.fitr
                        ? Icons.nightlight_round
                        : Icons.auto_awesome_rounded,
                    color: accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.inLanguage(bangla),
                        style: AppTheme.text(context).titleSmall.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        date.inLanguage(bangla),
                        style: AppTheme.text(context).labelSmall.copyWith(
                          color: selected ? accent : colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: accent, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
