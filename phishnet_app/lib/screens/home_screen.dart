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
  String errorMessage = '';

  bool isValidURL(String url) {
    final pattern = r'^(https?:\/\/)[^\s/$.?#].[^\s]*$';
    final regex = RegExp(pattern, caseSensitive: false);
    return regex.hasMatch(url.trim());
  }

  Future<void> scanUrl() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a URL.';
      });
      return;
    }

    if (!isValidURL(url)) {
      showInvalidUrlDialog();
      return;
    }

    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    FocusScope.of(context).unfocus();

    final response = await ApiService.scanUrl(url);
    await saveToHistory(url, response);

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          url: _urlController.text,
          result: response,
          isDarkMode: widget.isDarkMode,
          toggleTheme: widget.toggleTheme,
        ),
      ),
    );
  }

  void showInvalidUrlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            "⚠ Invalid URL",
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please enter a full URL like:\nhttps://gov.in/",
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 10),
              Text(
                "💡 Tip: Copy the full website URL from your browser (Chrome/Google) to ensure accuracy.",
                style: TextStyle(color: Colors.cyanAccent),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("OK", style: TextStyle(color: Colors.cyanAccent)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveToHistory(String url, String result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList('scanHistory') ?? [];

    final newItem = json.encode({'url': url, 'result': result});
    history.insert(0, newItem);

    if (history.length > 50) history.removeLast();

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
                          errorText: errorMessage.isNotEmpty ? errorMessage : null,
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