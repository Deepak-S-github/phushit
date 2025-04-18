import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> fakeNews = [
      "🔴 200K emails leaked in PayPal scam - 1 hr ago",
      "⚠️ Fake loan apps spike in India - 2 hrs ago",
      "🔐 Google blocks 350K phishing pages - Today",
      "🚫 Phishing gang busted in Delhi - Yesterday",
      "🛑 WhatsApp OTP scam rising in TN - Today",
    ];

    final List<String> recentScans = [
      "✅ google.com - Safe",
      "⚠️ bit.ly/pay-confirm - Phishing",
      "✅ github.com - Safe",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History & News"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🕓 Recent Scans",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...recentScans.map((scan) => ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(scan),
                )),
            const SizedBox(height: 25),
            const Text(
              "📰 Latest Cyber Security News",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: fakeNews.length,
                itemBuilder: (context, index) => Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange),
                    title: Text(fakeNews[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
