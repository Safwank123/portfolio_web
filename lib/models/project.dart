import 'dart:convert';
import 'package:flutter/foundation.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String? videoUrl;
  final List<String> techStack;
  final String? githubUrl;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    this.videoUrl,
    required this.techStack,
    this.githubUrl,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    debugPrint('Fetched Project JSON: $json');
    
    // Handle video_url which could be a String or a List<dynamic>
    String? parsedVideoUrl;
    final dynamic videoUrlData = json['video_url'];
    if (videoUrlData is List && videoUrlData.isNotEmpty) {
      parsedVideoUrl = videoUrlData.first.toString();
    } else if (videoUrlData is String && videoUrlData.isNotEmpty) {
      final trimmed = videoUrlData.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          final List<dynamic> decoded = jsonDecode(trimmed);
          if (decoded.isNotEmpty) {
            parsedVideoUrl = decoded.first.toString();
          }
        } catch (_) {
          // Fallback if it's not valid JSON
          parsedVideoUrl = trimmed.replaceAll(RegExp(r'^\["?|"?(?<!\\)]$'), ''); // Strip starting [" and ending "]
        }
      } else {
        parsedVideoUrl = videoUrlData;
      }
    }

    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      videoUrl: parsedVideoUrl,
      techStack: List<String>.from(json['tech_stack'] ?? []),
      githubUrl: json['github_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'video_url': videoUrl,
      'tech_stack': techStack,
      'github_url': githubUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
