import 'package:flutter/material.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Scan Result"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.cyanAccent),
            onPressed: () {
              // TODO: Navigate to Scan History
            },
          ),
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
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: isPhishing
                      ? [Colors.redAccent.shade200, Colors.red.shade900]
                      : [Colors.greenAccent, Colors.green],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isPhishing ? Colors.redAccent : Colors.greenAccent,
                    blurRadius: 30,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPhishing ? Icons.warning_amber : Icons.verified,
                    size: 60,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    url,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPhishing
                        ? "⚠️ Phishing Site Detected"
                        : "✅ Safe Website",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassMorphismButton(
                    text: "Go to Scan History",
                    onPressed: () {
                      // TODO: Navigate to Scan History screen
                    },
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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: const Color.fromARGB(255, 65, 14, 75).withOpacity(0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: const Color.fromARGB(255, 161, 20, 236).withOpacity(0.2),
      ),
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromARGB(255, 68, 181, 201).withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 245, 53, 158),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
