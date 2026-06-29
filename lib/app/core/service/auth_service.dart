import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/dio/logging_interceptor.dart';
import 'package:iyc/app/data/resources/repository/auth_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/iyc_db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/helper/network_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/model/data_model/login_model.dart';
import 'package:iyc/model/data_model/otp_model.dart';
import 'package:iyc/model/data_model/registrer_model.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/scrutiny/scrutiny_batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/scrutiny/scrutiny_members_db_repo.dart';
import 'package:iyc/nusi/app/modules/login/widgets/logout_confirmation_bootom_sheet_nsui.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

class AuthService extends GetxService {
  SharedPreferences? sharedPreferences;
  late final AuthRepo authRepo;
  late final ApiConfig apiConfig;

  @override
  void onInit() async {
    super.onInit();
    sharedPreferences = await SharedPreferences.getInstance();
    authRepo = AuthRepo(
        dioClient: DioClient(Urls.baseUrl, Dio(),
            loggingInterceptor: LoggingInterceptor(),
            sharedPreferences: sharedPreferences!));

    apiConfig = ApiConfig(
      client: Dio(),
      networkConfig: NetworkConfigImpl(
        dataConnectionChecker: InternetConnectionChecker.createInstance(),
      ),
    );
  }

  Future<void> register(
      {required RegisterModel registerData,
      required String address,
      required String pincode,
      required String tag,
      required String referralMobileNo}) async {
    ProgressDialogUtils.showProgressDialog();
    ApiResponse apiResponse = await authRepo.register(
        data: registerData,
        address: address,
        pincode: pincode,
        tag: tag,
        referralMobileNo: referralMobileNo);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.hideProgressDialog();
        await LocalStorageServices().setSTCode(registerData.stateCode);
        dobRange(context: Get.context!);
        await getOtpLogin(
            loginModel: LoginModel(
              mobile: registerData.mobile,
            ),
            userImagePath: registerData.amImagePath);
        RoutesManagement.goToLoginOtpScreenNSUI();
      } else {
        ProgressDialogUtils.hideProgressDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    } else {
      ProgressDialogUtils.hideProgressDialog();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.toString());
    }
  }

  Future<void> editProfile(
      {required BuildContext context, required UserDetail userData}) async {
    showNetworkLoadingDialog(context);
    ApiResponse apiResponse = await authRepo.editProfile(userData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop(); // net work dilog

        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  Future<bool> uploadDocumentAmPhoto(
      String amPhotoFilePath, String mobile) async {
    Log.printILog('Uploading Profile Photo');
    ProgressDialogUtils.showProgressDialog();
    String? result = await AwsUploadServices().uploadFile(
        file: File(amPhotoFilePath),
        destDir: "PROFILE",
        filename: "${mobile}_P.${amPhotoFilePath.split(".").last}");
    if (result is String) {
      ProgressDialogUtils.hideProgressDialog();
      return true;
    } else {
      ProgressDialogUtils.hideProgressDialog();
      return false;
    }
  }

  Future<void> getOtpLogin(
      {required LoginModel loginModel, String? userImagePath}) async {
    ProgressDialogUtils.showProgressDialog();
    ApiResponse apiResponse = await authRepo.login(loginModel: loginModel);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.hideProgressDialog();
        RoutesManagement.goToLoginOtpScreenNSUI();
      } else {
        ProgressDialogUtils.hideProgressDialog();
        if ("User profile not found for the given mobile number" ==
            responseDecoded["response"]) {
          CustomSnackBar.showWarningSnackBar(
              "User profile not found for the given mobile number");
        }
        RoutesManagement.goToRegisterScreenNSUI(loginModel.mobile);
      }
    } else {
      ProgressDialogUtils.hideProgressDialog();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.toString());
    }
  }

  Future<void> getResendOtpLogin({
    required LoginModel loginModel,
  }) async {
    ProgressDialogUtils.showProgressDialog();
    ApiResponse apiResponse = await authRepo.login(loginModel: loginModel);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.hideProgressDialog();
        CustomSnackBar.showSuccessSnackBar('OTP send');
      } else {
        ProgressDialogUtils.hideProgressDialog();
        CustomSnackBar.showSuccessSnackBar(responseDecoded["response"]);
      }
    } else {
      ProgressDialogUtils.hideProgressDialog();
      CustomSnackBar.showSuccessSnackBar(apiResponse.error.toString());
    }
  }

  Future<bool> verifyOtpLogin(
      {required OTPModel otpModel, String? userImagePath}) async {
    ProgressDialogUtils.showProgressDialog();
    ApiResponse apiResponse = await authRepo
        .verifyOtpLogin({"MOBILE": otpModel.mobile, "OTP": "${otpModel.otp}"});
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        await dobRange(context: Get.context!);
        await LocalStorageServices()
            .setSessionId(responseDecoded["response"]['SESSION_ID']);
        await LocalStorageServices()
            .setUserId(responseDecoded["response"]['USER_ID']);
        final profileResult = await getUserProfile();
        if (profileResult) {
          if (userImagePath != null) {
            await uploadDocumentAmPhoto(userImagePath, otpModel.mobile);
          }
          ProgressDialogUtils.hideProgressDialog();
          Log.printILog(
              "current scpe is : ${sl.currentScopeName}.............................");
          sl.pushNewScope(
              init: (getIt) async {
                Log.printILog(
                    "....................... current scope changes to ${getIt.currentScopeName}...................................");
                await initIycScope();
              },
              scopeName: "iyc_scope",
              dispose: () async {
                Log.printILog(
                    "................................on dispose scope: ${sl.currentScopeName}");
              });
        } else {
          ProgressDialogUtils.hideProgressDialog();
        }
        return true;
      } else {
        ProgressDialogUtils.hideProgressDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    } else {
      ProgressDialogUtils.hideProgressDialog();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.toString());
    }
    return false;
  }

  Future<bool> getUserProfile() async {
    ApiResponse apiResponse = await authRepo.getUserDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        await LocalStorageServices().setSTCode(responseDecoded["response"]['BASIC_DETAILS'][0]
                ["state_code"] ??
            responseDecoded["response"]['BASIC_DETAILS'][0]["state"]);

        await LocalStorageServices().setWorkStateCode(
            responseDecoded["response"]['BASIC_DETAILS'][0]["work_state"] ?? "");
        await LocalStorageServices()
            .setDisCode(responseDecoded["response"]['BASIC_DETAILS'][0]["district_code"]);
        await LocalStorageServices()
            .setAssemblyCode(responseDecoded["response"]['BASIC_DETAILS'][0]["assembly_code"]);
        await LocalStorageServices()
            .setUserProfileName("${responseDecoded["response"]['BASIC_DETAILS'][0]["name"]}");

        await LocalStorageServices()
            .setMobile(responseDecoded["response"]['BASIC_DETAILS'][0]["mobile"]);
        return true;
      }
      return false;
    }
    return false;
  }

  Future<void> forceLogout() async {
    ProgressDialogUtils.showProgressDialog();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      await Future.wait([
        sl<BatchDBRepo>().deleteTable(),
        sl<MembershipMemberDB>().deleteTable(),
        sl<ScrutinyBatchDBRepo>().deleteTable(),
        sl<ScrutinyMembershipDBRepo>().deleteTable(),
      ]);
      if (sl<Database>().isOpen) await IycDbServices.db.deleteDb();
    } finally {
      final popResult = await sl.popScopesTill("iyc_scope");
      Log.printDLog(
          "$popResult current scope changed to ${sl.currentScopeName}");
      CustomSnackBar.showSuccessSnackBar("log out cleared all data");
      await preferences.clear();
      RoutesManagement.goToLoginScreen();
    }
  }

  Future<bool> logout({required BuildContext context}) async {
    final theme = Theme.of(context);
    ProgressDialogUtils.showProgressDialog();
    try {
      List<BatchDataModel> _membershipBatchList =
          await sl<BatchDBRepo>().getData();
      if (_membershipBatchList.any((element) => element.syncStatus == "0")) {
      final result=await  logoutConfirmationNSUIBottomSheet(context);
        // final result = await Alert(
        //   context: context,
        //   type: AlertType.warning,
        //   style: AlertStyle(
        //     backgroundColor: const Color(0xff57b5eb),
        //     // descStyle: theme.textTheme.displayMedium!
        //     //     .copyWith(color: Colors.white, fontWeight: FontWeight.w400),

        //     // isCloseButton: true
        //   ),
        //   title: "Alert",
        //   desc:
        //       "Un-Synced batches exits. Logout will clear all date. Click Okay to force logout.",
        //   buttons: [
        //     DialogButton(
        //       child: const Text(
        //         "Cancel",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () async {
        //         Navigator.pop(context, false);
        //       },
        //       width: 120,
        //     ),
        //     DialogButton(
        //       child: const Text(
        //         "OKAY",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () async {
        //         Navigator.pop(context, true);
        //       },
        //       width: 120,
        //     )
        //   ],
        // ).show();
        if (result == null || !result) {
          Navigator.pop(context); // pop loading
          return false;
        }
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();

      var result = await Future.wait([
        sl<BatchDBRepo>().deleteTable(),
        sl<MembershipMemberDB>().deleteTable(),
        sl<ScrutinyBatchDBRepo>().deleteTable(),
        sl<ScrutinyMembershipDBRepo>().deleteTable(),
      ]);
      Log.printILog(result);
      if (sl<Database>().isOpen) await IycDbServices.db.deleteDb();
      final popResult = await sl.popScopesTill("iyc_scope");
      Log.printDLog(
          "$popResult   current scope changed to ${sl.currentScopeName} ");
    } catch (e) {
    } finally {
      CustomSnackBar.showSuccessSnackBar("log out cleared all data");
      RoutesManagement.goToLoginscreenNSUI();
    }

    return false;
  }

  Future<bool> dobRange({required BuildContext context}) async {
    Log.printILog("Init DOB range");
    bool dobRangeDone = false;

    var testJsonData = '''[{
    
    "V":"${AppConstants.dobVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "STATE_CODE":"${await LocalStorageServices().getSTCode()}"}]''';

    // Log.printDLog(testJsonData);

    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.DOBRange, jsonData: testJsonData);
    // Log.printDLog(Urls.DOBRange);
    // Log.printELog(apiResponse.response);
    // Log.printILog(
    //     jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data))));
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        DobRangeModel dobRangeModel = DobRangeModel.fromJson(responseDecoded);
        await LocalStorageServices()
            .setDobStartRange(dobRangeModel.response.dobstartrange!);
        await LocalStorageServices()
            .setDobEndRange(dobRangeModel.response.dobendrange!);
        sl<SharedPreferences>()
            .setString("s3_bucket", dobRangeModel.response.s3Bucket);
        sl<SharedPreferences>()
            .setString("s3_access_token", dobRangeModel.response.s3Code!);
        sl<SharedPreferences>()
            .setString("s3_secret_key", dobRangeModel.response.s3Secret!);
        sl<SharedPreferences>().setString(
            "payment_access_token", dobRangeModel.response.accessCode!);
        sl<SharedPreferences>().setString(
            "payment_merchant_id", dobRangeModel.response.merchantId!);
        dobRangeDone = true;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    return dobRangeDone;
  }

  Future<bool> deleteAccount() async {
    ProgressDialogUtils.showProgressDialog();
    ApiResponse apiResponse = await authRepo.deleteAccount();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      RoutesManagement.goToLoginScreen();
      CustomSnackBar.showSuccessSnackBar('Account deleted successfully');
    } else {
      ProgressDialogUtils.hideProgressDialog();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.toString());
    }
    return false;
  }
}
