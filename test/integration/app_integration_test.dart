import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:now/main.dart';
import 'package:now/carousel_home_page.dart';
import 'package:now/meditation_timer_page.dart';
import 'package:now/mindful_bells_page.dart';
import 'package:now/angel_numbers_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('App Integration Tests', () {
    group('App Launch and Navigation', () {
      testWidgets('app launches successfully with correct theme', (WidgetTester tester) async {
        // Act - Launch the app
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Assert - Verify app structure
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(CarouselHomePage), findsOneWidget);
        
        // Verify theme consistency
        TestHelpers.verifyThemeConsistency(tester);
        
        // Verify basic navigation elements exist
        expect(find.text('Meditate'), findsOneWidget);
        expect(find.text('Bells'), findsOneWidget);
      });

      testWidgets('carousel navigation between pages works', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Assert - Both pages should be present in the PageView
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
        
        // Verify navigation buttons are functional
        final meditateButton = find.text('Meditate');
        final bellsButton = find.text('Bells');
        
        expect(meditateButton, findsOneWidget);
        expect(bellsButton, findsOneWidget);

        // Act - Test button interactions
        await tester.tap(meditateButton);
        await tester.pump();
        
        await tester.tap(bellsButton);
        await tester.pump();

        // Assert - No crashes, buttons still exist
        expect(find.text('Meditate'), findsOneWidget);
        expect(find.text('Bells'), findsOneWidget);
      });
    });

    group('Cross-Page Navigation', () {
      testWidgets('navigation from bells page to angel numbers works', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Find and tap Angel Numbers card
        final angelNumbersCard = find.text('Angel Numbers');
        expect(angelNumbersCard, findsOneWidget);

        // Act - Navigate to Angel Numbers
        await tester.tap(angelNumbersCard);
        await tester.pumpAndSettle();

        // Assert - Angel Numbers page should be displayed
        expect(find.byType(AngelNumbersPage), findsOneWidget);
        expect(find.text('Toggle mindful bells for angel numbers on a 12-hour clock'), findsOneWidget);
        
        // Verify angel numbers list exists
        expect(find.byType(SwitchListTile), findsWidgets);
      });

      testWidgets('back navigation from angel numbers works', (WidgetTester tester) async {
        // Arrange - Navigate to Angel Numbers page
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();
        
        await tester.tap(find.text('Angel Numbers'));
        await tester.pumpAndSettle();

        // Verify we're on Angel Numbers page
        expect(find.byType(AngelNumbersPage), findsOneWidget);

        // Act - Navigate back
        final backButton = find.byType(BackButton);
        expect(backButton, findsOneWidget);
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Assert - Back to main app
        expect(find.byType(CarouselHomePage), findsOneWidget);
        expect(find.text('Meditate'), findsOneWidget);
        expect(find.text('Bells'), findsOneWidget);
      });
    });

    group('Full User Workflows', () {
      testWidgets('complete meditation setup workflow', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Verify meditation page is accessible
        expect(find.text('Meditation Timer'), findsOneWidget);
        
        // Verify meditation controls exist
        expect(find.text('Meditation Duration'), findsOneWidget);
        expect(find.text('Sound'), findsOneWidget);
        expect(find.text('Preparation Time'), findsOneWidget);
        
        // Verify action buttons
        expect(find.text('Start'), findsOneWidget);
        expect(find.text('Save Preset'), findsOneWidget);
        
        // Test duration picker interaction
        await tester.tap(find.text('Meditation Duration'));
        await tester.pumpAndSettle();
        
        // Should show time picker dialog (though we can't fully test it due to platform channels)
        // The tap should not crash the app
        expect(find.text('Meditation Timer'), findsOneWidget);
      });

      testWidgets('complete bell management workflow', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Navigate to bells section (it's already visible)
        expect(find.text('Mindful Bells'), findsOneWidget);
        
        // Verify initial bells exist
        expect(find.text('07:00 AM'), findsOneWidget);
        expect(find.text('08:30 AM'), findsOneWidget);
        expect(find.text('Morning Bell'), findsOneWidget);
        expect(find.text('Work Bell'), findsOneWidget);
        
        // Verify FAB for adding bells
        expect(find.byType(FloatingActionButton), findsOneWidget);
        
        // Verify edit functionality
        final editButtons = find.byIcon(Icons.edit);
        expect(editButtons, findsNWidgets(2));
        
        // Test adding a bell (open dialog)
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        
        // Dialog should open (though time picker has platform channel limitations)
        expect(find.text('Add Mindful Bell'), findsOneWidget);
        
        // Close dialog
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        
        // Back to main view
        expect(find.text('Mindful Bells'), findsOneWidget);
      });

      testWidgets('angel numbers toggle workflow', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Navigate to Angel Numbers
        await tester.tap(find.text('Angel Numbers'));
        await tester.pumpAndSettle();

        // Verify angel numbers are displayed
        expect(find.text('1:11'), findsOneWidget);
        expect(find.text('2:22'), findsOneWidget);
        expect(find.text('11:11'), findsOneWidget);
        
        // Verify switches exist and work
        final switches = find.byType(SwitchListTile);
        expect(switches, findsNWidgets(6));
        
        // Test toggling a switch
        final firstSwitch = switches.first;
        await tester.tap(firstSwitch);
        await tester.pump();
        
        // Should not crash and switch should change state
        expect(find.byType(SwitchListTile), findsNWidgets(6));
      });
    });

    group('App State Persistence', () {
      testWidgets('meditation settings persist during navigation', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Find initial meditation duration
        expect(find.textContaining('10 minutes'), findsOneWidget);
        
        // Navigate away and back
        await tester.tap(find.text('Angel Numbers'));
        await tester.pumpAndSettle();
        
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        
        // Settings should persist
        expect(find.textContaining('10 minutes'), findsOneWidget);
      });

      testWidgets('bell configuration persists during navigation', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Verify initial bell count
        final editButtons = find.byIcon(Icons.edit);
        expect(editButtons, findsNWidgets(2));
        
        // Navigate away and back
        await tester.tap(find.text('Angel Numbers'));
        await tester.pumpAndSettle();
        
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        
        // Bells should still exist
        expect(find.byIcon(Icons.edit), findsNWidgets(2));
        expect(find.text('Morning Bell'), findsOneWidget);
        expect(find.text('Work Bell'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('app handles navigation errors gracefully', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Rapidly tap navigation elements
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.text('Meditate'));
          await tester.pump(const Duration(milliseconds: 50));
          
          await tester.tap(find.text('Bells'));
          await tester.pump(const Duration(milliseconds: 50));
        }

        await tester.pumpAndSettle();

        // App should still be functional
        expect(find.text('Meditation Timer'), findsOneWidget);
        expect(find.text('Mindful Bells'), findsOneWidget);
      });

      testWidgets('app handles dialog dismissal properly', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Open and quickly close multiple dialogs
        for (int i = 0; i < 2; i++) {
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();
          
          expect(find.text('Add Mindful Bell'), findsOneWidget);
          
          await tester.tap(find.text('Cancel'));
          await tester.pumpAndSettle();
        }

        // App should remain stable
        expect(find.text('Mindful Bells'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });
  });
}
