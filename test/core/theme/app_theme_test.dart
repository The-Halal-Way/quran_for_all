import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_for_all/core/theme/app_gradients.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/app_theme_colors.dart';
import 'package:quran_for_all/core/theme/my_colors.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('light theme uses the imported palette', (tester) async {
    final theme = AppTheme.lightTheme;
    await tester.pumpWidget(MaterialApp(theme: theme, home: const Scaffold()));
    await tester.pumpAndSettle();
    const colors = AppThemeColors.light;

    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, colors.canvas);
    expect(theme.cardTheme.color, colors.surfaceElevated);
    expect(theme.colorScheme.primary, colors.brand);
    expect(theme.colorScheme.secondary, colors.violet);
    expect(theme.colorScheme.tertiary, colors.cyan);
    expect(theme.colorScheme.primaryContainer.a, 1);
    expect(theme.colorScheme.secondaryContainer.a, 1);
    expect(theme.colorScheme.tertiaryContainer.a, 1);
    expect(theme.colorScheme.error, colors.danger);
    expect(theme.colorScheme.surface, colors.surface);
    expect(theme.colorScheme.surfaceContainerHigh, colors.surfaceMuted);
    expect(theme.colorScheme.outline, colors.strokeStrong);
    expect(theme.colorScheme.outlineVariant, colors.stroke);
    expect(theme.colorScheme.onSurface, colors.textPrimary);
    expect(theme.colorScheme.onSurfaceVariant, colors.textSecondary);
    expect(AppGradients.pageBg.colors, [
      colors.surfaceElevated,
      colors.canvas,
      colors.surfaceMuted,
    ]);
    expect(AppGradients.lightHeroBanner.colors, [
      colors.heroStart,
      colors.heroMiddle,
      colors.heroEnd,
    ]);
  });

  testWidgets('dark theme retains its established colors', (tester) async {
    final theme = AppTheme.darkTheme;
    await tester.pumpWidget(MaterialApp(theme: theme, home: const Scaffold()));
    await tester.pumpAndSettle();

    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, MyColors.darkScaffold);
    expect(theme.colorScheme.primary, MyColors.primaryLight);
    expect(theme.colorScheme.secondary, MyColors.secondaryLight);
    expect(theme.colorScheme.tertiary, MyColors.tertiaryLight);
    expect(theme.colorScheme.surface, MyColors.darkSurface);
    expect(theme.colorScheme.onSurface, MyColors.darkTextPrimary);
    expect(theme.colorScheme.outline, MyColors.darkDivider);
  });
}
