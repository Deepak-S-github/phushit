import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PHISHNET.AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Stay protected from phishing attacks',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.link_outlined,
                      title: 'Scan URL',
                      subtitle: 'Check web links',
                      onTap: () => Navigator.pushNamed(context, '/scan'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.email_outlined,
                      title: 'Scan Email',
                      subtitle: 'Check emails',
                      onTap: () => Navigator.pushNamed(context, '/scan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Activity
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildActivityItem(
                      title: 'Website scan completed',
                      subtitle: 'google.com - Safe',
                      time: '${index + 1}h ago',
                      isPhishing: index == 2,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation based on index
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/scan');
              break;
            case 2:
              Navigator.pushNamed(context, '/history');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required bool isPhishing,
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPhishing 
                ? Colors.red.withOpacity(0.2) 
                : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isPhishing ? Icons.warning : Icons.check_circle,
              color: isPhishing ? Colors.red : Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
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
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}