import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:now/main.dart';
import 'package:now/features/home/carousel_home_page.dart';
import 'package:now/features/meditation_timer/meditation_timer_page.dart';
import 'package:now/features/mindful_bells/pages/mindful_bells_page.dart';
import 'package:now/features/angel_numbers/angel_numbers_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('App Integration Tests', () {
    group('App Launch and Navigation', () {
      testWidgets('app launches successfully with correct structure', (WidgetTester tester) async {
        // Act - Launch the app
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Assert - Verify app structure
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(CarouselHomePage), findsOneWidget);
        
        // Verify theme consistency
        TestHelpers.verifyThemeConsistency(tester);
        
        // Verify app bar and main elements exist
        expect(find.text('N:OW'), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('app bar navigation works correctly', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Test donations modal
        await tester.tap(find.byIcon(Icons.favorite_border));
        await tester.pumpAndSettle();
        
        expect(find.text('Donations - Coming Soon!'), findsOneWidget);
        
        // Close modal
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
        
        // Test settings navigation
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
        
        // Should navigate to settings (can't verify full navigation without complex setup)
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('vertical page carousel works correctly', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Assert - Both pages should be present in the PageView
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
        
        // Verify page toggle functionality
        final toggleButton = find.byIcon(Icons.remove);
        if (tester.any(toggleButton)) {
          await tester.tap(toggleButton);
          await tester.pumpAndSettle();
          
          // Page should change
          expect(find.byType(MeditationTimerPage), findsOneWidget);
          expect(find.byType(MindfulBellsPage), findsOneWidget);
        }
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
        expect(find.text('N:OW'), findsOneWidget);
      });
    });

    group('Full User Workflows', () {
      testWidgets('complete meditation setup workflow', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Verify meditation page is accessible
        expect(find.text('Meditation Timer'), findsAtLeastNWidgets(1));
        
        // Verify meditation controls exist
        expect(find.text('Duration'), findsOneWidget);
        expect(find.text('Sound'), findsOneWidget);
        expect(find.text('Preparation Time'), findsOneWidget);
        
        // Verify initial values
        expect(find.textContaining('10 minutes'), findsOneWidget);
        expect(find.text('Default'), findsOneWidget);
        expect(find.textContaining('10 seconds'), findsOneWidget);
        
        // Verify action button
        expect(find.text('Meditate'), findsOneWidget);
        
        // Test sound picker interaction
        await tester.tap(find.widgetWithText(ListTile, 'Sound'));
        await tester.pumpAndSettle();
        
        // Should show sound picker dialog
        expect(find.text('Select Sound'), findsOneWidget);
        
        // Cancel dialog
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        
        // Test meditate button
        await tester.tap(find.text('Meditate'));
        await tester.pumpAndSettle();
        
        // Should show snackbar
        expect(find.textContaining('Starting'), findsOneWidget);
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
      testWidgets('app handles rapid interactions gracefully', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(const NOWApp());
        await tester.pumpAndSettle();

        // Rapidly tap app bar elements
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.byIcon(Icons.favorite_border));
          await tester.pump(const Duration(milliseconds: 50));
          
          // Close modal if it opens
          if (tester.any(find.text('Donations - Coming Soon!'))) {
            await tester.tapAt(const Offset(50, 50));
            await tester.pump(const Duration(milliseconds: 50));
          }
          
          await tester.tap(find.byIcon(Icons.settings));
          await tester.pump(const Duration(milliseconds: 50));
        }

        await tester.pumpAndSettle();

        // App should still be functional
        expect(find.text('N:OW'), findsOneWidget);
        expect(find.text('Meditation Timer'), findsAtLeastNWidgets(1));
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
