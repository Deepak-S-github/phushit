import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _historyEnabled = true;
  bool _notificationsEnabled = true;
  bool _autoScanEnabled = false;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Security Section
            _buildSectionTitle('Security'),
            _buildSettingItem(
              icon: Icons.history,
              title: 'History',
              subtitle: 'Save scan history',
              value: _historyEnabled,
              onChanged: (value) {
                setState(() {
                  _historyEnabled = value;
                });
              },
            ),
            _buildSettingItem(
              icon: Icons.auto_fix_high,
              title: 'Auto Scan',
              subtitle: 'Automatically scan URLs from clipboard',
              value: _autoScanEnabled,
              onChanged: (value) {
                setState(() {
                  _autoScanEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildSectionTitle('Notifications'),
            _buildSettingItem(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive security alerts',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Appearance Section
            _buildSectionTitle('Appearance'),
            _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Support Section
            _buildSectionTitle('Support'),
            _buildNavigationItem(
              icon: Icons.help_outline,
              title: 'FAQ',
              subtitle: 'Frequently asked questions',
              onTap: () {
                Navigator.pushNamed(context, '/faq');
              },
            ),
            _buildNavigationItem(
              icon: Icons.contact_support,
              title: 'Contact Us',
              subtitle: 'Get help and support',
              onTap: () {
                // Contact functionality
              },
            ),
            _buildNavigationItem(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {
                _showAboutDialog();
              },
            ),
            
            const SizedBox(height: 32),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppTheme.accentColor,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.accentColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: AppTheme.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(
          icon,
          color: AppTheme.accentColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryColor,
        title: const Text(
          'About PhishNet.AI',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'PhishNet.AI v1.0.0\n\nAdvanced phishing detection app to keep you safe from malicious links and emails.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}