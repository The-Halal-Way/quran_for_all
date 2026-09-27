import 'dart:ui';

import '../../../../core/theme/my_images.dart';

/// Visible illustration bounds, in original asset pixels. Removing transparent
/// padding at paint time keeps feet, mats and seated poses consistently framed.
class PrayerMovementImageBounds {
  const PrayerMovementImageBounds._();

  static Rect forAsset(String asset, Size imageSize) =>
      _bounds[asset] ?? Offset.zero & imageSize;

  static const _bounds = {
    MyImages.afterPrayer: Rect.fromLTRB(32, 67, 425, 392),
    MyImages.alQiyam: Rect.fromLTRB(33, 110, 282, 622),
    MyImages.qiyam: Rect.fromLTRB(32, 109, 281, 622),
    MyImages.ruku: Rect.fromLTRB(34, 119, 421, 387),
    MyImages.sajjadah: Rect.fromLTRB(33, 191, 425, 392),
    MyImages.salamLeft: Rect.fromLTRB(28, 205, 277, 622),
    MyImages.salamRight: Rect.fromLTRB(27, 199, 276, 617),
    MyImages.takbeerh: Rect.fromLTRB(76, 109, 325, 622),
    MyImages.tashahhud: Rect.fromLTRB(76, 68, 463, 388),
    MyImages.tashahhudFingerLift: Rect.fromLTRB(27, 199, 276, 617),
    MyImages.femaleAfterPrayer: Rect.fromLTRB(36, 242, 1142, 1119),
    MyImages.femaleAlQiyam: Rect.fromLTRB(93, 183, 748, 1618),
    MyImages.femaleQiyam: Rect.fromLTRB(111, 86, 828, 1607),
    MyImages.femaleSalamRight: Rect.fromLTRB(45, 389, 865, 1443),
    MyImages.femaleSalamLeft: Rect.fromLTRB(86, 213, 1184, 1067),
    MyImages.femaleTakbeerh: Rect.fromLTRB(36, 141, 805, 1719),
    MyImages.femaleTashahhud: Rect.fromLTRB(41, 432, 801, 1534),
    MyImages.femaleRukuCorrected: Rect.fromLTRB(144, 188, 1213, 1070),
    MyImages.femaleSajjadahCorrected: Rect.fromLTRB(120, 161, 1682, 785),
    MyImages.femaleTashahhudFingerLiftCorrected: Rect.fromLTRB(
      36,
      20,
      1026,
      1409,
    ),
  };
}
