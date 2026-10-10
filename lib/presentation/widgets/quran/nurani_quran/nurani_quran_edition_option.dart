import 'package:flutter/material.dart';

import '../../../../core/constants/nurani_quran_document.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import 'nurani_quran_labels.dart';

class NuraniQuranEditionOption extends StatelessWidget {
  const NuraniQuranEditionOption({
    super.key,
    required this.document,
    required this.selected,
    required this.onSelected,
  });

  final NuraniQuranDocument document;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = AppTheme.text(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final baseAccent = document.edition == NuraniQuranEdition.green
        ? const Color(0xFF248467)
        : const Color(0xFF427CC9);
    final accent = dark
        ? Color.lerp(baseAccent, Colors.white, .25)!
        : baseAccent;
    final label = nuraniEditionLabel(context, document.edition);
    final size = nuraniFileSize(context, document);

    return Semantics(
      button: true,
      selected: selected,
      label: '$label. $size',
      onTap: onSelected,
      excludeSemantics: true,
      child: Material(
        color: Color.alphaBlend(
          accent.withValues(alpha: selected ? .10 : .035),
          scheme.surface,
        ),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: selected ? accent : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 210,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Image.asset(
                      document.previewImage,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: text.titleSmall.copyWith(
                          fontWeight: AppTheme.weightExtraBold,
                          color: selected ? accent : scheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected ? accent : scheme.onSurfaceVariant,
                      size: 21,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  size,
                  style: text.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
