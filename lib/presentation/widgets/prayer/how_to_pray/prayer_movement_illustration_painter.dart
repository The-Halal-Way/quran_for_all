import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PrayerMovementIllustrationPainter extends CustomPainter {
  const PrayerMovementIllustrationPainter({
    required this.image,
    required this.source,
  });

  final ui.Image image;
  final Rect source;

  @override
  void paint(Canvas canvas, Size size) {
    final fitted = applyBoxFit(BoxFit.contain, source.size, size);
    final destination = Alignment.bottomCenter.inscribe(
      fitted.destination,
      Offset.zero & size,
    );
    canvas.drawImageRect(
      image,
      source,
      destination,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(covariant PrayerMovementIllustrationPainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.source != source;
}
