import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';

class QuizOptionTile extends StatelessWidget {
  const QuizOptionTile({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    required this.position,
  });
  final String text;
  final bool selected;
  final int position;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected
              ? scheme.primary.withValues(alpha: .1)
              : scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? scheme.primary
                          : scheme.onSurface.withValues(alpha: .04),
                    ),
                    child: selected
                        ? Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: scheme.onPrimary,
                          )
                        : Text(
                            String.fromCharCode(65 + position),
                            style: AppTheme.text(context).labelMedium,
                          ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTheme.text(context).bodyMedium.copyWith(
                        fontWeight: selected
                            ? AppTheme.weightSemiBold
                            : AppTheme.weightRegular,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
