part of '../../../views/dashboard/dashboard_view.dart';

class ContinueCard extends StatelessWidget {
  final String title, subtitle, detail, arabicSnippet;
  final List<Color> gradientColors;
  final Color glowColor;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const ContinueCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.arabicSnippet,
    required this.gradientColors,
    required this.glowColor,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              right: -8,
              bottom: -8,
              child: Text(
                arabicSnippet,
                style: text.dashboardWatermarkArabic.copyWith(
                  color: Colors.white.withOpacity(0.06),
                ),
                textDirection: ui.TextDirection.rtl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.xsPlus),
                    ),
                    child: Icon(icon, size: 17, color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: text.dashboardCardEyebrow.copyWith(
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: text.dashboardCardTitle.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: text.dashboardCardMeta.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
