import 'package:flutter/material.dart';
import 'meditation_timer_page.dart';
import 'mindful_bells_page.dart';

class CarouselHomePage extends StatefulWidget {
  const CarouselHomePage({super.key});

  @override
  State<CarouselHomePage> createState() => _CarouselHomePageState();
}

class _CarouselHomePageState extends State<CarouselHomePage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.85, // Multi-browse effect: show 85% of current page
    initialPage: 0,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          padEnds: false, // Remove padding to show partial content
          itemCount: 2, // Material 3 explicitly defines item count
          itemBuilder: (context, index) {
            return Center(
              child: index == 0
                  ? const MeditationTimerPage()
                  : const MindfulBellsPage(),
            );
          },
        ),
      ),
    );
  }
}
