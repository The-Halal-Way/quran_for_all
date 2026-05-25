import 'package:flutter/material.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';

class CompassInfoRow extends StatelessWidget {
  const CompassInfoRow({
    super.key,
    required this.heading,
    required this.qiblaOffset,
    required this.facingMecca,
    required this.isDark,
    required this.isApiFallback,
  });

  final double heading;
  final double qiblaOffset;
  final bool facingMecca;
  final bool isDark;
  final bool isApiFallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 360) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _CompassInfoCard(
                        label: 'Heading',
                        value: isApiFallback
                            ? 'N/A'
                            : '${heading.toStringAsFixed(0)}°',
                        icon: Icons.explore_rounded,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CompassInfoCard(
                        label: 'Qibla offset',
                        value: '${qiblaOffset.toStringAsFixed(0)}°',
                        icon: Icons.mosque_rounded,
                        isDark: isDark,
                        accent: !isApiFallback,
                        isOnTarget: !isApiFallback && facingMecca,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _CompassInfoCard(
                  label: 'Accuracy',
                  value: isApiFallback ? 'API' : '±2°',
                  icon: Icons.my_location_rounded,
                  isDark: isDark,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _CompassInfoCard(
                  label: 'Heading',
                  value: isApiFallback
                      ? 'N/A'
                      : '${heading.toStringAsFixed(0)}°',
                  icon: Icons.explore_rounded,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CompassInfoCard(
                  label: 'Qibla offset',
                  value: '${qiblaOffset.toStringAsFixed(0)}°',
                  icon: Icons.mosque_rounded,
                  isDark: isDark,
                  accent: !isApiFallback,
                  isOnTarget: !isApiFallback && facingMecca,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CompassInfoCard(
                  label: 'Accuracy',
                  value: isApiFallback ? 'API' : '±2°',
                  icon: Icons.my_location_rounded,
                  isDark: isDark,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CompassInfoCard extends StatelessWidget {
  const _CompassInfoCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
    this.accent = false,
    this.isOnTarget = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isDark;
  final bool accent;
  final bool isOnTarget;

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);
    final cardBg = isDark ? const Color(0xFF120A2B) : const Color(0xFFFFFFFF);
    final borderC = isDark ? const Color(0xFF382E54) : const Color(0xFFD9D1E8);
    final labelC = isDark ? const Color(0xFF7E57C2) : const Color(0xFF7A7288);
    final valueC = accent && isOnTarget
        ? const Color(0xFF00BFA5)
        : (isDark ? const Color(0xFFEDE7F6) : const Color(0xFF120B24));
    final iconC = accent
        ? (isOnTarget ? const Color(0xFF00BFA5) : const Color(0xFF4B30A1))
        : const Color(0xFF4B30A1);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent && isOnTarget
              ? const Color(0xFF00BFA5).withValues(alpha: 0.5)
              : borderC,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconC),
          const SizedBox(height: 8),
          SizedBox(
            height: 24,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: text.compassInfoValue.copyWith(
                  color: valueC,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.compassInfoLabel.copyWith(
              color: labelC,
              letterSpacing: 0.3,
            ),
          ),
          if (accent) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnTarget
                        ? const Color(0xFF00BFA5)
                        : const Color(0xFF4B30A1),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    isOnTarget ? 'Facing Mecca!' : 'Rotate to align',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.compassInfoAction.copyWith(
                      color: isOnTarget
                          ? const Color(0xFF00BFA5)
                          : const Color(0xFF7E57C2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
