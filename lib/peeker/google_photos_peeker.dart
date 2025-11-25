import 'service/picker_service.dart';
import 'package:url_launcher/url_launcher.dart';

class GooglePhotosPeeker {
  final String backendBaseUrl;
  late final PickerService pickerService;

  GooglePhotosPeeker({required this.backendBaseUrl}) {
    pickerService = PickerService(backendBaseUrl);
  }

  Future<List<dynamic>?> pick({required String idToken}) async {
    final session = await pickerService.createSession(idToken);
    if (session == null) return null;

    final pickerUri = session["pickerUri"];
    final sessionId = session["sessionId"];

    await launchUrl(Uri.parse(pickerUri), mode: LaunchMode.externalApplication);

    return await _pollForResult(sessionId);
  }

  Future<List<dynamic>?> _pollForResult(String sessionId) async {
    while (true) {
      final result = await pickerService.pollSession(sessionId);

      if (result != null && result["mediaItemsSet"] == true) {
        return result["mediaItems"];
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
