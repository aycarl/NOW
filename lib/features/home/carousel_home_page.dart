import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:now/core/theme/tao_theme.dart';
import 'package:now/features/meditation_timer/meditation_timer_page.dart';
import 'package:now/features/mindful_bells/pages/mindful_bells_page.dart';
import 'package:now/features/settings/pages/settings_page.dart';
import 'package:now/features/settings/providers/settings_provider.dart';

/// The home sanctuary of the N:OW app.
///
/// Uses a stacked-card layout (`Stack` + `AnimatedPositioned`) with a
/// dissolved `AppBar` and full Yin/Yang theme adaptation. When a meditation
/// countdown is active, all surrounding chrome smoothly dissolves away.
class CarouselHomePage extends StatefulWidget {
  /// Creates a new instance of the CarouselHomePage.
  const CarouselHomePage({super.key});

  @override
  State<CarouselHomePage> createState() => _CarouselHomePageState();
}

class _CarouselHomePageState extends State<CarouselHomePage> {
  int _currentPage = 0;
  bool _isSessionActive = false;

  /// Toggles between the two pages in the stacked layout.
  void _togglePage() {
    if (_isSessionActive) return;
    setState(() {
      _currentPage = _currentPage == 0 ? 1 : 0;
    });
  }

  void _handleVerticalSwipe(DragEndDetails details) {
    if (_isSessionActive) return;
    final velocity = details.primaryVelocity ?? 0;
    // A negative velocity means swiping UP -> expand Mindful Bells
    if (velocity < -300 && _currentPage == 0) {
      setState(() => _currentPage = 1);
    }
    // A positive velocity means swiping DOWN -> expand Meditation Timer
    else if (velocity > 300 && _currentPage == 1) {
      setState(() => _currentPage = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = TaoPalette.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: p.scaffoldCanvas,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 450),
          opacity: _isSessionActive ? 0.0 : 1.0,
          child: IgnorePointer(
            ignoring: _isSessionActive,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: false,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'N:OW',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: p.inkMuted,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 4.0,
                          fontSize: 13,
                        ),
                  ),
                  if (settingsProvider.showAngelNumbers) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: p.accentGold.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '✦ 11:11',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w300,
                          color: p.accentGold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    size: 19,
                    color: p.inkMuted.withValues(alpha: 0.75),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: p.frostedSheetSurface,
                      isScrollControlled: true,
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Text(
                              'Donations - Coming Soon!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w300,
                                color: p.inkPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 19,
                    color: p.inkMuted.withValues(alpha: 0.75),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double fullHeight = constraints.maxHeight;
            final double peekHeight = (fullHeight * 0.085).clamp(54.0, 72.0);

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragEnd: _handleVerticalSwipe,
              child: Stack(
                children: [
                  // Card 0: Meditation Timer Sanctuary
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: _isSessionActive
                        ? 0
                        : (_currentPage == 0
                            ? peekHeight
                            : fullHeight - peekHeight),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        _currentPage == 1 ? 24.0 : 0.0,
                      ),
                      child: MeditationTimerPage(
                        currentPageIndex: _currentPage,
                        onToggle: _togglePage,
                        onSessionStateChanged: (active) {
                          setState(() {
                            _isSessionActive = active;
                          });
                        },
                      ),
                    ),
                  ),

                  // Card 1: Mindful Bells Sanctuary (slides down completely during active session)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    left: 0,
                    right: 0,
                    top: _isSessionActive
                        ? fullHeight
                        : (_currentPage == 1
                            ? peekHeight
                            : fullHeight - peekHeight),
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28.0),
                      ),
                      child: MindfulBellsPage(
                        currentPageIndex: _currentPage,
                        onToggle: _togglePage,
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
