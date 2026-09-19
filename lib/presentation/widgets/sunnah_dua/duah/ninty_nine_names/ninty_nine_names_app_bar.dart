import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_for_all/core/localization/l10n_extensions.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/presentation/viewmodels/settings_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/common/app_language_action_button.dart';

class NintyNineNamesAppBar extends StatelessWidget {
  const NintyNineNamesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = AppTheme.text(context);
    final fg = isDark ? Colors.white : const Color(0xFF120B24);

    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    colorScheme.primary,
                    colorScheme.secondary,
                    colorScheme.tertiary,
                  ]
                : const [
                    Color(0xFFDFCFFF),
                    Color(0xFFFFC3DA),
                    Color(0xFFB8F7ED),
                  ],
            stops: const [0, 0.58, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomPaint(painter: _AppBarTilePainter()),
      ),
      leading: IconButton(
        icon: Icon(CupertinoIcons.chevron_back, color: fg, size: 20),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.duahNintyNineTitle,
            style: text.powerfulDuahAppBarTitle.copyWith(color: fg),
          ),
          Text(
            context.l10n.duahNintyNineSubtitle,
            style: text.duahAppBarSubtitle.copyWith(
              color: fg.withValues(alpha: isDark ? 0.78 : 0.86),
            ),
          ),
        ],
      ),
      actions: [_LanguageToggleAction(iconColor: fg)],
    );
  }
}

class _LanguageToggleAction extends StatelessWidget {
  const _LanguageToggleAction({required this.iconColor});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();
    return AppLanguageActionButton(
      tooltip: context.l10n.duahLanguageToggleTooltip,
      current: settingsVm.settings.language,
      iconColor: iconColor,
      onSelected: settingsVm.setLanguage,
    );
  }
}

class _AppBarTilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const step = 38.0;
    for (double x = -step; x < size.width + step; x += step) {
      for (double y = -step; y < size.height + step; y += step) {
        final path = Path()
          ..moveTo(x + step / 2, y)
          ..lineTo(x + step, y + step / 2)
          ..lineTo(x + step / 2, y + step)
          ..lineTo(x, y + step / 2)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
