import 'package:flutter/material.dart';
import 'package:phishnet_app/services/api_service.dart';
import 'package:phishnet_app/screens/scan_history.dart';
import 'package:phishnet_app/screens/result_screen.dart' hide ScanHistoryScreen;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool isLoading = false;

  Future<void> scanUrl() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    final response = await ApiService.scanUrl(_urlController.text);
    await saveToHistory(_urlController.text, response);

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          url: _urlController.text,
          result: response,
        ),
      ),
    );
  }

  Future<void> saveToHistory(String url, String result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList('scanHistory') ?? [];

    final newItem = json.encode({'url': url, 'result': result});
    history.insert(0, newItem); // Add newest first

    if (history.length > 50) history.removeLast(); // Optional: Limit history

    await prefs.setStringList('scanHistory', history);
  }

  Widget glowingContainer({required Widget child, Color color = Colors.cyan, double blur = 30}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: blur,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("PhishNet"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.toggleTheme,
            activeColor: Colors.cyanAccent,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF000000), Color(0xFF0f0f0f)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  glowingContainer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.cyanAccent.withOpacity(0.6)),
                      ),
                      child: TextField(
                        controller: _urlController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.link, color: Colors.cyanAccent),
                          hintText: "Enter website URL",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  glowingContainer(
                    color: Colors.purpleAccent,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : scanUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Scan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  glowingContainer(
                    color: Colors.orangeAccent,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
                        );
                      },
                      icon: const Icon(Icons.history, color: Colors.black),
                      label: const Text(
                        "View Scan History",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
