import 'package:flutter/material.dart';
import 'package:phishnet_app/screens/scan_history.dart';
import 'package:phishnet_app/screens/home_screen.dart'; // ⬅️ Import HomeScreen

class ResultScreen extends StatelessWidget {
  final String url;
  final String result;

  const ResultScreen({
    super.key,
    required this.url,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final isPhishing = result == "Phishing";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Result"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.cyanAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ScanHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // URL Box
            ResultBox(
              title: "Scanned URL",
              content: url,
              color: Colors.blueGrey.shade800,
            ),
            const SizedBox(height: 16),
            // Result Box
            ResultBox(
              title: "Result",
              content: isPhishing
                  ? "⚠️ Phishing Site Detected"
                  : "✅ Safe Website",
              color: isPhishing ? Colors.red.shade700 : Colors.green.shade700,
              icon: isPhishing ? Icons.warning_amber : Icons.verified,
            ),
            const SizedBox(height: 24),
            // Buttons
            GlassMorphismButton(
              text: "Go to Scan History",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScanHistoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            GlassMorphismButton(
              text: "Back to Home",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(
                      toggleTheme: (value) {}, // 🔧 Replace with actual function if needed
                      isDarkMode: true,        // ✅ Set based on your app theme
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ResultBox extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final IconData? icon;

  const ResultBox({
    super.key,
    required this.title,
    required this.content,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha((0.2 * 255).toInt()),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    )),
                const SizedBox(height: 4),
                Text(content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GlassMorphismButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlassMorphismButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withAlpha((0.1 * 255).toInt()),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: Colors.pinkAccent.withAlpha((0.4 * 255).toInt()),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
