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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    );
  }
}
