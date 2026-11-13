import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

/// Static entry point: opening the Sunnah tab does not read the catalog JSON.
class DuaLibraryEntryCard extends StatelessWidget {
  const DuaLibraryEntryCard({super.key, required this.onOpen});
  final ValueChanged<String?> onOpen;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final l10n = context.l10n;
    final radius = BorderRadius.circular(AppRadius.xl);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipForeground = isDark ? Colors.white : const Color(0xFF124F59);
    final chipBackground = isDark
        ? const Color(0xFF234E62)
        : const Color(0xFFE7F6F2);
    return Material(
      color: const Color(0xFF115B61),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF115B61), Color(0xFF177D80), Color(0xFF353B81)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () => onOpen(null),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Color(0xFFB9F0DF),
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.duaLibraryTitle,
                            style: text.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.weightExtraBold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l10n.duaLibrarySubtitle,
                            style: text.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: .82),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final item in [
                      ('morning', l10n.duaMorning),
                      ('evening', l10n.duaEvening),
                      ('all', l10n.duaAll),
                    ])
                      ActionChip(
                        onPressed: () => onOpen(item.$1),
                        avatar: Icon(
                          item.$1 == 'all'
                              ? Icons.search_rounded
                              : Icons.auto_awesome_rounded,
                          size: 16,
                          color: chipForeground,
                        ),
                        label: Text(item.$2),
                        labelStyle: text.labelMedium.copyWith(
                          color: chipForeground,
                        ),
                        color: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.pressed)
                              ? (isDark
                                    ? const Color(0xFF386B80)
                                    : const Color(0xFFD6EBE5))
                              : chipBackground,
                        ),
                        surfaceTintColor: Colors.transparent,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: .18),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
