import 'package:flutter/material.dart';

class AppPageScrollbar extends StatefulWidget {
  const AppPageScrollbar({
    super.key,
    required this.builder,
    this.interactive = true,
  });

  final Widget Function(BuildContext context, ScrollController controller)
  builder;
  final bool interactive;

  @override
  State<AppPageScrollbar> createState() => _AppPageScrollbarState();
}

class _AppPageScrollbarState extends State<AppPageScrollbar> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isDesktop(TargetPlatform platform) {
    return platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context) {
    final desktop = _isDesktop(Theme.of(context).platform);

    return Scrollbar(
      controller: _controller,
      interactive: widget.interactive,
      thumbVisibility: desktop,
      trackVisibility: desktop,
      child: widget.builder(context, _controller),
    );
  }
}
