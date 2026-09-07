import 'package:flutter/material.dart';

class PrayerReferenceItem {
  const PrayerReferenceItem({
    required this.title,
    required this.semanticDescription,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String semanticDescription;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
