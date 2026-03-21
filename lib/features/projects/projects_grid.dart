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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 40),
            child: const Text(
              'Featured Projects',
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 14, color: Colors.grey),
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

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  children: List.generate(projects.length, (index) {
                    final project = projects[index];
                    // 12-column logic:
                    // Large screen: items span 8/12 or 4/12
                    // Small screen: all items span 12/12
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 800;
                        final isTablet = constraints.maxWidth >= 800 && constraints.maxWidth < 1200;
                        
                        double width;
                        if (isMobile) {
                          width = constraints.maxWidth;
                        } else if (isTablet) {
                          width = (constraints.maxWidth / 2) - 20; // 2 columns
                        } else {
                          width = (constraints.maxWidth / 3) - 27; // 3 columns
                        }

                        return SizedBox(
                              width: width,
                              height: isMobile ? 350 : 450,
                              child: ProjectCard(
                                project: project,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ProjectDetailModal(project: project),
                                  );
                                },
                              ),
                            )
                            .animate(delay: (index * 150).ms)
                            .fadeIn(duration: 800.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuart,
                            );
                      },
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
