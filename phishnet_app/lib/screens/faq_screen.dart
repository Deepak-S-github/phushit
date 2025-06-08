import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildFAQItem(
              question: 'What is phishing?',
              answer: 'Phishing is a type of cyber attack where criminals impersonate legitimate organizations to steal sensitive information like passwords, credit card numbers, or personal data.',
            ),
            
            _buildFAQItem(
              question: 'How does the URL scanner work?',
              answer: 'Our scanner analyzes URLs using advanced algorithms to detect suspicious patterns, domain reputation, and known phishing indicators to determine if a link is safe.',
            ),
            
            _buildFAQItem(
              question: 'Is my data safe?',
              answer: 'Yes, we take privacy seriously. URLs are analyzed securely and we don\'t store personal information. Scan history is kept locally on your device.',
            ),
            
            _buildFAQItem(
              question: 'What should I do if a URL is flagged as phishing?',
              answer: 'Do not click the link or enter any information. Report the phishing attempt to the relevant authorities and delete the message containing the suspicious link.',
            ),
            
            _buildFAQItem(
              question: 'How accurate is the detection?',
              answer: 'Our AI-powered detection system has a high accuracy rate, but no system is 100% perfect. Always use caution and trust your instincts when dealing with suspicious links.',
            ),
            
            _buildFAQItem(
              question: 'Can I scan emails?',
              answer: 'Yes, you can paste email content or forward suspicious emails to our scanner. We\'ll analyze the content for phishing indicators.',
            ),
            
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.help_center,
                    size: 48,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Still have questions?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Contact our support team for help',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Contact support functionality
                    },
                    child: const Text('Contact Support'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        backgroundColor: AppTheme.secondaryColor,
        collapsedBackgroundColor: AppTheme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}