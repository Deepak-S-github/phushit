import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.62.46:5000/predict'; // <-- replace X.X with your PC's IP

  static Future<String> scanUrl(String url) async {
    print('🚀 Sending URL to server: $url');

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"url": url}),
      );

      print('📥 Status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['result'];
      } else {
        return "❌ Error: Invalid response from server";
      }
    } catch (e) {
      print('❗ Connection failed: $e');
      return "⚠️ Failed to connect to server";
    }
  }
}
