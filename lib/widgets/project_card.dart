import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../models/project.dart';
import 'cursor_overlay.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovering = false;
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.project.videoUrl != null && widget.project.videoUrl!.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.project.videoUrl!))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _controller?.setLooping(true);
            _controller?.setVolume(0); // Muted
          }
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
    if (hovering) {
      _controller?.play();
    } else {
      _controller?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      child: InkWell(
        onTap: widget.onTap,
        onHover: _handleHover,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuint,
          transform: _isHovering ? (Matrix4.identity()..translate(0, -12, 0)) : Matrix4.identity(),
          child: Card(
            elevation: _isHovering ? 30 : 4,
            shadowColor: Colors.blueAccent.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: _isHovering ? Colors.blueAccent.withOpacity(0.5) : Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                widget.project.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.project.images.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: const Color(0xFF1E293B)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      )
                    : Container(color: const Color(0xFF1E293B)),

                // Video Preview with expansion effect
                if (_controller != null && _isInitialized)
                  AnimatedOpacity(
                    opacity: _isHovering ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutQuart,
                      margin: EdgeInsets.all(_isHovering ? 0 : 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_isHovering ? 0 : 24),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.antiAlias,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),
                  ),

                // Gradient Overlay
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _isHovering ? Colors.black.withOpacity(0.9) : Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
    
                // Content
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.project.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                              ),
                              child: const Text(
                                'View Project',
                                style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isHovering ? -0.125 : 0, // -45 degrees
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutBack,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _isHovering ? Colors.blueAccent : Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: _isHovering ? Colors.white : Colors.white.withOpacity(0.7),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
