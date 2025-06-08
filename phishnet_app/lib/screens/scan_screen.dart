import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isScanning = false;
  String? _scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan URL'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter URL to scan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We\'ll check if the URL is safe or potentially phishing',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // URL Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Enter URL (e.g., https://example.com)',
                        hintStyle: TextStyle(color: AppTheme.textSecondary),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.link,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isScanning ? null : _scanUrl,
                        child: _isScanning
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Scanning...'),
                                ],
                              )
                            : const Text('Scan URL'),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Scan Result
              if (_scanResult != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _scanResult == 'safe' 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _scanResult == 'safe' 
                          ? Colors.green
                          : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _scanResult == 'safe' 
                            ? Icons.check_circle
                            : Icons.warning,
                        size: 48,
                        color: _scanResult == 'safe' 
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _scanResult == 'safe' 
                            ? 'URL is Safe'
                            : 'Potential Phishing Detected',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _scanResult == 'safe' 
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _scanResult == 'safe'
                            ? 'This URL appears to be legitimate and safe to visit.'
                            : 'This URL may be attempting to steal your personal information.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Tips Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppTheme.accentColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Safety Tips',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Always check the URL spelling\n'
                      '• Look for HTTPS encryption\n'
                      '• Be cautious with shortened URLs\n'
                      '• Verify sender authenticity',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scanUrl() async {
    if (_urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    setState(() {
      _isScanning = true;
      _scanResult = null;
    });

    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock result - in real app, this would call an API
    final isPhishing = _urlController.text.toLowerCase().contains('phish') ||
                      _urlController.text.toLowerCase().contains('fake');

    setState(() {
      _isScanning = false;
      _scanResult = isPhishing ? 'phishing' : 'safe';
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}