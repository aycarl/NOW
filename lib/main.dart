import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'carousel_home_page.dart';

void main() {
  runApp(const NOWApp());
}

class NOWApp extends StatelessWidget {
  const NOWApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOW',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CarouselHomePage(),
      debugShowCheckedModeBanner: !kReleaseMode,
    );
  }
}
