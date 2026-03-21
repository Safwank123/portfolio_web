import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TestimonialCarousel extends StatelessWidget {
  const TestimonialCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = [
      {
        'name': 'John Doe',
        'role': 'CEO at Tech Corp',
        'text': 'Working with this developer was a fantastic experience. The attention to detail and ability to deliver high-quality code is impressive.',
      },
      {
        'name': 'Jane Smith',
        'role': 'Product Manager',
        'text': 'The mobile app delivered exceeded our expectations. Highly recommended for any Flutter project!',
      },
      {
        'name': 'Mike Johnson',
        'role': 'CTO',
        'text': 'Fast, efficient, and great communication. A true professional who understands both design and development.',
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 320,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
      ),
      items: testimonials.map((t) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.format_quote, color: Colors.blueAccent, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    t['text']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    t['role']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
