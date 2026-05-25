part of '../../../views/dashboard/dashboard_view.dart';

class _ActionItem {
  final IconData icon;
  final String label;
  final String? sublabel;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.color,
    required this.onTap,
  });
}
