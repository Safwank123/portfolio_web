import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(child: _PulsingGrid()),
        Positioned.fill(child: _AmbientOrbs()),
        Positioned.fill(child: _NoiseOverlay()),
      ],
    );
  }
}

class _PulsingGrid extends StatefulWidget {
  const _PulsingGrid();

  @override
  State<_PulsingGrid> createState() => _PulsingGridState();
}

class _PulsingGridState extends State<_PulsingGrid> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GridPainter(opacity: 0.05 + (_controller.value * 0.05)),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final double opacity;
  _GridPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(opacity)
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => oldDelegate.opacity != opacity;
}

class _AmbientOrbs extends StatefulWidget {
  const _AmbientOrbs();

  @override
  State<_AmbientOrbs> createState() => _AmbientOrbsState();
}

class _AmbientOrbsState extends State<_AmbientOrbs> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Orb> _orbs = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 5; i++) {
      _orbs.add(_Orb(
        color: i % 2 == 0 ? Colors.blueAccent : Colors.purpleAccent,
        size: 200.0 + _random.nextDouble() * 200,
        initialPos: Offset(_random.nextDouble(), _random.nextDouble()),
        speed: 0.1 + _random.nextDouble() * 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _orbs.map((orb) {
            final t = _controller.value;
            final dx = (orb.initialPos.dx + sin(t * 2 * pi * orb.speed)) % 1.0;
            final dy = (orb.initialPos.dy + cos(t * 2 * pi * orb.speed)) % 1.0;

            return Positioned(
              left: dx * MediaQuery.of(context).size.width - orb.size / 2,
              top: dy * MediaQuery.of(context).size.height - orb.size / 2,
              child: Container(
                width: orb.size,
                height: orb.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      orb.color.withOpacity(0.15),
                      orb.color.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _Orb {
  final Color color;
  final double size;
  final Offset initialPos;
  final double speed;

  _Orb({
    required this.color,
    required this.size,
    required this.initialPos,
    required this.speed,
  });
}
class _NoiseOverlay extends StatelessWidget {
  const _NoiseOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.05,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      ),
    );
  }
}
