import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/project.dart';

class ProjectDetailModal extends StatefulWidget {
  final Project project;

  const ProjectDetailModal({super.key, required this.project});

  @override
  State<ProjectDetailModal> createState() => _ProjectDetailModalState();
}

class _ProjectDetailModalState extends State<ProjectDetailModal> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _videoError = false;
  @override
  void initState() {
    super.initState();
    if (widget.project.videoUrl != null &&
        widget.project.videoUrl!.isNotEmpty) {
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    final rawUrl = widget.project.videoUrl!;
    final cleanedUrl = rawUrl
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '');
    final uri = Uri.tryParse(cleanedUrl);

    if (uri != null && uri.hasScheme) {
      try {
        _videoPlayerController = VideoPlayerController.networkUrl(uri);
        await _videoPlayerController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          placeholder: const Center(child: CircularProgressIndicator()),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );

        if (mounted) {
          setState(() => _isInitialized = true);
        }
      } catch (e) {
        debugPrint('Chewie init error: $e');
        if (mounted) {
          setState(() => _videoError = true);
        }
      }
    } else {
      if (mounted) {
        setState(() => _videoError = true);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : size.width * 0.1,
        vertical: isMobile ? 10 : size.height * 0.05,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Media Header (Carousel)
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: double.infinity,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                      ),
                      items: [
                        // Slide 1: Description
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.project.title,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.project.description,
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.6,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.project.videoUrl != null &&
                                  widget.project.videoUrl!.isNotEmpty) ...[
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    const Text(
                                      'Swipe for video',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.blueAccent,
                                      size: 20,
                                    )
                                        .animate(onPlay: (controller) => controller.repeat())
                                        .moveX(begin: 0, end: 5, duration: 600.ms)
                                        .fadeIn(duration: 600.ms),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        if (widget.project.videoUrl != null &&
                            widget.project.videoUrl!.isNotEmpty)
                          Container(
                            color: Colors.black,
                            child: _isInitialized && _chewieController != null
                                ? Chewie(controller: _chewieController!)
                                : _videoError
                                ? const Center(
                                    child: Text(
                                      'Video format not supported',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),

                        // Rest of Slide: Images
                        ...widget.project.images.map((url) {
                          return CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        }),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.project.githubUrl != null)
                          ElevatedButton.icon(
                            onPressed: () =>
                                _launchURL(widget.project.githubUrl),
                            icon: const Icon(Icons.code),
                            label: const Text('Source Code'),
                          ),
                      ],
                    ),
                    // const SizedBox(height: 32),
                    // const Text(
                    //   'Technologies used',
                    //   style: TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                    // ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.project.techStack.map((tech) {
                        return Chip(
                          label: Text(tech),
                          backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          side: BorderSide(
                            color: Colors.blueAccent.withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
