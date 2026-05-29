import 'package:flutter/material.dart';

enum QuranHubDestination { read, learn }

class QuranHubContent {
  const QuranHubContent({
    required this.actions,
    required this.hadiths,
    required this.stats,
  });

  final List<QuranHubAction> actions;
  final List<QuranHubHadith> hadiths;
  final List<QuranHubStat> stats;
}

class QuranHubAction {
  const QuranHubAction({
    required this.destination,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.actionLabel,
    required this.metricValue,
    required this.metricLabel,
    required this.iconAsset,
    required this.icon,
    required this.accent,
    required this.secondaryAccent,
    this.progress,
  });

  final QuranHubDestination destination;
  final String title;
  final String subtitle;
  final String detail;
  final String actionLabel;
  final String metricValue;
  final String metricLabel;
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

class QuranHubStat {
  const QuranHubStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
}
