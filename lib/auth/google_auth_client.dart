import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spider/logger/app_logger.dart';

class GoogleAuthClient {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;

  Future<void> init(String clientId) async {
    await _googleSignIn.initialize(serverClientId: clientId);
  }

   Future<String?> signInAndGetIdToken() async {
    try {
      final account = await signIn();
      if (account == null) return null;

      final auth = account.authentication;
      return auth.idToken; 
    } catch (e) {
      AppLogger.showDebug('Google SignIn idToken error: $e');
      return null;
    }
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.authenticate(
        scopeHint: [
          "email",
          "https://www.googleapis.com/auth/photospicker.mediaitems.readonly",
        ],
      );
      _currentUser = account;
      return account;
    } catch (e) {
      AppLogger.showDebug('Google SignIn authenticate error: $e');
      
      return null;
    }
  }


   Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

}
