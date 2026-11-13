import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class SunnahDuaRoutineSection extends StatelessWidget {
  const SunnahDuaRoutineSection({super.key, required this.onOpen});

  final ValueChanged<String?> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = AppTheme.text(context);
    final radius = BorderRadius.circular(AppRadius.xl);
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            colors: [Color(0xFF087F8C), Color(0xFF6A55E8)],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
          ),
        ),
        child: InkWell(
          onTap: () => onOpen(null),
          child: Stack(
            children: [
              const PositionedDirectional(
                top: -45,
                end: -25,
                child: _Glow(size: 170),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.spa_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.sunnahLibraryTitle,
                                style: text.titleLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: AppTheme.weightExtraBold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                l10n.sunnahLibrarySubtitle,
                                style: text.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: .84),
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
                      runSpacing: AppSpacing.sm,
                      children: [
                        _Shortcut(
                          label: l10n.duaMorning,
                          icon: Icons.wb_sunny_rounded,
                          onTap: () => onOpen('morning_remembrance'),
                        ),
                        _Shortcut(
                          label: l10n.duaEvening,
                          icon: Icons.dark_mode_rounded,
                          onTap: () => onOpen('evening_remembrance'),
                        ),
                        _Shortcut(
                          label: l10n.duaAll,
                          icon: Icons.grid_view_rounded,
                          onTap: () => onOpen('all'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foreground = isDark ? Colors.white : const Color(0xFF124F59);
    final background = isDark
        ? const Color(0xFF234E62)
        : const Color(0xFFE7F6F2);
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(icon, size: 16, color: foreground),
      label: Text(label),
      labelStyle: AppTheme.text(
        context,
      ).labelMedium.copyWith(color: foreground),
      color: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.pressed)
            ? (isDark ? const Color(0xFF386B80) : const Color(0xFFD6EBE5))
            : background,
      ),
      side: BorderSide(color: Colors.white.withValues(alpha: .18)),
      surfaceTintColor: Colors.transparent,
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: .08),
      border: Border.all(color: Colors.white.withValues(alpha: .09)),
    ),
  );
}
