import 'package:flutter/material.dart';

class PrayerReferenceItem {
  const PrayerReferenceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
