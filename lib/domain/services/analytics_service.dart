import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyticsService {
  static const String apiUrl = 'https://a.aisoft.app/api/analytics';

  static Future<void> sendEvent(
      String eventType, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/event'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'eventType': eventType,
          'data': data,
        }),
      );

      if (response.statusCode != 200) {
        log('Ошибка отправки события: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка отправки события: $e');
    }
  }
}

