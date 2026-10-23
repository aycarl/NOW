import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:now/core/widgets/zen_sound_symbol.dart';
import 'package:now/features/mindful_bells/pages/mindful_bells_page.dart';
import 'package:now/features/angel_numbers/angel_numbers_page.dart';
import 'package:now/features/mindful_bells/widgets/bell_form_dialog.dart';
import 'package:now/features/settings/providers/settings_provider.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('MindfulBellsPage Widget Tests', () {
    group('Initial State', () {
      testWidgets('renders with default bells and sacred sound symbols', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        expect(find.text('07:00 AM'), findsOneWidget);
        expect(find.text('08:30 AM'), findsOneWidget);
        expect(find.text('Morning Bell'), findsOneWidget);
        expect(find.text('Work Bell'), findsOneWidget);
        expect(find.byType(ZenSoundSymbol), findsNWidgets(2));
      });

      testWidgets('displays header correctly', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        expect(find.text('Mindful Bells'), findsOneWidget);
        final headerText = tester.widget<Text>(find.text('Mindful Bells'));
        expect(headerText.style?.fontWeight, FontWeight.bold);
      });

      testWidgets('shows angel numbers navigation card when enabled in settings', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        final settingsProvider = Provider.of<SettingsProvider>(
          tester.element(find.byType(MindfulBellsPage)),
          listen: false,
        );
        settingsProvider.showAngelNumbers = true;
        await tester.pumpAndSettle();

        expect(find.text('Angel Numbers'), findsOneWidget);
        expect(find.byIcon(Icons.numbers), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      });

      testWidgets('displays floating action button', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
        expect(fab.tooltip, equals('Add Mindful Bell'));
      });
    });

    group('Bell List Display & Sacred Sound Symbols', () {
      testWidgets('bell list items display time, label, and edit icon', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        TestHelpers.verifyListTileStructure(
          tester,
          titleText: '07:00 AM',
          subtitleText: 'Morning Bell',
          trailingIcon: Icons.edit,
        );

        TestHelpers.verifyListTileStructure(
          tester,
          titleText: '08:30 AM',
          subtitleText: 'Work Bell',
          trailingIcon: Icons.edit,
        );
      });

      testWidgets('tapping ZenSoundSymbol cycles bell sound resonance', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        expect(find.textContaining('Sound: default'), findsNWidgets(2));

        await tester.tap(find.byType(ZenSoundSymbol).first);
        await tester.pumpAndSettle();

        expect(find.textContaining('Sound: singing_bowl'), findsOneWidget);
      });

      testWidgets('edit buttons open BellFormDialog', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        final editButtons = find.byIcon(Icons.edit);
        expect(editButtons, findsNWidgets(2));

        await tester.tap(editButtons.first);
        await tester.pumpAndSettle();

        expect(find.text('Edit Mindful Bell'), findsOneWidget);
        expect(find.byType(BellFormDialog), findsOneWidget);
      });
    });

    group('Angel Numbers Navigation', () {
      testWidgets('angel numbers card navigates to AngelNumbersPage when enabled', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        final settingsProvider = Provider.of<SettingsProvider>(
          tester.element(find.byType(MindfulBellsPage)),
          listen: false,
        );
        settingsProvider.showAngelNumbers = true;
        await tester.pumpAndSettle();

        await tester.tap(find.text('Angel Numbers'));
        await tester.pumpAndSettle();

        expect(find.byType(AngelNumbersPage), findsOneWidget);
      });
    });

    group('Add Bell Functionality', () {
      testWidgets('FAB opens add bell dialog and can be cancelled', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, MindfulBellsPage(onToggle: () {}));

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Add Mindful Bell'), findsOneWidget);
        expect(find.byType(BellFormDialog), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Add Mindful Bell'), findsNothing);
        expect(find.text('Mindful Bells'), findsOneWidget);
      });
    });
  });
}
