import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:now/core/theme/tao_theme.dart';
import 'package:now/splash_screen.dart';

import 'package:now/features/settings/providers/settings_provider.dart';
import 'package:now/providers/theme_provider.dart';

import 'firebase_options.dart';

/// The main entry point of the application.
/// Initializes the Flutter binding and runs the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization skipped or already initialized: $e');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const NOWApp(),
    ),
  );
}

/// The root widget of the application.
/// It sets up the MaterialApp and the theme.
class NOWApp extends StatelessWidget {
  /// Creates a new instance of the NOWApp.
  const NOWApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'NOW',
      themeMode: themeProvider.darkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: TaoTheme.light(),
      darkTheme: TaoTheme.dark(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: !kReleaseMode,
      builder: (context, child) {
        if (!kIsWeb || child == null) {
          return child ?? const SizedBox.shrink();
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 540) {
              return child;
            }
            final p = TaoPalette.of(context);
            return ColoredBox(
              color: p.stoneWashEnd,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 440,
                    maxHeight: 920,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: p.peekingCardBorder, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 36,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
