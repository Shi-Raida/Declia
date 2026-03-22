import 'package:flutter/material.dart';

/// A [Column] that staggers its children with fade-in + slide-up on mount.
class StaggeredFadeSlideColumn extends StatefulWidget {
  const StaggeredFadeSlideColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  State<StaggeredFadeSlideColumn> createState() =>
      _StaggeredFadeSlideColumnState();
}

class _StaggeredFadeSlideColumnState extends State<StaggeredFadeSlideColumn>
    with SingleTickerProviderStateMixin {
  static const _staggerMs = 30;
  static const _itemMs = 350;
  static const _slideOffset = 12.0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final count = widget.children.length;
    final totalMs = _itemMs + _staggerMs * (count - 1).clamp(0, 999);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _controller.duration!.inMilliseconds;
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: List.generate(widget.children.length, (i) {
        final startMs = _staggerMs * i;
        final endMs = startMs + _itemMs;
        final begin = (startMs / totalMs).clamp(0.0, 1.0);
        final end = (endMs / totalMs).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.easeOutCubic),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Opacity(
            opacity: animation.value,
            child: Transform.translate(
              offset: Offset(0, _slideOffset * (1 - animation.value)),
              child: child,
            ),
          ),
          child: widget.children[i],
        );
      }),
    );
  }
}
