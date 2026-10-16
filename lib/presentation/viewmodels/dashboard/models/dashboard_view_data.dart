/// Immutable display data; theme and navigation stay in presentation widgets.
class DashboardHeaderInfo {
  const DashboardHeaderInfo({
    required this.dateLabel,
    required this.hijriDateLabel,
  });

  final String dateLabel;
  final String hijriDateLabel;
}
