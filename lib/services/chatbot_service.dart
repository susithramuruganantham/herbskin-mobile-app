import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/chat_message.dart';

class ChatbotService {
  static Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.chatbotEndpoint}');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'reply': data['reply'] ?? 'Hello! How can I assist you with herbal skincare today?',
          'action': data['action'],
          'items': data['items'],
          'diagnosis': data['diagnosis'],
        };
      } else {
        return {
          'success': false,
          'reply': 'I am currently having trouble connecting to the herbal server. Please try again shortly.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'reply': 'Connection error. Please ensure the HERBSKIN HEAVEN backend server is running on port 5000.',
      };
    }
  }
}
