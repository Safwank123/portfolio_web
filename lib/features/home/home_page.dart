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
  final GlobalKey _servicesKey = GlobalKey();
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
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  onViewProjects: () => _scrollTo(_projectsKey),
                  onContact: () => _scrollTo(_contactKey),
                ),
                const ResponsiveGap(),
                const MarqueeTechStack(),
                const ResponsiveGap(),
                ServicesSection(key: _servicesKey),
                const ResponsiveGap(),
                ProjectsGrid(key: _projectsKey),
                const ResponsiveGap(),
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
            onServices: () => _scrollTo(_servicesKey),
            onContact: () => _scrollTo(_contactKey),
          ),
        ],
      ),
    );
  }
}

class ResponsiveValues {
  final double width;

  const ResponsiveValues(this.width);

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  double get horizontalPadding {
    if (isMobile) return 20;
    if (isTablet) return 40;
    return 64;
  }

  double get sectionGap {
    if (isMobile) return 48;
    if (isTablet) return 64;
    return 80;
  }

  double clamp(double mobile, double tablet, double desktop) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
}

class ResponsiveGap extends StatelessWidget {
  const ResponsiveGap({super.key});

  @override
  Widget build(BuildContext context) {
    final values = ResponsiveValues(MediaQuery.sizeOf(context).width);
    return SizedBox(height: values.sectionGap);
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
    final values = ResponsiveValues(size.width);
    final nameSize = values.clamp(32, 48, 64);
    final roleSize = values.clamp(38, 54, 64);
    final bodySize = values.clamp(15, 17, 18);

    return Container(
      constraints: BoxConstraints(minHeight: size.height * 0.86),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        values.horizontalPadding,
        values.isMobile ? 112 : 96,
        values.horizontalPadding,
        values.isMobile ? 80 : 96,
      ),
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  'Muhammed Safwan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: nameSize,
                    letterSpacing: values.isMobile ? 1.5 : 4,
                    color: Colors.blueAccent,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Stack(
                    children: [
                      Text(
                        'Flutter Developer',
                        style: GoogleFonts.syne(
                          fontSize: roleSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.blueAccent.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        'Flutter Developer',
                        style: GoogleFonts.syne(
                          fontSize: roleSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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
                              fontSize: bodySize,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.5,
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0),
                ),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 14,
                  children: [
                    CursorHoverRegion(
                      child: ElevatedButton(
                        onPressed: onViewProjects,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(values.isMobile ? 220 : 0, 52),
                          padding: EdgeInsets.symmetric(
                            horizontal: values.isMobile ? 24 : 32,
                            vertical: values.isMobile ? 16 : 20,
                          ),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('View Projects'),
                      ),
                    ).animate().fadeIn(delay: 600.ms).scale(),
                    CursorHoverRegion(
                      child: OutlinedButton(
                        onPressed: onContact,
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(values.isMobile ? 220 : 0, 52),
                          padding: EdgeInsets.symmetric(
                            horizontal: values.isMobile ? 24 : 32,
                            vertical: values.isMobile ? 16 : 20,
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
          ),
          if (!values.isMobile)
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final values = ResponsiveValues(constraints.maxWidth);
        final contentWidth = (constraints.maxWidth - values.horizontalPadding * 2)
            .clamp(0.0, 1120.0);
        final cardWidth = values.isMobile
            ? contentWidth
            : ((contentWidth - 30) / 2).clamp(280.0, 520.0);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: values.horizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                children: [
                  Text(
                    'My Services',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: values.clamp(30, 36, 40),
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().slideY(),
                  SizedBox(height: values.clamp(32, 48, 60)),
                  Wrap(
                    spacing: 30,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: const ServiceCard(
                          title: 'Mobile Development',
                          description:
                              'High-performance cross-platform apps built with Flutter for iOS and Android.',
                          icon: Icons.phone_android,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: const ServiceCard(
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
            ),
          ),
        );
      },
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
      left: 0,
      right: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final values = ResponsiveValues(constraints.maxWidth);
          final isCompact = constraints.maxWidth < 560;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: isCompact ? 64 : 80,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 16 : values.horizontalPadding,
                  ),
                  child: Align(
                    alignment: isCompact
                        ? Alignment.center
                        : Alignment.centerRight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavButton(label: 'WORK', onTap: onWork),
                          SizedBox(width: isCompact ? 14 : 20),
                          _NavButton(label: 'SERVICES', onTap: onServices),
                          SizedBox(width: isCompact ? 14 : 20),
                          _NavButton(label: 'CONTACT', onTap: onContact),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
    final values = ResponsiveValues(MediaQuery.sizeOf(context).width);

    return CursorHoverRegion(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: values.isMobile ? 2 : 0,
          ),
          child: Text(
            label,
            style: GoogleFonts.dmMono(
              fontSize: values.isMobile ? 12 : 13,
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
    final values = ResponsiveValues(MediaQuery.sizeOf(context).width);

    return Container(
      padding: EdgeInsets.fromLTRB(
        values.horizontalPadding,
        values.isMobile ? 24 : 40,
        values.horizontalPadding,
        values.isMobile ? 48 : 60,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Column(
          children: [
          Text(
            'Let\'s build something together',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: values.clamp(26, 30, 32),
                fontWeight: FontWeight.bold,
              ),
          ),
          const SizedBox(height: 20),
          Text(
            'I\'m always open to new opportunities and collaborations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: values.clamp(15, 17, 18),
                color: Colors.grey,
                height: 1.5,
              ),
          ),
            SizedBox(height: values.isMobile ? 28 : 40),
          CursorHoverRegion(
            child: SizedBox(
              width: values.isMobile ? double.infinity : null,
              child: ElevatedButton.icon(
                onPressed: onSendEmail,
                icon: const Icon(Icons.email),
                label: const Text('Send an Email'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  padding: EdgeInsets.symmetric(
                    horizontal: values.isMobile ? 24 : 40,
                    vertical: values.isMobile ? 16 : 20,
                  ),
                ),
              ),
            ),
          ),
          ],
        ),
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
    final values = ResponsiveValues(MediaQuery.sizeOf(context).width);
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
      height: values.isMobile ? 72 : 100,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: values.isMobile ? 24 : 40,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tech,
                      style: GoogleFonts.outfit(
                        fontSize: values.isMobile ? 28 : 40,
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
