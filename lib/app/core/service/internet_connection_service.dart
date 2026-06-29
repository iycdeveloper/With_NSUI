import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';

class InternetConnectionService extends GetxController{
  /// This is used for internet change listener
  StreamSubscription? _streamSubscription;


  @override
  void onInit() {
    _checkForInternetConnectivity();
    super.onInit();
  }


  @override
  void onClose() {
    _streamSubscription!.cancel();
    super.onClose();
  }

  /// Starts the check for internet connectivity. If there is no connection
  /// with the internet a text message will be shown. If the application
  /// is not able to connect to the internet even if the connection is available
  /// will ask the user to check the internet permission.
  void _checkForInternetConnectivity() {
    Log.printILog('Internet connection checking service start');
    _streamSubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      // You would process the results here.
      // However, the usual use case is to listen to only a single ConnectivityResult.
      if (results.isNotEmpty) {
        var result = results.first;  // Getting the first result from the list
        if (result != ConnectivityResult.none) {
          ProgressDialogUtils.closeDialog();
        } else {
          Log.printILog('No internet connection');
          showNoInternetDialog();
        }
      }
    });
  }

  /// Show no internet dialog if there is no
  /// internet available.
  static void showNoInternetDialog() {
    ProgressDialogUtils.closeDialog();
    Get.dialog<void>(
      NoInternetWidget(),
      barrierDismissible: false,
    );
  }


}

/// A no internet widget which will be shown if network connection is not
/// available.
class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Colors.black12,
    body: Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No Internet',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}