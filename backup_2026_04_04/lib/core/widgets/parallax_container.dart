import 'package:flutter/material.dart';

class ParallaxContainer extends StatefulWidget {
  final Widget child;
  final double speed;
  final ScrollController scrollController;

  const ParallaxContainer({
    super.key,
    required this.child,
    required this.scrollController,
    this.speed = 0.5,
  });

  @override
  State<ParallaxContainer> createState() => _ParallaxContainerState();
}

class _ParallaxContainerState extends State<ParallaxContainer> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _offset = widget.scrollController.offset * widget.speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_offset),
      child: widget.child,
    );
  }
}

class ParallaxSection extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final double backgroundSpeed;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;

  const ParallaxSection({
    super.key,
    required this.child,
    required this.scrollController,
    this.backgroundSpeed = 0.3,
    this.backgroundColor,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (backgroundGradient != null)
          ParallaxContainer(
            scrollController: scrollController,
            speed: backgroundSpeed,
            child: Container(
              height: MediaQuery.of(context).size.height * 1.2,
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
            ),
          ),
        if (backgroundColor != null && backgroundGradient == null)
          ParallaxContainer(
            scrollController: scrollController,
            speed: backgroundSpeed,
            child: Container(
              height: MediaQuery.of(context).size.height * 1.2,
              color: backgroundColor,
            ),
          ),
        child,
      ],
    );
  }
}
