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
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        expect(find.text('N:OW'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('donations button shows modal', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        await tester.tap(find.byIcon(Icons.favorite_border));
        await tester.pumpAndSettle();

        expect(find.text('Donations - Coming Soon!'), findsOneWidget);

        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();
      });

      testWidgets('settings button navigates to settings page', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();

        expect(find.text('Settings'), findsOneWidget);
      });
    });

    group('Stacked Cards & Tao Sanctuary Structure', () {
      testWidgets('renders stacked cards container and both feature pages', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(AnimatedPositioned), findsNWidgets(2));
        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
      });

      testWidgets('displays Whisper Capsule and opens Session Attunement sheet on tap', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        final whisperCapsule = find.byKey(const Key('whisper_capsule_button'));
        expect(whisperCapsule, findsOneWidget);

        await tester.tap(whisperCapsule);
        await tester.pumpAndSettle();

        expect(find.text('SESSION ATTUNEMENT'), findsOneWidget);
        expect(find.text('DURATION'), findsOneWidget);
        expect(find.text('PREPARATION BREATH'), findsOneWidget);
        expect(find.text('BELL RESONANCE'), findsOneWidget);
      });

      testWidgets('tapping Breathing Orb starts countdown and dissolves surrounding chrome', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        final breathingOrb = find.byKey(const Key('breathing_orb_button'));
        expect(breathingOrb, findsOneWidget);

        await tester.tap(breathingOrb);
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('END STILLNESS'), findsOneWidget);

        // Stop session to clean up periodic timer
        await tester.tap(find.text('END STILLNESS'));
        await tester.pumpAndSettle();
      });
    });

    group('Page Toggle Functionality', () {
      testWidgets('meditation timer and mindful bells show toggle buttons', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        expect(find.text('Meditation Timer'), findsAtLeastNWidgets(1));
        expect(find.text('Mindful Bells'), findsAtLeastNWidgets(1));

        final toggleButtons = find.byType(IconButton).evaluate().where((element) {
          final widget = element.widget as IconButton;
          final icon = widget.icon;
          if (icon is Icon) {
            return icon.icon == Icons.remove || icon.icon == Icons.add;
          }
          return false;
        });
        expect(toggleButtons.isNotEmpty, isTrue);
      });

      testWidgets('tapping toggle button transitions between stacked cards', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());

        final toggleButton = find.byIcon(Icons.remove);
        expect(toggleButton, findsOneWidget);

        await tester.tap(toggleButton);
        await tester.pumpAndSettle();

        expect(find.byType(MeditationTimerPage), findsOneWidget);
        expect(find.byType(MindfulBellsPage), findsOneWidget);
      });
    });

    group('Layout and Responsiveness', () {
      testWidgets('layout adapts to different screen sizes', (WidgetTester tester) async {
        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        expect(find.byType(AnimatedPositioned), findsNWidgets(2));

        tester.view.physicalSize = const Size(360, 720);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());
        addTearDown(() => tester.view.resetDevicePixelRatio());

        await TestHelpers.pumpTestWidget(tester, const CarouselHomePage());
        expect(find.byType(AnimatedPositioned), findsNWidgets(2));
        expect(find.text('N:OW'), findsOneWidget);
      });
    });
  });
}
