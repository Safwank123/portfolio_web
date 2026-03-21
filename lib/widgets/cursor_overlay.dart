import 'package:flutter/material.dart';

class CursorOverlay extends StatefulWidget {
  final Widget child;
  const CursorOverlay({super.key, required this.child});

  static _CursorOverlayState? of(BuildContext context) {
    return context.findAncestorStateOfType<_CursorOverlayState>();
  }

  @override
  State<CursorOverlay> createState() => _CursorOverlayState();
}

class _CursorOverlayState extends State<CursorOverlay> {
  Offset _cursorPos = Offset.zero;
  bool _isHovering = false;
  bool _isVisible = false;

  void setHovering(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isVisible = true),
      onExit: (_) => setState(() => _isVisible = false),
      onHover: (event) {
        setState(() {
          _cursorPos = event.position;
          _isVisible = true;
        });
      },
      opaque: false,
      child: Stack(
        children: [
          widget.child,
          if (_isVisible)
            _AnimatedRing(
              targetPos: _cursorPos,
              isHovering: _isHovering,
            ),
          if (_isVisible)
            Positioned(
              left: _cursorPos.dx - 4,
              top: _cursorPos.dy - 4,
              child: IgnorePointer(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedRing extends StatefulWidget {
  final Offset targetPos;
  final bool isHovering;

  const _AnimatedRing({
    required this.targetPos,
    required this.isHovering,
  });

  @override
  State<_AnimatedRing> createState() => _AnimatedRingState();
}

class _AnimatedRingState extends State<_AnimatedRing> with SingleTickerProviderStateMixin {
  late Offset _currentPos;

  @override
  void initState() {
    super.initState();
    _currentPos = widget.targetPos;
  }

  @override
  void didUpdateWidget(_AnimatedRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Smoothly follow the target position
    _currentPos = Offset.lerp(_currentPos, widget.targetPos, 0.2) ?? widget.targetPos;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      left: widget.targetPos.dx - (widget.isHovering ? 30 : 15),
      top: widget.targetPos.dy - (widget.isHovering ? 30 : 15),
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.isHovering ? 60 : 30,
          height: widget.isHovering ? 60 : 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blueAccent.withOpacity(0.5),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class CursorHoverRegion extends StatelessWidget {
  final Widget child;
  const CursorHoverRegion({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => CursorOverlay.of(context)?.setHovering(true),
      onExit: (_) => CursorOverlay.of(context)?.setHovering(false),
      child: child,
    );
  }
}
