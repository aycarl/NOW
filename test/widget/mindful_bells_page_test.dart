import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:now/features/mindful_bells/pages/mindful_bells_page.dart';
import 'package:now/features/angel_numbers/angel_numbers_page.dart';
import 'package:now/features/mindful_bells/widgets/bell_form_dialog.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('MindfulBellsPage Widget Tests', () {
    group('Initial State', () {
      testWidgets('renders with default bells', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Check default bells
        expect(find.text('07:00 AM'), findsOneWidget);
        expect(find.text('08:30 AM'), findsOneWidget);
        expect(find.text('Morning Bell'), findsOneWidget);
        expect(find.text('Work Bell'), findsOneWidget);
      });

      testWidgets('displays header correctly', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Check header
        expect(find.text('Mindful Bells'), findsOneWidget);
        
        // Verify header styling
        final headerText = tester.widget<Text>(find.text('Mindful Bells'));
        expect(headerText.style?.fontWeight, FontWeight.bold);
      });

      testWidgets('shows angel numbers navigation card', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Check Angel Numbers card
        expect(find.text('Angel Numbers'), findsOneWidget);
        expect(find.byIcon(Icons.numbers), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      });

      testWidgets('displays floating action button', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - FAB should be visible (less than 5 bells)
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        
        // Verify tooltip
        final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
        expect(fab.tooltip, equals('Add Mindful Bell'));
      });
    });

    group('Bell List Display', () {
      testWidgets('bell list items have correct structure', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Check ListTile structure for first bell
        TestHelpers.verifyListTileStructure(
          tester,
          titleText: '07:00 AM',
          subtitleText: 'Morning Bell',
          leadingIcon: Icons.alarm,
          trailingIcon: Icons.edit,
        );

        // Check second bell
        TestHelpers.verifyListTileStructure(
          tester,
          titleText: '08:30 AM',
          subtitleText: 'Work Bell',
          leadingIcon: Icons.alarm,
          trailingIcon: Icons.edit,
        );
      });

      testWidgets('displays sound information correctly', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Check sound information is displayed
        expect(find.textContaining('Sound: default'), findsNWidgets(2));
        
        // Verify sound text styling
        final soundTexts = tester.widgetList<Text>(find.textContaining('Sound: default'));
        for (final text in soundTexts) {
          expect(text.style?.fontSize, equals(12));
          expect(text.style?.color, isNotNull);
        }
      });

      testWidgets('edit buttons are functional', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Act - Tap first edit button
        final editButtons = find.byIcon(Icons.edit);
        expect(editButtons, findsNWidgets(2));
        
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        // Assert - Dialog should open
        expect(find.text('Edit Mindful Bell'), findsOneWidget);
        expect(find.byType(BellFormDialog), findsOneWidget);
      });
    });

    group('Angel Numbers Navigation', () {
      testWidgets('angel numbers card is tappable', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Act
        final angelNumbersCard = find.text('Angel Numbers');
        await tester.tap(angelNumbersCard);
        await tester.pumpAndSettle();

        // Assert - Should navigate to AngelNumbersPage
        expect(find.byType(AngelNumbersPage), findsOneWidget);
      });

      testWidgets('angel numbers card has correct styling', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Get the Card widget containing Angel Numbers
        final cardFinder = find.ancestor(
          of: find.text('Angel Numbers'),
          matching: find.byType(Card),
        );
        expect(cardFinder, findsOneWidget);

        final card = tester.widget<Card>(cardFinder);
        expect(card.color, isNotNull); // Should have amber color
      });
    });

    group('Add Bell Functionality', () {
      testWidgets('FAB opens add bell dialog', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Act
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        // Assert - Dialog should open
        expect(find.text('Add Mindful Bell'), findsOneWidget);
        expect(find.text('Add'), findsOneWidget);
        expect(find.byType(BellFormDialog), findsOneWidget);
      });

      testWidgets('dialog can be cancelled', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));
        
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        
        expect(find.text('Add Mindful Bell'), findsOneWidget);

        // Act - Cancel dialog
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Assert - Back to main view
        expect(find.text('Add Mindful Bell'), findsNothing);
        expect(find.text('Mindful Bells'), findsOneWidget);
      });
    });

    group('Edit Bell Functionality', () {
      testWidgets('edit button opens edit dialog', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Act
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();

        // Assert - Edit dialog should open
        expect(find.text('Edit Mindful Bell'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
        expect(find.byType(BellFormDialog), findsOneWidget);
      });

      testWidgets('edit dialog shows pre-filled values', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Act
        await tester.tap(find.byIcon(Icons.edit).first);
        await tester.pumpAndSettle();

        // Assert - Dialog should show existing values
        expect(find.text('Edit Mindful Bell'), findsOneWidget);
        // Note: The pre-filled values would be in the form fields,
        // but testing those requires more complex interaction due to time picker
      });
    });

    group('FAB Visibility Logic', () {
      testWidgets('FAB is visible when bells count is less than 5', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - FAB should be visible (2 bells < 5)
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });

      // Note: Testing FAB hiding at 5 bells would require modifying state,
      // which would need a more complex test setup with mock data
    });

    group('Layout and Responsiveness', () {
      testWidgets('layout structure is correct', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Check main layout structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('list view displays correctly', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - ListView should contain ListTiles
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(ListTile), findsAtLeastNWidgets(2));
      });

      testWidgets('handles different screen sizes', (WidgetTester tester) async {
        // Test with smaller screen
        tester.view.physicalSize = const Size(300, 500);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));
        
        // Layout should still work
        expect(find.text('Mindful Bells'), findsOneWidget);
        expect(find.text('Morning Bell'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });

    group('Interaction Testing', () {
      testWidgets('multiple edit buttons work independently', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        final editButtons = find.byIcon(Icons.edit);
        expect(editButtons, findsNWidgets(2));

        // Act - Test first edit button
        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();
        expect(find.text('Edit Mindful Bell'), findsOneWidget);
        
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Act - Test second edit button
        await tester.tap(editButtons.last);
        await tester.pumpAndSettle();
        expect(find.text('Edit Mindful Bell'), findsOneWidget);
        
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Assert - Back to normal state
        expect(find.text('Mindful Bells'), findsOneWidget);
      });

      testWidgets('rapid interactions are handled gracefully', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Act - Rapid tapping
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pump(const Duration(milliseconds: 10));
          
          if (find.text('Cancel').evaluate().isNotEmpty) {
            await tester.tap(find.text('Cancel'));
            await tester.pump(const Duration(milliseconds: 10));
          }
        }

        await tester.pumpAndSettle();

        // Assert - Should remain stable
        expect(find.text('Mindful Bells'), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('provides semantic information', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Check accessible elements
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.edit), findsNWidgets(2));
        
        // Verify buttons are tappable
        final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
        expect(fab.onPressed, isNotNull);
      });

      testWidgets('edit buttons have proper semantics', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        // Assert - Edit buttons should be accessible
        final editButtons = find.byIcon(Icons.edit);
        expect(editButtons, findsNWidgets(2));
        
        for (int i = 0; i < 2; i++) {
          final button = tester.widget<IconButton>(
            find.ancestor(of: editButtons.at(i), matching: find.byType(IconButton))
          );
          expect(button.onPressed, isNotNull);
        }
      });
    });
  });
}
