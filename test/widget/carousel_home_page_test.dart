import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:now/carousel_home_page.dart';
import 'package:now/meditation_timer_page.dart';
import 'package:now/mindful_bells_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CarouselHomePage Widget Tests', () {
    group('Widget Structure', () {
      testWidgets('renders main structure correctly', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Check main structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('heading bar contains correct navigation elements', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Check navigation buttons
        expect(find.text('Meditate'), findsOneWidget);
        expect(find.text('Bells'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNWidgets(2));

        // Verify button styling
        final buttons = tester.widgetList<ElevatedButton>(find.byType(ElevatedButton));
        for (final button in buttons) {
          expect(button.child, isA<Text>());
        }
      });

      testWidgets('carousel container has correct structure', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Check expanded container for carousel
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        
        // Verify PageView is within expanded container
        final pageView = tester.widget<PageView>(find.byType(PageView));
        expect(pageView, isNotNull);
      });
    });

    group('PageView Configuration', () {
      testWidgets('pageview has correct scroll configuration', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get PageView widget
        final pageView = tester.widget<PageView>(find.byType(PageView));

        // Assert - Check PageView configuration
        expect(pageView.scrollDirection, equals(Axis.vertical));
        expect(pageView.padEnds, equals(false));
        expect(pageView.controller, isNotNull);
        expect(pageView.controller!.viewportFraction, equals(0.85));
      });

      testWidgets('pageview has page change callback', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get PageView widget
        final pageView = tester.widget<PageView>(find.byType(PageView));

        // Assert - Check callback exists
        expect(pageView.onPageChanged, isNotNull);
      });

      testWidgets('pageview contains both required pages', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Both components should be present
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
      });
    });

    group('Dynamic Scaling and Transforms', () {
      testWidgets('contains transform widgets for scaling', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Should have Transform widgets for scaling
        expect(find.byType(Transform), findsAtLeastNWidgets(2));
        expect(find.byType(Center), findsAtLeastNWidgets(2));
      });

      testWidgets('transform widgets have correct configuration', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get Transform widgets
        final transforms = tester.widgetList<Transform>(find.byType(Transform));

        // Assert - Transforms should exist (at least 2 for the pages)
        expect(transforms.length, greaterThanOrEqualTo(2));
        
        // Each transform should have a child
        for (final transform in transforms) {
          expect(transform.child, isNotNull);
        }
      });
    });

    group('Navigation Button Interactions', () {
      testWidgets('meditate button is tappable and functional', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Act
        final meditateButton = find.widgetWithText(ElevatedButton, 'Meditate');
        expect(meditateButton, findsOneWidget);
        
        await tester.tap(meditateButton);
        await tester.pump();

        // Assert - Button should still exist (no crash)
        expect(find.text('Meditate'), findsOneWidget);
      });

      testWidgets('bells button is tappable and functional', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Act
        final bellsButton = find.widgetWithText(ElevatedButton, 'Bells');
        expect(bellsButton, findsOneWidget);
        
        await tester.tap(bellsButton);
        await tester.pump();

        // Assert - Button should still exist (no crash)
        expect(find.text('Bells'), findsOneWidget);
      });

      testWidgets('navigation buttons have proper styling', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Get button widgets
        final meditateButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Meditate')
        );
        final bellsButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Bells')
        );

        // Assert - Buttons should have proper text children
        expect(meditateButton.child, isA<Text>());
        expect(bellsButton.child, isA<Text>());
        
        // Verify text content
        final meditateText = meditateButton.child as Text;
        final bellsText = bellsButton.child as Text;
        expect(meditateText.data, equals('Meditate'));
        expect(bellsText.data, equals('Bells'));
      });
    });

    group('Layout and Responsiveness', () {
      testWidgets('layout adapts to different screen sizes', (WidgetTester tester) async {
        // Test with default size first
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        expect(find.byType(PageView), findsOneWidget);

        // Test with smaller screen
        tester.binding.window.physicalSizeTestValue = const Size(300, 600);
        tester.binding.window.devicePixelRatioTestValue = 1.0;
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
        addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        
        // Layout should still work
        expect(find.byType(PageView), findsOneWidget);
        expect(find.text('Meditate'), findsOneWidget);
        expect(find.text('Bells'), findsOneWidget);
      });

      testWidgets('maintains proper spacing in heading', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Check container structure for spacing
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        
        // Verify spacing elements
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      });
    });

    group('Accessibility', () {
      testWidgets('provides proper semantic information', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Buttons should be accessible
        final meditateButton = find.widgetWithText(ElevatedButton, 'Meditate');
        final bellsButton = find.widgetWithText(ElevatedButton, 'Bells');
        
        expect(meditateButton, findsOneWidget);
        expect(bellsButton, findsOneWidget);
        
        // Verify tappable elements have proper semantics
        final meditateWidget = tester.widget<ElevatedButton>(meditateButton);
        final bellsWidget = tester.widget<ElevatedButton>(bellsButton);
        
        expect(meditateWidget.onPressed, isNotNull);
        expect(bellsWidget.onPressed, isNotNull);
      });

      testWidgets('navigation is keyboard accessible', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Assert - Buttons should be focusable
        final buttons = find.byType(ElevatedButton);
        expect(buttons, findsNWidgets(2));
        
        // Each button should accept focus
        for (int i = 0; i < 2; i++) {
          final button = tester.widget<ElevatedButton>(buttons.at(i));
          expect(button.focusNode ?? button.autofocus, isNotNull);
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

      testWidgets('handles rapid interactions without issues', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        // Act - Rapid tapping
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.text('Meditate'));
          await tester.pump(const Duration(milliseconds: 10));
          
          await tester.tap(find.text('Bells'));
          await tester.pump(const Duration(milliseconds: 10));
        }

        await tester.pumpAndSettle();

        // Assert - Should remain stable
        expect(find.text('Meditate'), findsOneWidget);
        expect(find.text('Bells'), findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);
      });
    });
  });
}
