import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

import '../../../core/theme/my_colors.dart';

class SplashBranding extends StatelessWidget {
  const SplashBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0.88, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [MyColors.secondaryLight, MyColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primary.withValues(alpha: 0.30),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: MyColors.primary.withValues(alpha: 0.10),
                  blurRadius: 56,
                  offset: const Offset(0, 28),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Quran For All',
            style: AppTheme.text(context).headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.weightBold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Read with calm focus, search in seconds, and continue where you paused.',
            textAlign: TextAlign.center,
            style: AppTheme.text(
              context,
            ).bodyLarge.copyWith(color: Colors.white.withValues(alpha: 0.88)),
          ),
        ],
      ),
    );
  }
}
