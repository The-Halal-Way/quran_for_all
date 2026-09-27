import '../../core/theme/my_images.dart';
import '../../data/models/prayer/prayer_guide_variant.dart';

/// Explicit posture mapping: never infer a pose from the order of image files.
class PrayerMovementAssets {
  const PrayerMovementAssets._();

  static String forVariant(String maleAsset, PrayerGuideVariant variant) {
    if (variant == PrayerGuideVariant.male) return maleAsset;
    return _femaleAssets[maleAsset] ?? maleAsset;
  }

  static bool mirrorForVariant(String maleAsset, PrayerGuideVariant variant) =>
      variant == PrayerGuideVariant.female && maleAsset == MyImages.salamRight;

  static const _femaleAssets = {
    MyImages.takbeerh: MyImages.femaleTakbeerh,
    MyImages.alQiyam: MyImages.femaleAlQiyam,
    MyImages.qiyam: MyImages.femaleQiyam,
    MyImages.ruku: MyImages.femaleRukuCorrected,
    MyImages.sajjadah: MyImages.femaleSajjadahCorrected,
    MyImages.tashahhud: MyImages.femaleTashahhud,
    MyImages.tashahhudFingerLift: MyImages.femaleTashahhudFingerLiftCorrected,
    // The supplied front-facing "right" image actually turns to her left.
    // Mirror it for the right salaam; retain its orientation for the left.
    MyImages.salamRight: MyImages.femaleSalamRight,
    MyImages.salamLeft: MyImages.femaleSalamRight,
    MyImages.afterPrayer: MyImages.femaleAfterPrayer,
  };
}
