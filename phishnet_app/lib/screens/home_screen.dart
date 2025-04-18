import 'package:flutter/material.dart';
import 'package:phishnet_app/services/api_service.dart';
import 'package:phishnet_app/widgets/score_bar.dart';
import 'news_screen.dart';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  String? result;
  bool isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> scanUrl() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
      result = null;
    });

    final response = await ApiService.scanUrl(_urlController.text);

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      result = response;
      isLoading = false;
    });

    _fadeController.forward(from: 0); // Trigger animation
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("PhishNet 🔐"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.toggleTheme,
            activeColor: Colors.greenAccent,
          )
        ],
      ),
      body: Stack(
        children: [
          // 🌊 Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        labelText: "🔗 Enter website URL",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🚀 Scan Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 55,
                    width: isLoading ? 55 : double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : scanUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(isLoading ? 30 : 14),
                        ),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)
                          : const Text("🚨 Scan Now",
                              style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 📰 News Button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.newspaper_outlined),
                    label: const Text("Scan History & News"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // 🧠 Result Display
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: result != null
                        ? Column(
                            children: [
                              ScoreBar(result: result!),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: result == "Phishing"
                                      ? Colors.red.shade50
                                      : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: result == "Phishing"
                                        ? Colors.red
                                        : Colors.green,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      result == "Phishing"
                                          ? Icons.warning
                                          : Icons.verified,
                                      color: result == "Phishing"
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      result!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: result == "Phishing"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
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
