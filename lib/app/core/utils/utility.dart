import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class Utility {

  /// Show a loading progress indicator
  /// on top of the screen.
  static void showLoadingDialog() {
    closeDialog();
    Get.dialog<void>(
      WillPopScope(
        onWillPop: () async => false,
        child: Align(
          alignment: Alignment.center,
          child: Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              )
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Show no internet dialog if there is no
  /// internet available.
  static void showNoInternetDialog() {
    closeDialog();
    // Get.dialog<void>(
    //   // NoInternetWidget(),
    //   barrierDismissible: false,
    // );
  }

  /// Close any open snack bar.
  static void closeSnackBar() {
    if (Get.isSnackbarOpen ?? false) Get.back<void>();
  }

  /// Close any open dialog.
  static void closeDialog() {
    if (Get.isDialogOpen ?? false) Get.back<void>();
  }

  /// Close any open bottom sheet.
  static void closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) Get.back<void>();
  }
}