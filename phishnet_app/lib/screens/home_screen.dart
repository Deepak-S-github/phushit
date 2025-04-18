import 'package:flutter/material.dart';
import 'package:phishnet_app/services/api_service.dart';
import 'package:phishnet_app/screens/scan_history.dart';
import 'package:phishnet_app/screens/result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool isLoading = false;
  String errorMessage = ''; // To store the error message for empty field

  Future<void> scanUrl() async {
    if (_urlController.text.isEmpty) {
      // Set the error message if the field is empty
      setState(() {
        errorMessage = 'Please enter a URL.';
      });
      return;
    }

    // Reset error message if the input is valid
    setState(() {
      errorMessage = '';
    });

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
            decoration: BoxDecoration(
              gradient: widget.isDarkMode
                  ? const LinearGradient(
                      colors: [Color(0xFF121212), Color(0xFF212121)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Colors.white, Colors.grey],
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
                  const Text(
                    'Enter a website URL to check for phishing threats:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  glowingContainer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? Colors.black.withOpacity(0.6)
                            : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: widget.isDarkMode
                              ? Colors.cyanAccent.withOpacity(0.8)
                              : Colors.blue.withOpacity(0.6),
                        ),
                      ),
                      child: TextField(
                        controller: _urlController,
                        style: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.link,
                            color: widget.isDarkMode ? Colors.cyanAccent : Colors.blue,
                          ),
                          hintText: "Enter website URL",
                          hintStyle: TextStyle(
                            color: widget.isDarkMode ? Colors.white70 : Colors.black45,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          errorText: errorMessage.isNotEmpty ? errorMessage : null, // Show error if empty
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  glowingContainer(
                    color: widget.isDarkMode ? Colors.purpleAccent : Colors.blueAccent,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : scanUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isDarkMode
                            ? Colors.purpleAccent
                            : Colors.blueAccent,
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
                    color: widget.isDarkMode ? Colors.orangeAccent : Colors.orange,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
                        );
                      },
                      icon: Icon(
                        Icons.history,
                        color: widget.isDarkMode ? Colors.black : Colors.white,
                      ),
                      label: Text(
                        "View Scan History",
                        style: TextStyle(
                          color: widget.isDarkMode ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isDarkMode
                            ? Colors.orangeAccent
                            : Colors.orange,
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
