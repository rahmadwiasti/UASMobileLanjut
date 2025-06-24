import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EndemikDBApp());
}

class EndemikDBApp extends StatelessWidget {
  const EndemikDBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EndemikDB',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}