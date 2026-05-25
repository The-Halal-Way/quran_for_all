part of '../../../presentation/views/dashboard/dashboard_view.dart';

class DashboardActionItem {
  final IconData icon;
  final String label;
  final String? sublabel;
  final Color color;
  final VoidCallback onTap;

  const DashboardActionItem({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.color,
    required this.onTap,
  });
}
