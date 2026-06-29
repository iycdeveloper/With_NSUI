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
import 'package:sms_autofill/sms_autofill.dart';
import 'package:sqflite/sqlite_api.dart';

class LoginNSUIController extends GetxController with CodeAutoFill {
  Rx<TextEditingController> mobileNumberController =
      TextEditingController().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;

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
    if (mobileNumberController.value.text.length == 10) {
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
          try {
            if (sl<Database>().isOpen) await IycDbServices.db.deleteDb();
            await IycDbServices.db.initDB();
            // await DbServices.db.database;
          } catch (e) {
            Log.printELog(e);
          } finally {
            RoutesManagement.goToHomeScreenNSUI();
          }
        }
      });
    }
  }
}
