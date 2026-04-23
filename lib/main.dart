import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home/home_page.dart';
import 'widgets/cursor_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = 'https://cvuuvjlheeokpswrwwrn.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN2dXV2amxoZWVva3Bzd3J3d3JuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM1NjQyODQsImV4cCI6MjA4OTE0MDI4NH0.UORkM9v-RvSqrffS4Gca_97cat4bMqnWSgGVfuaH59k';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhammed Safwan Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
          surface: const Color(0xFF0F172A),
          background: const Color(0xFF020617),
        ),
        textTheme: GoogleFonts.dmMonoTextTheme(ThemeData.dark().textTheme)
            .copyWith(
              displayLarge: GoogleFonts.syne(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              displayMedium: GoogleFonts.syne(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              displaySmall: GoogleFonts.syne(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headlineLarge: GoogleFonts.syne(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headlineMedium: GoogleFonts.syne(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headlineSmall: GoogleFonts.syne(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
      builder: (context, child) {
        return CursorOverlay(child: child!);
      },
      home: const HomePage(),
    );
  }
}
