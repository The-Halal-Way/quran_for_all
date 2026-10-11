import 'package:flutter/material.dart';

import '../../../../core/constants/science_in_quran_document.dart';
import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'science_in_quran_labels.dart';

class ScienceInQuranLanguageOption extends StatelessWidget {
  const ScienceInQuranLanguageOption({
    super.key,
    required this.document,
    required this.selected,
    required this.onTap,
  });

  final ScienceInQuranDocument document;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = document.language == ScienceInQuranLanguage.bangla
        ? scheme.tertiary
        : scheme.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: scienceLanguageLabel(context, document.language),
      child: Material(
        color: selected
            ? accent.withValues(alpha: 0.11)
            : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: selected ? accent : scheme.outlineVariant,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.asset(
                    document.previewImage,
                    width: 78,
                    height: 104,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 78,
                      height: 104,
                      color: accent.withValues(alpha: 0.14),
                      child: Icon(Icons.menu_book_rounded, color: accent),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scienceLanguageLabel(context, document.language),
                        style: AppTheme.text(context).titleMedium.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        scienceFileSize(context, document),
                        style: AppTheme.text(context).bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        context.l10n.scienceInQuranOfflineReady,
                        style: AppTheme.text(
                          context,
                        ).labelSmall.copyWith(color: accent),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  color: selected ? accent : scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
