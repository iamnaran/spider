import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MediaGridItem extends StatefulWidget {
  final String baseUrl;
  final String accessToken;

  const MediaGridItem({
    super.key,
    required this.baseUrl,
    required this.accessToken,
  });

  @override
  State<MediaGridItem> createState() => _MediaGridItemState();
}

class _MediaGridItemState extends State<MediaGridItem> {
  Uint8List? imageBytes;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final res = await http.get(
        Uri.parse('${widget.baseUrl}=w400-h400'),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (res.statusCode == 200) {
        setState(() {
          imageBytes = res.bodyBytes;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.grey[200],
        child: isLoading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : hasError
            ? const Icon(Icons.broken_image)
            : Image.memory(imageBytes!, fit: BoxFit.cover),
      ),
    );
  }
}
