part of '../../../views/dashboard/dashboard_view.dart';

class HadithNavCard extends StatelessWidget {
  final String number, arabicTitle, englishTitle, description;
  final List<Color> accentColors;
  final Color glowColor;
  final bool isDark;
  final Color cardBg, textMain, textSub, textHint, divider;
  final VoidCallback onTap;

  const HadithNavCard({
    super.key,
    required this.number,
    required this.arabicTitle,
    required this.englishTitle,
    required this.description,
    required this.accentColors,
    required this.glowColor,
    required this.isDark,
    required this.cardBg,
    required this.textMain,
    required this.textSub,
    required this.textHint,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppTheme.text(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : divider.withOpacity(0.8),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.primary.withOpacity(isDark ? 0.12 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: accentColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  bottomLeft: Radius.circular(AppRadius.lg),
                ),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: text.dashboardHadithNumber.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'hadith',
                    style: text.dashboardHadithLabel.copyWith(
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      arabicTitle,
                      style: text.dashboardHadithArabicTitle.copyWith(
                        color: textMain,
                      ),
                      textDirection: ui.TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      englishTitle,
                      style: text.dashboardHadithTitle.copyWith(
                        color: textMain,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: text.dashboardHadithDescription.copyWith(
                        color: textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: glowColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: glowColor.withOpacity(0.2),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: glowColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
