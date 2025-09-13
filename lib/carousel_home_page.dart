import 'package:flutter/material.dart';
import 'meditation_timer_page.dart';
import 'mindful_bells_page.dart';
import 'settings_page.dart';

/// The home page of the app, which uses a carousel to display different pages.
class CarouselHomePage extends StatefulWidget {
  /// Creates a new instance of the CarouselHomePage.
  const CarouselHomePage({super.key});

  @override
  State<CarouselHomePage> createState() => _CarouselHomePageState();
}

class _CarouselHomePageState extends State<CarouselHomePage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.92, // Multi-browse effect: show 92% of current page
    initialPage: 0,
  );
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Toggles between the two pages in the carousel.
  void _togglePage() {
    final newPage = _currentPage == 0 ? 1 : 0;
    _pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
            final page = index == 0
                ? MeditationTimerPage(
                    currentPageIndex: _currentPage,
                    onToggle: _togglePage,
                  )
                : MindfulBellsPage(
                    currentPageIndex: _currentPage,
                    onToggle: _togglePage,
                  );

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: page,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
