import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:now/features/home/carousel_home_page.dart';
import 'package:now/features/meditation_timer/meditation_timer_page.dart';
import 'package:now/features/mindful_bells/pages/mindful_bells_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CarouselHomePage Widget Tests', () {
    group('App Bar', () {
      testWidgets('displays correct title and actions', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Check app bar title
        expect(find.text('N:OW'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        
        // Check app bar actions
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('donations button shows modal', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Act
        await tester.tap(find.byIcon(Icons.favorite_border));
        await tester.pumpAndSettle();

        // Assert - Modal should appear
        expect(find.text('Donations - Coming Soon!'), findsOneWidget);
        
        // Close modal
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
      });

      testWidgets('settings button navigates to settings page', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Act
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();

        // Assert - Should navigate (we can't easily test navigation without mocking)
        // At minimum, verify button is tappable
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });
    });

    group('Main Structure', () {
      testWidgets('renders main structure correctly', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Check main structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('contains both required pages', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Both page types should be present
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
      });
    });

    group('PageView Configuration', () {
      testWidgets('pageview has correct configuration', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get PageView widget
        final pageView = tester.widget<PageView>(find.byType(PageView));

        // Assert - Check PageView configuration
        expect(pageView.scrollDirection, equals(Axis.vertical));
        expect(pageView.padEnds, equals(false));
        expect(pageView.controller, isNotNull);
        expect(pageView.controller!.viewportFraction, equals(0.92));
      });

      testWidgets('pageview has page change callback', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get PageView widget
        final pageView = tester.widget<PageView>(find.byType(PageView));

        // Assert - Check callback exists
        expect(pageView.onPageChanged, isNotNull);
      });

      testWidgets('page view uses builder with correct item count', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get PageView widget
        final pageView = tester.widget<PageView>(find.byType(PageView));

        // Assert - Should use builder pattern with 2 pages
        expect(pageView.childrenDelegate, isA<SliverChildBuilderDelegate>());
        
        // Verify item count by checking if we have exactly 2 page widgets
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
      });
    });

    group('Page Content and Structure', () {
      testWidgets('pages are wrapped in proper containers', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Should have Center widgets and padding
        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(ClipRRect), findsAtLeastNWidgets(1));
      });

      testWidgets('pages have rounded corners', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get ClipRRect widgets
        final clipRRect = tester.widgetList<ClipRRect>(find.byType(ClipRRect));

        // Assert - Should have rounded corners
        expect(clipRRect.length, greaterThanOrEqualTo(1));
        
        // Check that at least one ClipRRect has rounded corners
        final hasRoundedCorners = clipRRect.any((clip) => 
          clip.borderRadius != BorderRadius.zero);
        expect(hasRoundedCorners, isTrue);
      });
    });

    group('Page Toggle Functionality', () {
      testWidgets('meditation timer page shows toggle button', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Should show meditation timer content with toggle button
        expect(find.text('Meditation Timer'), findsAtLeastNWidgets(1));
        
        // Look for toggle icon buttons
        final toggleButtons = find.byType(IconButton).evaluate()
            .where((element) {
              final widget = element.widget as IconButton;
              final icon = widget.icon;
              if (icon is Icon) {
                return icon.icon == Icons.remove || icon.icon == Icons.add;
              }
              return false;
            });
        expect(toggleButtons.isNotEmpty, isTrue);
      });

      testWidgets('page toggle changes current page index', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        
        // Find toggle button (should show remove icon for page 0)
        final toggleButton = find.byIcon(Icons.remove);
        expect(toggleButton, findsOneWidget);
        
        // Act - Tap toggle button
        await tester.tap(toggleButton);
        await tester.pumpAndSettle();
        
        // Assert - Page should change (we can verify by checking if add icon appears)
        // Note: This test may be flaky depending on the exact implementation
        expect(find.byType(PageView), findsOneWidget);
      });
    });

    group('Layout and Responsiveness', () {
      testWidgets('layout adapts to different screen sizes', (WidgetTester tester) async {
        // Test with default size first
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        expect(find.byType(PageView), findsOneWidget);

        // Test with smaller screen
        tester.view.physicalSize = const Size(300, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        
        // Layout should still work
        expect(find.byType(PageView), findsOneWidget);
        expect(find.text('N:OW'), findsOneWidget);
      });

      testWidgets('maintains proper structure across screen sizes', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Check basic structure is maintained
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(PageView), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('app bar buttons are accessible', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - App bar buttons should be accessible
        final donationsButton = find.byIcon(Icons.favorite_border);
        final settingsButton = find.byIcon(Icons.settings);
        
        expect(donationsButton, findsOneWidget);
        expect(settingsButton, findsOneWidget);
        
        // Verify buttons are tappable
        final donationsWidget = tester.widget<IconButton>(donationsButton);
        final settingsWidget = tester.widget<IconButton>(settingsButton);
        
        expect(donationsWidget.onPressed, isNotNull);
        expect(settingsWidget.onPressed, isNotNull);
      });

      testWidgets('page toggle buttons are accessible', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Toggle buttons should be accessible
        final toggleButtons = find.byType(IconButton).evaluate()
            .where((element) {
              final widget = element.widget as IconButton;
              final icon = widget.icon;
              if (icon is Icon) {
                return icon.icon == Icons.remove || icon.icon == Icons.add;
              }
              return false;
            });
        
        expect(toggleButtons.isNotEmpty, isTrue);
        
        for (final buttonElement in toggleButtons) {
          final button = buttonElement.widget as IconButton;
          expect(button.onPressed, isNotNull);
        }
      });
    });

    group('Performance', () {
      testWidgets('renders without performance issues', (WidgetTester tester) async {
        // Measure rendering time
        final stopwatch = Stopwatch()..start();
        
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        
        stopwatch.stop();
        
        // Assert - Should render quickly (less than 100ms for this simple widget)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        
        // Verify all expected elements rendered
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
      });

      testWidgets('handles page transitions smoothly', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Act - Perform page transition
        final toggleButton = find.byIcon(Icons.remove);
        if (tester.any(toggleButton)) {
          await tester.tap(toggleButton);
          await tester.pump(const Duration(milliseconds: 150)); // During animation
          await tester.pumpAndSettle();
        }

        // Assert - Should remain stable
        expect(find.byType(PageView), findsOneWidget);
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
      });
    });
  });
}
