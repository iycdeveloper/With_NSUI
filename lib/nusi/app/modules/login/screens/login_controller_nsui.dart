import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/services/iyc_db_services.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/data_model/login_model.dart';
import 'package:iyc/model/data_model/otp_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:sqflite/sqlite_api.dart';

class LoginNSUIController extends GetxController with CodeAutoFill {
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;

  String appVersion = '';

  Future<void> loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    update();
  }

  final authService = Get.find<AuthService>();

  bool reSendOtp = false;

  int start = 60;
  Timer? timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) {
      if (start < 1) {
        timer.cancel();
        reSendOtp = true;
      } else {
        start = start - 1;
      }
      update();
    });
  }

  @override
  void codeUpdated() {
    otpController.value.text = code ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    // _startRecordingLoop();
    // setrecorder();
    Get.put(AuthService(), permanent: true);
    listenForCode();
    loadAppVersion();
  }

  // setrecorder(){
  //   Workmanager().registerPeriodicTask(
  //     "audioRecordingTask",
  //     "recordAudio",
  //     frequency: const Duration(minutes: 3),
  //   );
  // }

  void onClickLogin() async {
    // RoutesManagement.goToHomeScreenNSUI();
    // return;
    start = 60;
    reSendOtp = false;
    update();
    otpController = TextEditingController().obs;
    /// Accept 10 or 11 digit mobile numbers.
    final mobileLength = mobileNumberController.value.text.length;
    if (mobileLength == 10 || mobileLength == 11) {
      await authService
          .getOtpLogin(
              loginModel: LoginModel(mobile: mobileNumberController.value.text))
          .whenComplete(() {
        startTimer();
      });
      startTimer();
    } else {
      CustomSnackBar.showWarningSnackBar('Enter correct mobile number');
    }
  }

  void onClickReSendOtp() async {
    if (reSendOtp) {
      await authService.getResendOtpLogin(
          loginModel: LoginModel(mobile: mobileNumberController.value.text));
      start = 60;
      reSendOtp = false;
      update();
      startTimer();
    } else {
      CustomSnackBar.showWarningSnackBar('Wait 60 sec to resend OTP');
    }
  }

  void verifyLoginOtp(String otp) async {
    if (otp.length == 6) {
      var otpModel =
          OTPModel(mobile: mobileNumberController.value.text, otp: otp);
      await authService.verifyOtpLogin(otpModel: otpModel).then((value) async {
        if (value) {
          /// `sl<Database>()` was never registered in GetIt, so this threw
          /// every time — and because the throw happened on the first line of
          /// the try, `initDB()` below never ran either. Drop the stale
          /// lookup and let each step fail independently.
          try {
            await IycDbServices.db.deleteDb();
          } catch (e) {
            Log.printELog('deleteDb on login failed: $e');
          }
          try {
            await IycDbServices.db.initDB();
          } catch (e) {
            Log.printELog('initDB on login failed: $e');
          } finally {
            RoutesManagement.goToHomeScreenNSUI();
          }
        }
      });
    }
  }
}
