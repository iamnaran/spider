import 'package:spider/logger/app_logger.dart';

import 'google_photos_peeker_service.dart';
import 'package:url_launcher/url_launcher.dart';

class GooglePhotosPeeker {
  final String backendBaseUrl;
  late final GooglePhotosPeekerService pickerService;

  GooglePhotosPeeker({required this.backendBaseUrl}) {
    pickerService = GooglePhotosPeekerService(backendBaseUrl);
  }

  Future<List<dynamic>?> pick({required String accessToken}) async {
    final session = await pickerService.createSession(accessToken);

    AppLogger.showDebug('Session Null');
    
    if (session == null) return null;

    final pickerUri = session["pickerUri"];
    final sessionId = session["id"];

    AppLogger.showDebug('Session Created: $pickerUri : Session ID: $sessionId');

    await launchUrl(Uri.parse(pickerUri), mode: LaunchMode.platformDefault);

    return await _pollForResult(sessionId, accessToken);
  }

  Future<List<dynamic>?> _pollForResult(
    String sessionId,
    String accessToken,
  ) async {

    const maxRetries = 60; 
    int retries = 0;

    while (retries < maxRetries) {
      final result = await pickerService.pollSession(sessionId, accessToken);

      if (result != null) {
        if (result["mediaItemsSet"] == true) return result["mediaItems"];
        if (result.containsKey('error')) {
          AppLogger.showDebug('Error polling session: ${result['error']}');
          return null;
        }
      }

      retries++;
      await Future.delayed(const Duration(seconds: 1));
    }

    AppLogger.showDebug('Polling session timed out.');
    return null;
  }
}
