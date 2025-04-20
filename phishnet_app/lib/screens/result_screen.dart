import 'package:flutter/material.dart';
import 'package:phishnet_app/screens/scan_history.dart';
import 'package:phishnet_app/screens/home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String url;
  final String result;
  final bool isDarkMode;
  final Function(bool) toggleTheme;

  const ResultScreen({
    super.key,
    required this.url,
    required this.result,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideAnimations = List.generate(3, (i) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.2, 0.8, curve: Curves.easeOut),
        ),
      );
    });

    _fadeAnimations = List.generate(3, (i) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.2, 0.8, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String extractDomain(String url) {
    try {
      Uri uri = Uri.parse(url);
      if (uri.hasAuthority) return uri.host;
      return "Invalid URL";
    } catch (_) {
      return "Invalid URL";
    }
  }

  String shortDisplay(String url) {
    if (url.length <= 40) return url;
    return "${url.substring(0, 35)}...";
  }

  @override
  Widget build(BuildContext context) {
    final isPhishing = widget.result.toLowerCase().contains("phish");
    final domain = extractDomain(widget.url);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Result"),
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.blueGrey.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.cyanAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
              );
            },
          ),
          Switch(
            value: widget.isDarkMode,
            activeColor: Colors.cyanAccent,
            onChanged: widget.toggleTheme,
          ),
        ],
      ),
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBoxWrapper(
              animationOffset: _slideAnimations[0],
              fade: _fadeAnimations[0],
              child: ResultBox(
                title: "Scanned URL",
                content: shortDisplay(widget.url),
                color: Colors.blueGrey.shade800,
                isDark: widget.isDarkMode,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBoxWrapper(
              animationOffset: _slideAnimations[1],
              fade: _fadeAnimations[1],
              child: ResultBox(
                title: "Domain Name",
                content: domain,
                color: Colors.deepPurple.shade800,
                isDark: widget.isDarkMode,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedBoxWrapper(
              animationOffset: _slideAnimations[2],
              fade: _fadeAnimations[2],
              child: ResultBox(
                title: "Result",
                content: isPhishing
                    ? "⚠️ Phishing Site Detected"
                    : "✅ Safe Website",
                color: isPhishing ? Colors.red.shade700 : Colors.green.shade700,
                icon: isPhishing ? Icons.warning_amber : Icons.verified,
                isDark: widget.isDarkMode,
              ),
            ),
            const SizedBox(height: 24),
            GlassMorphismButton(
              text: "Go to Scan History",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            GlassMorphismButton(
              text: "Back to Home",
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedBoxWrapper extends StatelessWidget {
  final Widget child;
  final Animation<Offset> animationOffset;
  final Animation<double> fade;

  const AnimatedBoxWrapper({
    super.key,
    required this.child,
    required this.animationOffset,
    required this.fade,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([animationOffset, fade]),
      builder: (context, childWidget) {
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: animationOffset,
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }
}

class ResultBox extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final IconData? icon;
  final bool isDark;

  const ResultBox({
    super.key,
    required this.title,
    required this.content,
    required this.color,
    this.icon,
    required this.isDark,
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
            Icon(icon, color: isDark ? Colors.white : Colors.black),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
        backgroundColor: Colors.white.withOpacity(0.05),
        foregroundColor: Colors.cyanAccent,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: Colors.cyan.withOpacity(0.3),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
// Compare this snippet from phishnet_app/lib/screens/scan_history.dart:
// import 'package:flutter/material.dart';  