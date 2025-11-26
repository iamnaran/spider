import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spider/logger/app_logger.dart';

class PhotosAPIService {
  final String baseUrl;

  PhotosAPIService(this.baseUrl);

   Future<Map<String, dynamic>?> createSession(
    String accessToken, {
    int maxItems = 10,
  }) async {
    final url = Uri.parse("$baseUrl/sessions");
    final headers = {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "pickingConfig": {"maxItemCount": maxItems.toString()},
    });

    try {
      final res = await http.post(url, headers: headers, body: body);
      AppLogger.showDebug(
        'Create session response: ${res.statusCode} ${res.body}',
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      AppLogger.showDebug('Failed to create session: ${res.body}');
      return null;
    } catch (e) {
      AppLogger.showDebug('Create session error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSession(
    String sessionId,
    String accessToken,
  ) async {
    final url = Uri.parse("$baseUrl/sessions/$sessionId");

    try {
      final res = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      AppLogger.showDebug('Failed to get session: ${res.body}');
      return null;
    } catch (e) {
      AppLogger.showDebug('Get session error: $e');
      return null;
    }
  }

  Future<List<dynamic>?> getMediaItems(
    String sessionId,
    String accessToken, {
    int pageSize = 50,
    String? pageToken,
  }) async {
    final queryParams = {
      'sessionId': sessionId,
      'pageSize': pageSize.toString(),
      if (pageToken != null) 'pageToken': pageToken,
    };

    final uri = Uri.https(
      'photospicker.googleapis.com',
      '/v1/mediaItems',
      queryParams,
    );

    try {
      final res = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['mediaItems'] as List<dynamic>?;
      } else {
        AppLogger.showDebug('Failed to get mediaItems: ${res.body}');
        return null;
      }
    } catch (e) {
      AppLogger.showDebug('Get mediaItems error: $e');
      return null;
    }
  }

  Future<void> deleteSession(String sessionId, String accessToken) async {
    final url = Uri.parse("$baseUrl/sessions/$sessionId");
    try {
      final res = await http.delete(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      AppLogger.showDebug('Delete session response: ${res.statusCode}');
    } catch (e) {
      AppLogger.showDebug('Delete session error: $e');
    }
  }
}
