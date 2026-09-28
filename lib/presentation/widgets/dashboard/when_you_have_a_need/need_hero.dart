import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/my_colors.dart';
import 'need_hero_art.dart';

class NeedHero extends StatelessWidget {
  const NeedHero({super.key, required this.isBangla});

  final bool isBangla;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: [
        BoxShadow(
          color: MyColors.primaryDark.withValues(alpha: 0.24),
          blurRadius: 28,
          offset: const Offset(0, 13),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.primaryDark,
              MyColors.primary,
              MyColors.tertiaryDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(child: CustomPaint(painter: NeedHeroArt())),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(CupertinoIcons.chevron_back),
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).backButtonTooltip,
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        CupertinoIcons.hand_raised_fill,
                        color: MyColors.secondaryLight.withValues(alpha: 0.9),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    isBangla ? 'দোয়ার পথে' : 'A QUIET PATH TO DUA',
                    style: AppTheme.text(context).labelSmall.copyWith(
                      color: MyColors.secondaryLight,
                      fontWeight: AppTheme.weightExtraBold,
                      letterSpacing: isBangla ? 0 : 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'يَا رَبّ',
                    textDirection: TextDirection.rtl,
                    style: AppTheme.amiri(
                      context,
                      fontSize: 35,
                      color: MyColors.secondaryLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    isBangla
                        ? 'প্রয়োজন ও দোয়া কবুলের আমল'
                        : 'When You Have a Need',
                    style: AppTheme.text(context).headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.weightBlack,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    isBangla
                        ? 'আল্লাহর কাছে সাহায্য, ক্ষমা ও কল্যাণ চাওয়ার কুরআন-সুন্নাহভিত্তিক পথ।'
                        : 'Quranic and Sunnah based ways to seek Allah’s help, forgiveness, and what is good.',
                    style: AppTheme.text(context).bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: MyColors.secondaryLight.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Text(
                      isBangla
                          ? 'ফল আল্লাহর হাতে · কোনো নিশ্চয়তার প্রতিশ্রুতি নয়'
                          : 'A means of seeking acceptance · outcomes belong to Allah',
                      style: AppTheme.text(context).labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.weightBold,
                      ),
                    ),
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
