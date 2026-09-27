import 'package:flutter/material.dart';

import 'prayer_movement_image_bounds.dart';
import 'prayer_movement_illustration_painter.dart';

class PrayerMovementIllustration extends StatefulWidget {
  const PrayerMovementIllustration({
    super.key,
    required this.asset,
    required this.semanticLabel,
    this.mirror = false,
  });

  final String asset;
  final String semanticLabel;
  final bool mirror;

  @override
  State<PrayerMovementIllustration> createState() =>
      _PrayerMovementIllustrationState();
}

class _PrayerMovementIllustrationState
    extends State<PrayerMovementIllustration> {
  ImageStream? _stream;
  ImageInfo? _image;
  late final ImageStreamListener _listener = ImageStreamListener(_onImage);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  @override
  void didUpdateWidget(covariant PrayerMovementIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _image?.dispose();
      _image = null;
      _resolve();
    }
  }

  void _resolve() {
    final stream = AssetImage(
      widget.asset,
    ).resolve(createLocalImageConfiguration(context));
    if (stream.key == _stream?.key) return;
    _stream?.removeListener(_listener);
    _stream = stream;
    stream.addListener(_listener);
  }

  void _onImage(ImageInfo image, bool synchronousCall) {
    _image?.dispose();
    if (synchronousCall) {
      _image = image;
    } else {
      setState(() => _image = image);
    }
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    _image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _image?.image;
    return Semantics(
      image: true,
      label: widget.semanticLabel,
      child: image == null
          ? const SizedBox.expand()
          : Transform.flip(
              flipX: widget.mirror,
              child: CustomPaint(
                painter: PrayerMovementIllustrationPainter(
                  image: image,
                  source: PrayerMovementImageBounds.forAsset(
                    widget.asset,
                    Size(image.width.toDouble(), image.height.toDouble()),
                  ),
                ),
                child: const SizedBox.expand(),
              ),
            ),
    );
  }
}
