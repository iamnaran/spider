import 'package:flutter/material.dart';
import 'package:spider/const/app_constants.dart';
import 'package:spider/google/google_auth_client.dart';
import 'package:spider/logger/app_logger.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GoogleAuthClient _googleAuthClient = GoogleAuthClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in with Google'),
          onPressed: () async {
            await _googleAuthClient.init(AppConstants.googleWebClientId);
            final idToken = await _googleAuthClient.signInAndGetIdToken();
            if (idToken != null) {
              AppLogger.showDebug("ID Token: $idToken");
            } else {
              AppLogger.showDebug("Sign in canceled or failed");
            }
          },
        ),
      ),
    );
  }
}
