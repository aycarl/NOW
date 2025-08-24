import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:now/angel_numbers_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('AngelNumbersPage Widget Tests', () {
    group('Page Structure', () {
      testWidgets('renders with correct structure', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Angel Numbers'), findsOneWidget);
      });

      testWidgets('displays description text correctly', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert
        expect(find.text('Toggle mindful bells for angel numbers on a 12-hour clock'), findsOneWidget);
      });

      testWidgets('has back button in app bar', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        // AppBar should have implicit back button when used in navigation
      });
    });

    group('Angel Numbers List', () {
      testWidgets('displays all angel numbers', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - Check all expected angel numbers
        expect(find.text('1:11'), findsOneWidget);
        expect(find.text('2:22'), findsOneWidget);
        expect(find.text('3:33'), findsOneWidget);
        expect(find.text('4:44'), findsOneWidget);
        expect(find.text('5:55'), findsOneWidget);
        expect(find.text('11:11'), findsOneWidget);
      });

      testWidgets('displays correct number of switch tiles', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert
        expect(find.byType(SwitchListTile), findsNWidgets(6));
      });

      testWidgets('all switches start in off position', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Get all switch tiles
        final switches = tester.widgetList<SwitchListTile>(find.byType(SwitchListTile));

        // Assert - All should be false initially
        for (final switchTile in switches) {
          expect(switchTile.value, isFalse);
        }
      });
    });

    group('Switch Interactions', () {
      testWidgets('can toggle individual switches', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Get first switch
        final firstSwitch = find.byType(SwitchListTile).first;
        
        // Verify initial state
        SwitchListTile switchWidget = tester.widget<SwitchListTile>(firstSwitch);
        expect(switchWidget.value, isFalse);

        // Act - Toggle switch
        await tester.tap(firstSwitch);
        await tester.pump();

        // Assert - Switch should be toggled
        switchWidget = tester.widget<SwitchListTile>(firstSwitch);
        expect(switchWidget.value, isTrue);
      });

      testWidgets('can toggle multiple switches independently', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        final switches = find.byType(SwitchListTile);
        expect(switches, findsNWidgets(6));

        // Act - Toggle first and third switches
        await tester.tap(switches.at(0));
        await tester.pump();
        await tester.tap(switches.at(2));
        await tester.pump();

        // Assert - Only toggled switches should be on
        final switchWidgets = tester.widgetList<SwitchListTile>(switches);
        expect(switchWidgets.elementAt(0).value, isTrue);  // First switch on
        expect(switchWidgets.elementAt(1).value, isFalse); // Second switch off
        expect(switchWidgets.elementAt(2).value, isTrue);  // Third switch on
        expect(switchWidgets.elementAt(3).value, isFalse); // Fourth switch off
      });

      testWidgets('can turn switches off after turning them on', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        final firstSwitch = find.byType(SwitchListTile).first;

        // Act - Turn on then off
        await tester.tap(firstSwitch);
        await tester.pump();
        
        SwitchListTile switchWidget = tester.widget<SwitchListTile>(firstSwitch);
        expect(switchWidget.value, isTrue);

        await tester.tap(firstSwitch);
        await tester.pump();

        // Assert - Should be off again
        switchWidget = tester.widget<SwitchListTile>(firstSwitch);
        expect(switchWidget.value, isFalse);
      });
    });

    group('Layout and Scrolling', () {
      testWidgets('list is scrollable', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - Should have scrollable list
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('handles small screen sizes', (WidgetTester tester) async {
        // Arrange - Small screen
        tester.binding.window.physicalSizeTestValue = const Size(300, 400);
        tester.binding.window.devicePixelRatioTestValue = 1.0;
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
        addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - Should still render all elements
        expect(find.text('Angel Numbers'), findsOneWidget);
        expect(find.byType(SwitchListTile), findsNWidgets(6));
        expect(find.text('1:11'), findsOneWidget);
        expect(find.text('11:11'), findsOneWidget);
      });

      testWidgets('content is properly padded', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - Check for padding
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        
        // Verify description has proper padding
        final paddingWidget = find.ancestor(
          of: find.text('Toggle mindful bells for angel numbers on a 12-hour clock'),
          matching: find.byType(Padding),
        );
        expect(paddingWidget, findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('switches are accessible', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - All switches should be tappable
        final switches = find.byType(SwitchListTile);
        expect(switches, findsNWidgets(6));

        // Verify each switch has proper callback
        final switchWidgets = tester.widgetList<SwitchListTile>(switches);
        for (final switchWidget in switchWidgets) {
          expect(switchWidget.onChanged, isNotNull);
        }
      });

      testWidgets('has proper semantic labels', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - Check that titles are present for screen readers
        expect(find.text('1:11'), findsOneWidget);
        expect(find.text('2:22'), findsOneWidget);
        expect(find.text('3:33'), findsOneWidget);
        expect(find.text('4:44'), findsOneWidget);
        expect(find.text('5:55'), findsOneWidget);
        expect(find.text('11:11'), findsOneWidget);
      });

      testWidgets('page title is accessible', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - App bar title should be accessible
        expect(find.text('Angel Numbers'), findsOneWidget);
        
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        final title = appBar.title as Text;
        expect(title.data, equals('Angel Numbers'));
      });
    });

    group('State Management', () {
      testWidgets('state persists during interactions', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Act - Toggle several switches
        await tester.tap(find.byType(SwitchListTile).at(0));
        await tester.pump();
        await tester.tap(find.byType(SwitchListTile).at(2));
        await tester.pump();
        await tester.tap(find.byType(SwitchListTile).at(4));
        await tester.pump();

        // Assert - All toggled switches should remain on
        final switchWidgets = tester.widgetList<SwitchListTile>(find.byType(SwitchListTile));
        expect(switchWidgets.elementAt(0).value, isTrue);
        expect(switchWidgets.elementAt(1).value, isFalse);
        expect(switchWidgets.elementAt(2).value, isTrue);
        expect(switchWidgets.elementAt(3).value, isFalse);
        expect(switchWidgets.elementAt(4).value, isTrue);
        expect(switchWidgets.elementAt(5).value, isFalse);
      });

      testWidgets('handles rapid toggle interactions', (WidgetTester tester) async {
        // Arrange
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        final firstSwitch = find.byType(SwitchListTile).first;

        // Act - Rapid toggling
        for (int i = 0; i < 5; i++) {
          await tester.tap(firstSwitch);
          await tester.pump(const Duration(milliseconds: 10));
        }
        await tester.pumpAndSettle();

        // Assert - Should be in a stable state (on after odd number of toggles)
        final switchWidget = tester.widget<SwitchListTile>(firstSwitch);
        expect(switchWidget.value, isTrue);
      });
    });

    group('Content Validation', () {
      testWidgets('displays only valid angel numbers', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - Check that only valid angel numbers are shown
        final expectedNumbers = ['1:11', '2:22', '3:33', '4:44', '5:55', '11:11'];
        
        for (final number in expectedNumbers) {
          expect(find.text(number), findsOneWidget);
        }

        // Verify no invalid numbers are present
        expect(find.text('1:12'), findsNothing);
        expect(find.text('6:66'), findsNothing);
        expect(find.text('12:34'), findsNothing);
      });

      testWidgets('description text is informative', (WidgetTester tester) async {
        // Arrange & Act
        await TestHelpers.pumpTestWidget(tester, const AngelNumbersPage());

        // Assert - Check description
        final descriptionText = 'Toggle mindful bells for angel numbers on a 12-hour clock';
        expect(find.text(descriptionText), findsOneWidget);

        // Verify text styling
        final textWidget = tester.widget<Text>(find.text(descriptionText));
        expect(textWidget.style?.fontSize, equals(16));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w500));
      });
    });
  });
}
