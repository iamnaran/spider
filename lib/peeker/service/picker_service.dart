import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spider/logger/app_logger.dart';

class PickerService {
  final String baseUrl;

  PickerService(this.baseUrl);

  Future<Map<String, dynamic>?> createSession(String idToken) async {
    final url = Uri.parse("$baseUrl/sessions");
    final headers = {"Authorization": "Bearer $idToken"};

    try {
      final res = await http.post(url, headers: headers);
      return _parseResponse(res);
    } catch (e) {
      AppLogger.showDebug('Create session error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> pollSession(String sessionId) async {
    final url = Uri.parse("$baseUrl/picker/poll?sessionId=$sessionId");

    try {
      final res = await http.get(url);
      return _parseResponse(res);
    } catch (e) {
      AppLogger.showDebug('Poll session error: $e');
      return null;
    }
  }

  Map<String, dynamic>? _parseResponse(http.Response res) {
    AppLogger.showDebug('Parsing Response $res.statusCode: ${res.body} ');

    if (res.statusCode == 200) {
      try {
        return jsonDecode(res.body) as Map<String, dynamic>;
      } catch (e) {
        AppLogger.showDebug('Parsing Response error: $e');
        return null;
      }
    }
    return null;
  }
}
