import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../projects/projects_grid.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/cursor_overlay.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/service_card.dart';
import '../../widgets/testimonial_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'safwanmuhammed546@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Portfolio Inquiry',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          SingleChildScrollView(
            child: Column(
              children: [
                HeroSection(
                  onViewProjects: () => _scrollTo(_projectsKey),
                  onContact: () => _scrollTo(_contactKey),
                ),
                const SizedBox(height: 80),

                const MarqueeTechStack(),
                const SizedBox(height: 80),
                const ServicesSection(),
                const SizedBox(height: 80),
                ProjectsGrid(key: _projectsKey),

                const SizedBox(height: 80),
                ContactSection(key: _contactKey, onSendEmail: _sendEmail),
              ],
            ),
          ),
          Navbar(
            isScrolled: _isScrolled,
            onHome: () => _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOutQuart,
            ),
            onWork: () => _scrollTo(_projectsKey),
            onServices: () =>
                _scrollTo(_contactKey), // services is combined in home for now
            onContact: () => _scrollTo(_contactKey),
          ),
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  final VoidCallback onViewProjects;
  final VoidCallback onContact;

  const HeroSection({
    super.key,
    required this.onViewProjects,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Muhammed Safwan',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    letterSpacing: 4,
                    color: Colors.blueAccent,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 10),
                Stack(
                      children: [
                        // Outlined Text
                        Text(
                          'Flutter Developer',
                          style: GoogleFonts.syne(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.blueAccent.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          'Flutter Developer',
                          style: GoogleFonts.syne(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      Text(
                            'Building beautiful, high-performance mobile and web applications.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmMono(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CursorHoverRegion(
                      child: ElevatedButton(
                        onPressed: onViewProjects,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('View Projects'),
                      ),
                    ).animate().fadeIn(delay: 600.ms).scale(),
                    const SizedBox(width: 20),
                    CursorHoverRegion(
                      child: OutlinedButton(
                        onPressed: onContact,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          side: const BorderSide(color: Colors.blueAccent),
                        ),
                        child: const Text('Contact Me'),
                      ),
                    ).animate().fadeIn(delay: 800.ms).scale(),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(bottom: 40, child: ScrollIndicator()),
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Wrap(
        spacing: 80,
        runSpacing: 40,
        alignment: WrapAlignment.center,
        children: [
          AnimatedCounter(value: 5, label: 'YEARS EXP', suffix: '+'),
          AnimatedCounter(value: 50, label: 'PROJECTS', suffix: '+'),
          AnimatedCounter(value: 30, label: 'HAPPY CLIENTS', suffix: '+'),
          AnimatedCounter(value: 12, label: 'AWARDS', suffix: ''),
        ],
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Text(
            'My Services',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ).animate().fadeIn().slideY(),
          const SizedBox(height: 60),
          const Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: 350,
                child: ServiceCard(
                  title: 'Mobile Development',
                  description:
                      'High-performance cross-platform apps built with Flutter for iOS and Android.',
                  icon: Icons.phone_android,
                ),
              ),
              SizedBox(
                width: 350,
                child: ServiceCard(
                  title: 'Web Development',
                  description:
                      'Responsive and interactive web applications using Flutter Web and modern web tech.',
                  icon: Icons.web,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Client Testimonials',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ).animate().fadeIn().slideY(),
        const SizedBox(height: 60),
        const TestimonialCarousel(),
      ],
    );
  }
}

class Navbar extends StatelessWidget {
  final bool isScrolled;
  final VoidCallback onHome;
  final VoidCallback onWork;
  final VoidCallback onServices;
  final VoidCallback onContact;

  const Navbar({
    super.key,
    required this.isScrolled,
    required this.onHome,
    required this.onWork,
    required this.onServices,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 1150,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 80,
        decoration: BoxDecoration(
          color: isScrolled
              ? const Color(0xFF020617).withOpacity(0.9)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isScrolled
                  ? Colors.white.withOpacity(0.05)
                  : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isScrolled ? 12 : 0,
              sigmaY: isScrolled ? 12 : 0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GestureDetector(
                  //   onTap: onHome,
                  //   child: Text(
                  //     'Muhammed Safwan',
                  //     style: GoogleFonts.syne(
                  //       fontSize: 24,
                  //       fontWeight: FontWeight.w800,
                  //       letterSpacing: 2,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  Row(
                    children: [
                      _NavButton(label: 'WORK', onTap: onWork),
                      const SizedBox(width: 40),
                      _NavButton(label: 'SERVICES', onTap: onServices),
                      const SizedBox(width: 40),
                      _NavButton(label: 'CONTACT', onTap: onContact),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CursorHoverRegion(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.dmMono(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  final VoidCallback onSendEmail;
  const ContactSection({super.key, required this.onSendEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            'Let\'s build something together',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'I\'m always open to new opportunities and collaborations.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          CursorHoverRegion(
            child: ElevatedButton.icon(
              onPressed: onSendEmail,
              icon: const Icon(Icons.email),
              label: const Text('Send an Email'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'SCROLL',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 4,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 1,
          height: 60,
          color: Colors.blueAccent.withOpacity(0.2),
          child: Stack(
            children: [
              Container(
                    width: 1,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blueAccent,
                          Colors.blueAccent.withOpacity(0),
                        ],
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1500.ms, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}

class MarqueeTechStack extends StatelessWidget {
  const MarqueeTechStack({super.key});

  @override
  Widget build(BuildContext context) {
    final techs = [
      'Flutter',
      'Dart',
      'Firebase',
      'Supabase',
      'Node.js',
      'Express',
      'MongoDB',
      'PostgreSQL',
      'Git',
      'Docker',
      'AWS',
      'UI/UX Design',
      'REST API',
      'GraphQL',
    ];

    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child:
          ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final tech = techs[index % techs.length];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    alignment: Alignment.center,
                    child: Text(
                      tech,
                      style: GoogleFonts.outfit(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  );
                },
              )
              .animate(onPlay: (controller) => controller.repeat())
              .custom(
                duration: 30.seconds,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(-value * 1000, 0),
                    child: child,
                  );
                },
              ),
    );
  }
}
