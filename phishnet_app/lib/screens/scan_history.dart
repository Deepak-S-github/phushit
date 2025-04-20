import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'home_screen.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  List<Map<String, String>> _history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historyData = prefs.getStringList('scanHistory');

    if (historyData != null) {
      setState(() {
        _history = historyData.map((e) => Map<String, String>.from(json.decode(e))).toList();
      });
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('scanHistory');
    setState(() {
      _history.clear();
    });
  }

  void showClearConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Clear All History"),
        content: const Text("Are you sure you want to delete all scan history?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Clear"),
            onPressed: () {
              Navigator.pop(context);
              clearHistory();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(
                    toggleTheme: (bool isDarkMode) {
                      // Provide a valid function or handle the toggle logic here
                    },
                    isDarkMode: false,
                  ),
                ),
                (route) => false,
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') showClearConfirmation();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear History'),
              ),
            ],
          ),
        ],
      ),
      body: _history.isEmpty
          ? const Center(child: Text("No scan history yet."))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return ListTile(
                  leading: Icon(
                    item['result'] == 'Phishing'
                        ? Icons.warning_amber
                        : Icons.verified_user,
                    color: item['result'] == 'Phishing' ? Colors.red : Colors.green,
                  ),
                  title: Text(item['url']!),
                  subtitle: Text("Result: ${item['result']}"),
                );
              },
            ),
    );
  }
}
