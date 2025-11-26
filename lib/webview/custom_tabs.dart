import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class CustomTabUtils {
  static Future<void> openUrl(BuildContext context, String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          showTitle: true,
          urlBarHidingEnabled: true,
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: Theme.of(context).colorScheme.surface,
            navigationBarColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: Theme.of(context).colorScheme.surface,
          preferredControlTintColor: Theme.of(context).colorScheme.onSurface,
          barCollapsingEnabled: true,
        ),
      );
    } catch (e) {
      debugPrint("Could not launch URL: $e");
    }
  }
}
