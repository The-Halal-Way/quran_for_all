import 'package:flutter/material.dart';

/// Keeps the dashboard's small, fixed set of sections after their first visit.
/// Sections still build lazily, but returning to one reuses its layout state
/// and retained paint layers instead of rebuilding cards and book shelves.
class DashboardFeedSection extends StatefulWidget {
  const DashboardFeedSection({
    super.key,
    required this.gap,
    required this.child,
  });

  final double gap;
  final Widget child;

  @override
  State<DashboardFeedSection> createState() => _DashboardFeedSectionState();
}

class _DashboardFeedSectionState extends State<DashboardFeedSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 940),
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.gap),
          child: widget.child,
        ),
      ),
    );
  }
}
