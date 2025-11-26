import 'package:flutter/material.dart';
import 'package:spider/auth/google_photos_auth.dart';
import 'package:spider/const/app_constants.dart';
import 'package:spider/logger/app_logger.dart';
import 'package:spider/peeker/google_photos_peeker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final googleAuth = GooglePhotosAuth(
    webClientId: AppConstants.googleWebClientId,
  );
  bool _isPicking = false;
  List<dynamic>? _selectedMedia;
  late final GooglePhotosPeeker _googlePhotosPeeker;

  @override
  void initState() {
    super.initState();

    _googlePhotosPeeker = GooglePhotosPeeker(
      backendBaseUrl: AppConstants.backendBaseUrl
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Click Google Photos'),
          onPressed: () async {
            final accessToken = await googleAuth.signInAndGetAccessToken();

            if (accessToken != null) {
              AppLogger.showDebug("Access Token: $accessToken");

              final mediaItems = await _googlePhotosPeeker.pick(
                accessToken: AppConstants.myAccessToken,
              );

              if (mediaItems != null) {
                AppLogger.showDebug("Selected items: $mediaItems");
              } else {
                AppLogger.showDebug("No items selected");
              }
              
              
            } else {
              AppLogger.showDebug("Sign in canceled or failed");
            }
          },
        ),
      ),
    );
  }
}
