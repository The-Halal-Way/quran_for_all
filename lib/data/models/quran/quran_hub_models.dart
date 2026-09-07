import 'package:flutter/material.dart';

enum QuranHubDestination { read, learn }

class QuranHubContent {
  const QuranHubContent({required this.actions, required this.hadiths});

  final List<QuranHubAction> actions;
  final List<QuranHubHadith> hadiths;
}

class QuranHubAction {
  const QuranHubAction({
    required this.destination,
    required this.title,
    required this.detail,
    required this.iconAsset,
    required this.icon,
    required this.accent,
    required this.secondaryAccent,
    this.progress,
  });

  final QuranHubDestination destination;
  final String title;
  final String detail;
  final String iconAsset;
  final IconData icon;
  final Color accent;
  final Color secondaryAccent;
  final double? progress;
}

class QuranHubHadith {
  const QuranHubHadith({
    required this.title,
    required this.body,
    required this.source,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String body;
  final String source;
  final IconData icon;
  final Color accent;
}
