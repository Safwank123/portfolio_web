import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../models/project.dart';
import '../../widgets/project_card.dart';
import '../../widgets/project_detail_modal.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProjectsGrid extends StatefulWidget {
  const ProjectsGrid({super.key});

  @override
  State<ProjectsGrid> createState() => _ProjectsGridState();
}

class _ProjectsGridState extends State<ProjectsGrid> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _supabaseService.getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1024;
        final horizontalPadding = isMobile ? 20.0 : (isTablet ? 40.0 : 64.0);
        final contentWidth = (width - horizontalPadding * 2).clamp(0.0, 1180.0);
        final columns = isMobile ? 1 : (isTablet ? 2 : 3);
        final spacing = isMobile ? 20.0 : 32.0;
        final cardWidth = columns == 1
            ? contentWidth
            : (contentWidth - spacing * (columns - 1)) / columns;
        final aspectRatio = isMobile ? 0.92 : (isTablet ? 0.82 : 0.78);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isMobile ? 24 : 40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: isMobile ? 28 : 40),
                    child: Text(
                      'Featured Projects',
                      style: TextStyle(
                        fontSize: isMobile ? 30 : (isTablet ? 36 : 42),
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn().slideX(),
                  ),
                  FutureBuilder<List<Project>>(
                    future: _projectsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading projects: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Tip: Make sure you have created the "projects" table in Supabase and enabled public access using the provided schema.sql script.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final List<Project> projects = snapshot.data ?? [];
                      if (projects.isEmpty) {
                        return const Center(child: Text('No projects found.'));
                      }

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: List.generate(projects.length, (index) {
                          final project = projects[index];

                          return SizedBox(
                                width: cardWidth,
                                child: AspectRatio(
                                  aspectRatio: aspectRatio,
                                  child: ProjectCard(
                                    project: project,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ProjectDetailModal(
                                              project: project,
                                            ),
                                      );
                                    },
                                  ),
                                ),
                              )
                              .animate(delay: (index * 150).ms)
                              .fadeIn(duration: 800.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuart,
                              );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
