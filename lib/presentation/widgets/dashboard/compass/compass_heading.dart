import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_spacing.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class CompassHeadingDisplay extends StatelessWidget {
  const CompassHeadingDisplay({
    super.key,
    required this.heading,
    required this.isDark,
    required this.facingMecca,
  });

  final double heading;
  final bool isDark;
  final bool facingMecca;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final numColor = facingMecca
        ? const Color(0xFF00BFA5)
        : (isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24));

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.toStringAsFixed(0),
            style: text.compassHeading.copyWith(color: numColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '°',
              style: text.compassDegreeSymbol.copyWith(
                color: isDark
                    ? const Color(0xFF7E57C2)
                    : const Color(0xFF7A7288),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompassDirectionPill extends StatelessWidget {
  const CompassDirectionPill({
    super.key,
    required this.label,
    required this.isDark,
  });

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1238) : const Color(0xFFEEE8FA),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: text.compassHeadingSmall.copyWith(
          letterSpacing: 0.5,
          color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
        ),
      ),
    );
  }
}
