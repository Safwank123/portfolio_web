import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final int value;
  final String label;
  final String suffix;
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.label,
    this.suffix = "",
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late Animation<int> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Text(
              '${_animation.value}${widget.suffix}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.5),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
