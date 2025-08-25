import 'package:flutter/material.dart';
import 'meditation_timer_page.dart';
import 'mindful_bells_page.dart';
import 'settings_page.dart';

class CarouselHomePage extends StatefulWidget {
  const CarouselHomePage({super.key});

  @override
  State<CarouselHomePage> createState() => _CarouselHomePageState();
}

class _CarouselHomePageState extends State<CarouselHomePage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.9, // Multi-browse effect: show 90% of current page
    initialPage: 0,
  );
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'N:OW',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          padEnds: false, // Remove padding to show partial content
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: 2, // Material 3 explicitly defines item count
          itemBuilder: (context, index) {
            return Center(
              child: index == 0
                  ? MeditationTimerPage(currentPageIndex: _currentPage)
                  : MindfulBellsPage(currentPageIndex: _currentPage),
            );
          },
        ),
      ),
    );
  }
}
