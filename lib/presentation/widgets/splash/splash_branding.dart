import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extensions.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/my_colors.dart';

class SplashBranding extends StatelessWidget {
  const SplashBranding({super.key});

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      header: true,
      label: '${context.l10n.appName}. ${context.l10n.splashBrandTagline}',
      child: TweenAnimationBuilder<double>(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 950),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 24),
            child: Transform.scale(scale: 0.92 + value * 0.08, child: child),
          ),
        ),
        child: ExcludeSemantics(
          child: Column(
            children: [
              const _SplashGatewayMark(),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: MyColors.tertiaryLight.withValues(alpha: 0.28),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.sparkles,
                      color: MyColors.tertiaryLight,
                      size: 15,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        context.l10n.splashBrandEyebrow.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: AppTheme.text(context).labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                context.l10n.appName,
                textAlign: TextAlign.center,
                style: AppTheme.sora(
                  context,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.08,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Text(
                  context.l10n.splashBrandTagline,
                  textAlign: TextAlign.center,
                  style: AppTheme.text(context).bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashGatewayMark extends StatelessWidget {
  const _SplashGatewayMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 206,
      height: 218,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(child: CustomPaint(painter: _GatewayPainter())),
          Positioned(
            top: 22,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.28),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Icon(
                    CupertinoIcons.moon_stars_fill,
                    size: 17,
                    color: MyColors.tertiaryLight,
                  ),
                ),
                Container(
                  width: 16,
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.28),
                ),
              ],
            ),
          ),
          Positioned(
            top: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      color: Colors.white.withValues(alpha: 0.055),
                    ),
                  ),
                ),
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [MyColors.secondaryLight, MyColors.tertiary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.secondary.withValues(alpha: 0.36),
                        blurRadius: 34,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.book_fill,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _OrnamentDot(alpha: 0.35),
                SizedBox(width: 9),
                _OrnamentDot(alpha: 0.68),
                SizedBox(width: 9),
                _OrnamentDot(alpha: 1),
                SizedBox(width: 9),
                _OrnamentDot(alpha: 0.68),
                SizedBox(width: 9),
                _OrnamentDot(alpha: 0.35),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrnamentDot extends StatelessWidget {
  const _OrnamentDot({required this.alpha});

  final double alpha;

  @override
  Widget build(BuildContext context) => Container(
    width: 4,
    height: 4,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: MyColors.tertiaryLight.withValues(alpha: alpha),
    ),
  );
}

class _GatewayPainter extends CustomPainter {
  const _GatewayPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final arch = Path()
      ..moveTo(size.width * 0.12, size.height)
      ..lineTo(size.width * 0.12, size.height * 0.42)
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.18,
        size.width * 0.34,
        size.height * 0.04,
        size.width * 0.5,
        0,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.04,
        size.width * 0.88,
        size.height * 0.18,
        size.width * 0.88,
        size.height * 0.42,
      )
      ..lineTo(size.width * 0.88, size.height)
      ..close();

    canvas.drawPath(
      arch,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = const LinearGradient(
          colors: [Color(0x24FFFFFF), Color(0x08FFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      arch,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..color = Colors.white.withValues(alpha: 0.24),
    );

    final inner = Path()
      ..moveTo(size.width * 0.22, size.height)
      ..lineTo(size.width * 0.22, size.height * 0.45)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.27,
        size.width * 0.38,
        size.height * 0.15,
        size.width * 0.5,
        size.height * 0.1,
      )
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.15,
        size.width * 0.78,
        size.height * 0.27,
        size.width * 0.78,
        size.height * 0.45,
      )
      ..lineTo(size.width * 0.78, size.height);
    canvas.drawPath(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = MyColors.tertiaryLight.withValues(alpha: 0.28),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
