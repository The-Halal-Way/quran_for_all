part of '../../../views/dashboard/dashboard_view.dart';

class ActionItem {
  final IconData icon;
  final String label;
  final String? sublabel;
  final Color color;
  final VoidCallback onTap;

  const ActionItem({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.color,
    required this.onTap,
  });
}
