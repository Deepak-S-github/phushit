import 'package:flutter/material.dart';
import 'dart:async';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PhishNetApp());
}

class PhishNetApp extends StatefulWidget {
  const PhishNetApp({super.key});

  @override
  State<PhishNetApp> createState() => _PhishNetAppState();
}

class _PhishNetAppState extends State<PhishNetApp> with TickerProviderStateMixin {
  bool isDarkMode = false;
  bool showSplash = true;
  double splashOpacity = 1.0;

  late AnimationController _fadeController;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  void initState() {
    super.initState();

    // Delay and then fade out splash
    Timer(const Duration(seconds: 8), () {
      setState(() {
        splashOpacity = 0.0;
      });
      // Delay removing the widget after fade out
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          showSplash = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
      fontFamily: 'Poppins',
      primaryColor: Colors.cyanAccent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyanAccent,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        bodyMedium: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        bodySmall: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        headlineLarge: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        headlineMedium: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.cyanAccent : Colors.black),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.cyanAccent : Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.cyanAccent : Colors.blueAccent,
          foregroundColor: isDarkMode ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhishNet 🔐',
      theme: baseTheme,
      home: Stack(
        children: [
          HomeScreen(
            toggleTheme: toggleTheme,
            isDarkMode: isDarkMode,
          ),
          if (showSplash)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: splashOpacity,
              child: const SplashScreen(),
            ),
        ],
      ),
    );
  }
}
