import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/scan_history.dart';

void main() {
  runApp(const PhishNetApp());
}

class PhishNetApp extends StatefulWidget {
  const PhishNetApp({super.key});

  @override
  State<PhishNetApp> createState() => _PhishNetAppState();
}

class _PhishNetAppState extends State<PhishNetApp> {
  bool isDarkMode = true;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor:
          isDarkMode ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
      fontFamily: 'Poppins',
      primaryColor: Colors.cyanAccent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.cyanAccent,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PhishNet 🔐',
      theme: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(
          bodyColor: isDarkMode ? Colors.white : Colors.black,
          displayColor: isDarkMode ? Colors.white : Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: isDarkMode ? Colors.cyanAccent : Colors.black),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.cyanAccent : Colors.black,
          ),
        ),
      ),
      home: HomeScreen(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
