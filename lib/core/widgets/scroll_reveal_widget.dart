import 'package:flutter/material.dart';

class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double offset;

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.offset = 100.0,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.offset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_hasAnimated) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final height = renderBox.size.height;
    final screenHeight = MediaQuery.of(context).size.height;

    // Trigger animation when 20% of the widget is visible
    if (offset.dy < screenHeight - (height * 0.2) && offset.dy > -height) {
      _hasAnimated = true;
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _onScroll();
        return false;
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

class ScrollRevealList extends StatelessWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration duration;
  final Curve curve;
  final double offset;

  const ScrollRevealList({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOut,
    this.offset = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        children.length,
        (index) => ScrollRevealWidget(
          delay: staggerDelay * index,
          duration: duration,
          curve: curve,
          offset: offset,
          child: children[index],
        ),
      ),
    );
  }
}
