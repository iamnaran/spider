import 'package:google_sign_in/google_sign_in.dart';
import 'package:spider/logger/app_logger.dart';

class GooglePhotosAuth {
  final String serverClientId;

  final List<String> _scopes = [
    'https://www.googleapis.com/auth/photoslibrary.appendonly',
    'https://www.googleapis.com/auth/photoslibrary.readonly',
    'https://www.googleapis.com/auth/photoslibrary',
  ];

  GooglePhotosAuth({required this.serverClientId});

  Future<String?> signInAndGetAccessToken() async {
    try {
      await GoogleSignIn.instance.initialize(serverClientId: serverClientId);

      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: _scopes,
      );

      final headers = await account.authorizationClient.authorizationHeaders(
        _scopes,
        promptIfNecessary: true,
      );
      final accessToken = headers?['Authorization']?.split(' ').last;
      if (accessToken == null) {
        AppLogger.showDebug('Failed to retrieve access token.');
      } else {
        AppLogger.showDebug('Google Photos Access Token: $accessToken');
      }
      return accessToken;
    } on GoogleSignInException catch (e) {
      AppLogger.showDebug(
        'Google Sign-In Exception: ${e.code} - ${e.description}',
      );
      return null;
    } catch (e) {
      AppLogger.showDebug('Unknown error: $e');
      return null;
    }
  }

  /// Sign out from Google
  Future<void> signOut() => GoogleSignIn.instance.signOut();
}
