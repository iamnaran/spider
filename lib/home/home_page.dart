import 'package:flutter/material.dart';
import 'package:spider/auth/google_photos_auth.dart';
import 'package:spider/const/app_constants.dart';
import 'package:spider/home/component/media_grid_item.dart';
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
  bool isLoading = false;
  List<dynamic>? mediaItems;
  late final GooglePhotosPeeker _googlePhotosPeeker;

  @override
  void initState() {
    super.initState();

    _googlePhotosPeeker = GooglePhotosPeeker(
      backendBaseUrl: AppConstants.backendBaseUrl
    );
  }

  Future<void> pickPhotos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final items = await _googlePhotosPeeker.pickPhotos(
        accessToken: AppConstants.myAccessToken,
        maxItems: 10,
      );
      setState(() {
        mediaItems = items;
      });

      AppLogger.showDebug('Picked media items: $items');
    } catch (e) {
      AppLogger.showDebug('Error picking photos: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildMediaGrid() {
    if (mediaItems == null || mediaItems!.isEmpty) {
      return const Center(child: Text('No media items picked'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: mediaItems!.length,
      itemBuilder: (context, index) {
        final item = mediaItems![index];
        final mediaFile = item['mediaFile'] as Map<String, dynamic>?;

        final url = mediaFile?['baseUrl'] ?? '';

        if (url.isEmpty) return const Icon(Icons.photo);

        return MediaGridItem(
          baseUrl: url,
          accessToken: AppConstants.myAccessToken, // provide your token here
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isLoading ? null : pickPhotos,
                child: Text(isLoading ? 'Picking...' : 'Pick Photos'),
              ),
            ),
            Expanded(child: _buildMediaGrid()),
          ],
        ),
      ),
    );
  }
}
