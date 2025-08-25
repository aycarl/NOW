import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:now/theme_provider.dart';
import 'package:now/settings_provider.dart';

/// Test helpers for the NOW app
class TestHelpers {
  /// Creates a MaterialApp wrapper for testing widgets with providers
  static Widget createTestApp({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        home: child,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }

  /// Creates a MaterialApp wrapper with navigation for testing
  static Widget createTestAppWithNavigation({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        home: child,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }

  /// Pumps a widget with the default test app wrapper
  static Future<void> pumpTestWidget(
    WidgetTester tester,
    Widget widget, {
    Duration? duration,
  }) async {
    await tester.pumpWidget(createTestApp(child: widget));
    if (duration != null) {
      await tester.pump(duration);
    } else {
      await tester.pumpAndSettle();
    }
  }

  /// Common expectations for Material Design components
  static void expectMaterialDesignCompliance(WidgetTester tester) {
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
  }

  /// Verifies that a widget has proper accessibility
  static void expectAccessibilityCompliance(WidgetTester tester) {
    // Check for semantic labels where appropriate
    final semantics = tester.getSemantics(find.byType(Semantics).first);
    expect(semantics, isNotNull);
  }

  /// Helper to verify icon button functionality
  static Future<void> verifyIconButtonInteraction(
    WidgetTester tester,
    IconData iconData, {
    required VoidCallback onPressed,
  }) async {
    final iconButton = find.byIcon(iconData);
    expect(iconButton, findsAtLeastNWidgets(1));
    
    await tester.tap(iconButton.first);
    await tester.pump();
  }

  /// Helper to verify text input functionality
  static Future<void> verifyTextInput(
    WidgetTester tester,
    String labelText,
    String testValue,
  ) async {
    final textField = find.widgetWithText(TextField, labelText);
    expect(textField, findsOneWidget);
    
    await tester.enterText(textField, testValue);
    await tester.pump();
    
    expect(find.text(testValue), findsOneWidget);
  }

  /// Helper to verify ListTile structure and interaction
  static void verifyListTileStructure(
    WidgetTester tester, {
    required String titleText,
    String? subtitleText,
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) {
    expect(find.text(titleText), findsAtLeastNWidgets(1));
    
    if (subtitleText != null) {
      expect(find.text(subtitleText), findsAtLeastNWidgets(1));
    }
    
    if (leadingIcon != null) {
      expect(find.byIcon(leadingIcon), findsAtLeastNWidgets(1));
    }
    
    if (trailingIcon != null) {
      expect(find.byIcon(trailingIcon), findsAtLeastNWidgets(1));
    }
  }

  /// Helper to test dialog opening and closing
  static Future<void> verifyDialogInteraction(
    WidgetTester tester, {
    required Finder triggerFinder,
    required String dialogTitle,
    bool shouldClose = true,
  }) async {
    // Verify dialog doesn't exist initially
    expect(find.text(dialogTitle), findsNothing);
    
    // Tap trigger to open dialog
    await tester.tap(triggerFinder);
    await tester.pumpAndSettle();
    
    // Verify dialog opened
    expect(find.text(dialogTitle), findsOneWidget);
    
    if (shouldClose) {
      // Close dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      
      // Verify dialog closed
      expect(find.text(dialogTitle), findsNothing);
    }
  }

  /// Creates mock data for testing
  static List<Map<String, String>> createMockBells() {
    return [
      {'time': '07:00 AM', 'label': 'Test Bell 1', 'sound': 'default'},
      {'time': '12:00 PM', 'label': 'Test Bell 2', 'sound': 'alarm'},
    ];
  }

  /// Verifies theme consistency across the app
  static void verifyThemeConsistency(WidgetTester tester) {
    final theme = Theme.of(tester.element(find.byType(MaterialApp).first));
    expect(theme.colorScheme.primary, equals(Colors.deepPurple));
    expect(theme.useMaterial3, isTrue);
  }
}

/// Extension methods for common test operations
extension TestWidgetTesterExtension on WidgetTester {
  /// Pumps widget and settles with custom duration
  Future<void> pumpAndSettleWithDuration([Duration duration = const Duration(milliseconds: 100)]) async {
    await pump(duration);
    await pumpAndSettle();
  }
  
  /// Finds widget by text content more reliably
  Finder findTextContaining(String text) {
    return find.byWidgetPredicate((widget) => 
      widget is Text && widget.data != null && widget.data!.contains(text));
  }
}
