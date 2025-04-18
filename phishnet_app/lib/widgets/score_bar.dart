 
import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final String result;
  const ScoreBar({required this.result, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isPhishing = result == "Phishing";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      height: 25,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isPhishing ? Colors.red[300] : Colors.green[300],
      ),
      child: Center(
        child: Text(
          isPhishing ? "⚠️ High Risk" : "✅ Safe to Visit",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
