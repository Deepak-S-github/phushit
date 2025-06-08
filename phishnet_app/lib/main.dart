import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/faq_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PhishingDetectorApp());
}

class PhishingDetectorApp extends StatelessWidget {
  const PhishingDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phishing Detector',
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/scan': (context) => const ScanScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/faq': (context) => const FAQScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}