import 'package:flutter/material.dart';

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
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: 64,
              fontWeight: FontWeight.w700,
              color: numColor,
              letterSpacing: -3,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '°',
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 30,
                fontWeight: FontWeight.w400,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1238) : const Color(0xFFEEE8FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Sora',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF4C425C),
        ),
      ),
    );
  }
}
