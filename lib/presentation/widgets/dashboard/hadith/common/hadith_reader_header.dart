import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import 'hadith_reader_language_toggle.dart';

class HadithReaderHeader extends StatelessWidget {
  const HadithReaderHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.isBangla,
    required this.onBack,
    required this.onLanguageChanged,
    required this.onSearch,
    this.progressLabel,
  });

  final String title;
  final String subtitle;
  final String? progressLabel;
  final Color accent;
  final bool isBangla;
  final VoidCallback onBack;
  final ValueChanged<bool> onLanguageChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final surface = isDark ? const Color(0xFF171126) : Colors.white;

    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [surface, Color.lerp(surface, accent, 0.16)!],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: accent.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack,
              icon: const Icon(CupertinoIcons.chevron_back, size: 19),
              color: accent,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium.copyWith(
                      fontWeight: AppTheme.weightExtraBold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    progressLabel ?? subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelSmall.copyWith(
                      color: accent,
                      fontWeight: AppTheme.weightBold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            HadithReaderLanguageToggle(
              isBangla: isBangla,
              accent: accent,
              onChanged: onLanguageChanged,
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              tooltip: MaterialLocalizations.of(context).searchFieldLabel,
              onPressed: onSearch,
              icon: const Icon(CupertinoIcons.search, size: 20),
              color: accent,
            ),
          ],
        ),
      ),
    );
  }
}
