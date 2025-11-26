import 'package:spider/logger/app_logger.dart';

import 'photos_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class GooglePhotosPeeker {
  final String backendBaseUrl;
  late final PhotosAPIService photosAPIService;

  GooglePhotosPeeker({required this.backendBaseUrl}) {
    photosAPIService = PhotosAPIService(backendBaseUrl);
  }

  Future<List<dynamic>?> pickPhotos({
    required String accessToken,
    int maxItems = 10,
  }) async {
    final session = await photosAPIService.createSession(
      accessToken,
      maxItems: maxItems,
    );
    if (session == null) return null;

    final pickerUri = session['pickerUri'] as String?;
    final sessionId = session['id'] as String?;
    if (pickerUri == null || sessionId == null) return null;

    AppLogger.showDebug('Session Created: $pickerUri : Session ID: $sessionId');

    await _openPicker(pickerUri);

    final completed = await _pollUntilMediaItemsSet(sessionId, accessToken);
    if (!completed) return null;

    // ✅ Use the correct API endpoint to get media items
    final mediaItems = await photosAPIService.getMediaItems(
      sessionId,
      accessToken,
    );
    // await photosAPIService.deleteSession(sessionId, accessToken);

    return mediaItems;
  }

  Future<void> _openPicker(String pickerUri) async {
    final uri = Uri.parse(pickerUri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      AppLogger.showDebug('Cannot launch picker URI: $pickerUri');
    }
  }

  Future<bool> _pollUntilMediaItemsSet(
    String sessionId,
    String accessToken, {
    int maxRetries = 15,
    int initialDelaySeconds = 1,
  }) async {
    int attempt = 0;
    int delaySeconds = initialDelaySeconds;

    while (attempt < maxRetries) {
      final session = await photosAPIService.getSession(sessionId, accessToken);
      AppLogger.showDebug('Polling attempt #$attempt: $session');

      if (session != null) {
        if (session['mediaItemsSet'] == true) {
          AppLogger.showDebug('Media items are ready.');
          return true;
        }
        if (session.containsKey('error')) {
          AppLogger.showDebug('Error polling session: ${session['error']}');
          return false;
        }
      }

      await Future.delayed(Duration(seconds: delaySeconds));
      delaySeconds = (delaySeconds * 2).clamp(1, 5); // exponential backoff
      attempt++;
    }

    AppLogger.showDebug('Polling session timed out.');
    return false;
  }

}
