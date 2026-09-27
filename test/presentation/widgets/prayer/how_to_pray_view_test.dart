import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/core/theme/app_theme.dart';
import 'package:quran_for_all/core/theme/my_images.dart';
import 'package:quran_for_all/data/models/prayer/prayer_guide_variant.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/views/prayer/how_to_pray/how_to_pray_view.dart';
import 'package:quran_for_all/presentation/widgets/prayer/how_to_pray/prayer_guide_variant_option.dart';
import 'package:quran_for_all/presentation/widgets/prayer/how_to_pray/prayer_guide_variant_selector.dart';
import 'package:quran_for_all/presentation/widgets/prayer/how_to_pray/prayer_movement_fiqh_note.dart';
import 'package:quran_for_all/presentation/widgets/prayer/how_to_pray/prayer_movement_image_frame.dart';
import 'package:quran_for_all/presentation/widgets/prayer/how_to_pray/prayer_movement_illustration.dart';
import 'package:quran_for_all/presentation/widgets/prayer/how_to_pray/prayer_movement_step_card.dart';

const _maleAssets = [
  MyImages.takbeerh,
  MyImages.alQiyam,
  MyImages.ruku,
  MyImages.qiyam,
  MyImages.sajjadah,
  MyImages.tashahhud,
  MyImages.tashahhudFingerLift,
  MyImages.tashahhud,
  MyImages.salamRight,
  MyImages.salamLeft,
  MyImages.afterPrayer,
];

const _femaleAssets = [
  MyImages.femaleTakbeerh,
  MyImages.femaleAlQiyam,
  MyImages.femaleRukuCorrected,
  MyImages.femaleQiyam,
  MyImages.femaleSajjadahCorrected,
  MyImages.femaleTashahhud,
  MyImages.femaleTashahhudFingerLiftCorrected,
  MyImages.femaleTashahhud,
  MyImages.femaleSalamRight,
  MyImages.femaleSalamRight,
  MyImages.femaleAfterPrayer,
];

void main() {
  for (final locale in ['en', 'bn']) {
    for (final brightness in Brightness.values) {
      testWidgets(
        '$locale $brightness switches both complete guides on a narrow phone',
        (tester) async {
          await _pumpGuide(tester, locale: locale, brightness: brightness);
          final maleSteps = tester
              .widgetList<PrayerMovementStepCard>(
                find.byType(PrayerMovementStepCard),
              )
              .map((card) => card.step)
              .toList();
          expect(maleSteps.map((step) => step.imageAsset), _maleAssets);
          expect(find.byType(PrayerMovementImageFrame), findsNWidgets(11));

          for (final variant in [
            PrayerGuideVariant.male,
            PrayerGuideVariant.female,
          ]) {
            if (variant == PrayerGuideVariant.female) {
              await tester.tap(
                find.descendant(
                  of: find.byType(PrayerGuideVariantSelector),
                  matching: find.text(locale == 'bn' ? 'নারী' : 'Female'),
                ),
              );
              await tester.pumpAndSettle();
            }
            final steps = tester
                .widgetList<PrayerMovementStepCard>(
                  find.byType(PrayerMovementStepCard),
                )
                .map((card) => card.step)
                .toList();
            expect(
              steps.map((step) => step.imageAsset),
              variant == PrayerGuideVariant.male ? _maleAssets : _femaleAssets,
            );
            for (var index = 0; index < steps.length; index++) {
              expect(steps[index].arabic, maleSteps[index].arabic);
              expect(
                steps[index].pronunciation,
                maleSteps[index].pronunciation,
              );
              expect(steps[index].translation, maleSteps[index].translation);
              final mirror = variant == PrayerGuideVariant.female && index == 8;
              expect(steps[index].mirrorImage, mirror);
              final illustration = tester.widget<PrayerMovementIllustration>(
                find.descendant(
                  of: find.byType(PrayerMovementImageFrame).at(index),
                  matching: find.byType(PrayerMovementIllustration),
                ),
              );
              expect(illustration.mirror, mirror);
            }
            final selected = tester
                .widgetList<PrayerGuideVariantOption>(
                  find.byType(PrayerGuideVariantOption),
                )
                .where((option) => option.selected);
            expect(selected, hasLength(1));
            expect(
              selected.single.label,
              variant == PrayerGuideVariant.male
                  ? (locale == 'bn' ? 'পুরুষ' : 'Male')
                  : (locale == 'bn' ? 'নারী' : 'Female'),
            );

            final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
            final scrollView = tester.widget<SingleChildScrollView>(
              find.byType(SingleChildScrollView),
            );
            expect(scrollbar.thumbVisibility, isTrue);
            expect(scrollbar.interactive, isTrue);
            expect(scrollbar.controller, same(scrollView.controller));
            final controller = scrollView.controller!;
            expect(controller.position.maxScrollExtent, greaterThan(1000));
            await tester.ensureVisible(find.byType(PrayerMovementFiqhNote));
            await tester.pumpAndSettle();
            expect(
              find.byType(PrayerMovementFiqhNote).hitTestable(),
              findsOneWidget,
            );
            expect(controller.offset, greaterThan(1000));
            controller.jumpTo(0);
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          }
        },
      );
    }
  }

  testWidgets('tablet presents female posture and copy side by side', (
    tester,
  ) async {
    await _pumpGuide(tester, size: const Size(1000, 900), scale: 1);
    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();
    final card = find.byType(PrayerMovementStepCard).first;
    final image = find.descendant(
      of: card,
      matching: find.byType(PrayerMovementImageFrame),
    );
    expect(tester.getSize(image).width, 274);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpGuide(
  WidgetTester tester, {
  String locale = 'en',
  Brightness brightness = Brightness.light,
  Size size = const Size(320, 700),
  double scale = 1.8,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: brightness == Brightness.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: const HowToPrayView(),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}
