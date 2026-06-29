import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/service/auth_service.dart';

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
}
