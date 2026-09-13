import '../../../../data/models/surah_model.dart';

/// Immutable display data; theme and navigation stay in presentation widgets.
class DashboardHeaderInfo {
  const DashboardHeaderInfo({
    required this.dateLabel,
    required this.hijriDateLabel,
  });

  final String dateLabel;
  final String hijriDateLabel;
}

class DashboardContinueCardsInfo {
  const DashboardContinueCardsInfo({
    required this.reading,
    required this.learning,
  });

  final DashboardContinueCardInfo reading;
  final DashboardContinueLearningInfo learning;
}

class DashboardContinueCardInfo {
  const DashboardContinueCardInfo({
    required this.subtitle,
    required this.detail,
    required this.hasExistingProgress,
    this.surah,
    this.ayahNumber,
  });

  final String subtitle;
  final String detail;
  final bool hasExistingProgress;
  final SurahModel? surah;
  final int? ayahNumber;
}

class DashboardContinueLearningInfo {
  const DashboardContinueLearningInfo({
    required this.subtitle,
    required this.detail,
  });

  final String subtitle;
  final String detail;
}
