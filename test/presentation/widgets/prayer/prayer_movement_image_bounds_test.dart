import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_for_all/data/models/prayer/prayer_guide_variant.dart';
import 'package:quran_for_all/l10n/app_localizations.dart';
import 'package:quran_for_all/presentation/viewmodels/prayer/prayer_movement_guide_viewmodel.dart';
import 'package:quran_for_all/presentation/widgets/prayer/how_to_pray/prayer_movement_image_bounds.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'male and female frames include all opaque artwork and the complete mat',
    () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final model = PrayerMovementGuideViewModel();
      addTearDown(model.dispose);
      final assets = <String>{};
      for (final variant in PrayerGuideVariant.values) {
        model.selectVariant(variant);
        assets.addAll(model.steps(l10n).map((step) => step.imageAsset));
      }
      expect(assets, hasLength(19));

      for (final asset in assets) {
        final bytes = await rootBundle.load(asset);
        final codec = await ui.instantiateImageCodec(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        );
        final image = (await codec.getNextFrame()).image;
        final size = Size(image.width.toDouble(), image.height.toDouble());
        final source = PrayerMovementImageBounds.forAsset(asset, size);
        expect(
          (Offset.zero & size).contains(source.topLeft),
          isTrue,
          reason: asset,
        );
        expect(source.right, lessThanOrEqualTo(size.width), reason: asset);
        expect(source.bottom, lessThanOrEqualTo(size.height), reason: asset);
        final rgba = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        var left = image.width;
        var top = image.height;
        var right = 0;
        var bottom = 0;
        for (var y = 0; y < image.height; y++) {
          for (var x = 0; x < image.width; x++) {
            if (rgba.getUint8((y * image.width + x) * 4 + 3) < 128) continue;
            if (x < left) left = x;
            if (x + 1 > right) right = x + 1;
            if (y < top) top = y;
            if (y + 1 > bottom) bottom = y + 1;
          }
        }
        expect(source.left, lessThanOrEqualTo(left), reason: asset);
        expect(source.top, lessThanOrEqualTo(top), reason: asset);
        expect(source.right, greaterThanOrEqualTo(right), reason: asset);
        expect(source.bottom, greaterThanOrEqualTo(bottom), reason: asset);
        codec.dispose();
        image.dispose();
      }
    },
  );
}
