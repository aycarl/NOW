import 'package:flutter/material.dart';

import 'package:now/features/meditation_timer/meditation_timer_page.dart';
import 'package:now/features/mindful_bells/pages/mindful_bells_page.dart';
import 'package:now/features/settings/pages/settings_page.dart';

/// The home page of the app, which uses a carousel to display different pages.
class CarouselHomePage extends StatefulWidget {
  /// Creates a new instance of the CarouselHomePage.
  const CarouselHomePage({super.key});

  @override
  State<CarouselHomePage> createState() => _CarouselHomePageState();
}

class _CarouselHomePageState extends State<CarouselHomePage> {
  int _currentPage = 0;

  /// Toggles between the two pages in the carousel.
  void _togglePage() {
    setState(() {
      _currentPage = _currentPage == 0 ? 1 : 0;
    });
  }

  void _handleVerticalSwipe(DragEndDetails details) {
    // A negative velocity means swiping UP
    if (details.primaryVelocity! < -300) {
      if (_currentPage == 0) {
        setState(() => _currentPage = 1);
      }
    } 
    // A positive velocity means swiping DOWN
    else if (details.primaryVelocity! > 300) {
      if (_currentPage == 1) {
        setState(() => _currentPage = 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: Text(
                        'Donations - Coming Soon!',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              );
            },
          ),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double fullHeight = constraints.maxHeight;
            // The peek size is 8% of the available height
            final double peekHeight = fullHeight * 0.08;

            return GestureDetector(
              onVerticalDragEnd: _handleVerticalSwipe,
              child: Stack(
                children: [
                  // Mindful Bells Page
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: 0,
                    right: 0,
                    top: _currentPage == 1 ? peekHeight : fullHeight - peekHeight,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: MindfulBellsPage(
                          currentPageIndex: _currentPage,
                          onToggle: _togglePage,
                        ),
                      ),
                    ),
                  ),

                  // Meditation Timer Page
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: _currentPage == 0 ? peekHeight : fullHeight - peekHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: MeditationTimerPage(
                          currentPageIndex: _currentPage,
                          onToggle: _togglePage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
