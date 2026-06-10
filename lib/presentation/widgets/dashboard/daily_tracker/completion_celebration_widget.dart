import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';

/// Full-screen "MashaAllah" overlay shown when every required Daily
/// Tracker task has been completed for the day.
class CompletionCelebrationWidget extends StatefulWidget {
  const CompletionCelebrationWidget({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  State<CompletionCelebrationWidget> createState() =>
      _CompletionCelebrationWidgetState();
}

class _CompletionCelebrationWidgetState
    extends State<CompletionCelebrationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.xxl),
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MyColors.primary, MyColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: MyColors.secondaryLight.withValues(alpha: 0.4),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Transform.scale(
                    scale: 1 + (_controller.value * 0.15),
                    child: Opacity(
                      opacity: 0.6 + (_controller.value * 0.4),
                      child: child,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: MyColors.secondaryLight,
                    size: 56,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'ما شاء الله',
                  style: text.duahArabic.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  context.l10n.dailyTrackerCelebrationTitle,
                  textAlign: TextAlign.center,
                  style: text.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  onPressed: widget.onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  child: Text(context.l10n.dailyTrackerCelebrationButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
