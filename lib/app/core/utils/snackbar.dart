import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class CustomSnackBar{
  static void showSuccessSnackBar(String info) {
    Get.snackbar('Success', info,
        backgroundColor: Colors.white,
        margin: EdgeInsets.all( 10),
        colorText: Colors.black,
        icon: Icon(Icons.check),
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM);
  }

  static void showErrorSnackBar(String info) {
    Get.snackbar('Error', info,
        margin: EdgeInsets.all( 10),
        backgroundColor: Colors.grey.shade50,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.error),
        snackPosition: SnackPosition.BOTTOM);
  }

  static void showWarningSnackBar(String info) {
    Get.snackbar('Warning', info,
        margin: EdgeInsets.all( 10),
        backgroundColor: Colors.grey.shade50,
        colorText: Colors.black,
        icon: Icon(Icons.warning),
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showAlertSnackBar(String info) {
    Get.snackbar('Alert', info,
        margin: EdgeInsets.all( 10),
        backgroundColor: Colors.grey.shade50,
        colorText: Colors.black,
        icon: Icon(Icons.warning),
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showSessionInvalidSnackBar(){
    Get.snackbar('Error', 'Session invalid. Logout and login again',
        margin: EdgeInsets.all( 10),
        backgroundColor: Colors.grey.shade50,
        colorText: Colors.black,
        duration: Duration(days: 3),
        icon: Icon(Icons.error),
        snackPosition: SnackPosition.TOP,
      mainButton: TextButton(
        onPressed: () {
          Get.back();
          Get.find<AuthService>().logout(context: Get.context!);
        },
        child: Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// Blocking, non-dismissible dialog for the "app version not supported"
  /// server error (error_code 9999) — the app is unusable until the user
  /// updates, so a transient snackbar isn't enough; this can't be missed or
  /// swiped away, and links straight to the Play Store listing.
  static void showAppUpdateRequiredDialog(String message) {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          icon: const Icon(Icons.system_update_rounded,
              color: Color(0xFF1356BF), size: 36),
          title: const Text('Update Required'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.bif.nsui');
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
