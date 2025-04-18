import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History")),
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
