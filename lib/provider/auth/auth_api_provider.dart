import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/services/iyc_db_services.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/model/data_model/login_model.dart';
import 'package:iyc/model/data_model/otp_model.dart';
import 'package:iyc/provider/auth/register_provider.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/scrutiny/scrutiny_batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/scrutiny/scrutiny_members_db_repo.dart';
import 'package:iyc/app/data/resources/repository/auth_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/ui/home/home_page_iyc.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../di_container.dart';
import '../../utils/app_constants.dart';
import '../global/home_page_iyc_provider.dart';

class AuthApiProvider {
  final AuthRepo authRepo;
  final ApiConfig apiConfig;

  AuthApiProvider({required this.authRepo, required this.apiConfig});


  editProfile(
      {required BuildContext context, required UserDetail userData}) async {
    showNetworkLoadingDialog(context);
    ApiResponse apiResponse = await authRepo.editProfile(userData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
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
    String? result = await AwsUploadServices().uploadFile(
        file: File(amPhotoFilePath),
        destDir: "PROFILE",
        filename: "${mobile}_P.${amPhotoFilePath.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  void getOtpLogin(
      {required BuildContext context,
      required LoginModel loginModel,
      String? userImagePath}) async {

  }

  void getResendOtpLogin({
    required BuildContext context,
    required LoginModel loginModel,
  }) async {
    showNetworkLoadingDialog(context);
    //var positionResult = await LocationServices().determinePosition();
    ApiResponse apiResponse = await authRepo.login(loginModel: loginModel);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("OTP Send")));
        // toPage(
        //     context,
        //     OtpVerification(
        //       loginModel: loginModel,
        //       otpModel: OTPModel(
        //         mobile: loginModel.mobile,
        //         dtCode: loginModel.districtCode,
        //         stCode: loginModel.stateCode,
        //       ),
        //     ));
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

  void verifyOtpLogin(
      {required BuildContext context,
      required OTPModel otpModel,
      String? userImagePath}) async {
    showNetworkLoadingDialog(context);
    ApiResponse apiResponse = await authRepo.verifyOtpLogin(
        {"MOBILE": "${otpModel.mobile}", "OTP": "${otpModel.otp}"});
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        await dobRange(context: context);
        await LocalStorageServices()
            .setSessionId(responseDecoded["response"]['SESSION_ID']);
        await LocalStorageServices()
            .setUserId(responseDecoded["response"]['USER_ID']);
        final profileResult = await getUserProfile();
        if (profileResult) {
          if (userImagePath != null)
            await uploadDocumentAmPhoto(userImagePath, otpModel.mobile);
          Navigator.of(context).pop(); // network loading

          print(
              "current scpe is : ${sl.currentScopeName}.............................");
          sl.pushNewScope(
              init: (getIt) async {
                print(
                    "....................... current scope changes to ${getIt.currentScopeName}...................................");
                await initIycScope();
              },
              scopeName: "iyc_scope",
              dispose: () async {
                debugPrint(
                    "................................on dispose scope: ${sl.currentScopeName}");
              });

          toPage(
              context,
              ChangeNotifierProvider(
                  create: (context) => HomePageIycProvider(),
                  child: HomePageIyc()),
              routeSettingName: "/home");
        } else {
          Navigator.of(context).pop();
          // ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text("User profile is missing State code")));
        }
        // toPage(context, HomePage());
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

  getUserProfile() async {
    ApiResponse apiResponse = await authRepo.getUserDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
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

  logout({required BuildContext context}) async {
    showNetworkLoadingDialog(context);

    List<BatchDataModel> _membershipBatchList =
        await sl<BatchDBRepo>().getData();
    if (_membershipBatchList.any((element) => element.syncStatus == "0")) {
      final result = await Alert(
        context: context,
        type: AlertType.warning,
        title: "Alert",
        desc:
            "Un-Synced batches exits. Logout will clear all data. Click Okay to force logout.",
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pop(context, false);
            },
            width: 120,
          ),
          DialogButton(
            child: Text(
              "OKAY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pop(context, true);
            },
            width: 120,
          )
        ],
      ).show();
      if (result == null || !result) {
        Navigator.pop(context); // pop loading
        return;
      }
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    ///delete batch table#9995137343
    var result = await Future.wait([
      sl<BatchDBRepo>().deleteTable(),
      sl<MembershipMemberDB>().deleteTable(),
      sl<ScrutinyBatchDBRepo>().deleteTable(),
      sl<ScrutinyMembershipDBRepo>().deleteTable()
    ]);
    print(result);
    if (sl<Database>().isOpen) await IycDbServices.db.deleteDb();
    final popResult = await sl.popScopesTill("iyc_scope");
    print("$popResult   current scope changed to ${sl.currentScopeName} ");

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("log out cleared all data")));
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => LoginWithMobile()),
    //     (_) => false);
    return false;
  }

  Future<bool> dobRange({required BuildContext context}) async {
    bool dobRangeDone = false;

    var testJsonData = '''[{
    
    "V":"${AppConstants.dobVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}","STATE_CODE":"${await LocalStorageServices().getSTCode()}"}]''';

    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.DOBRange, jsonData: testJsonData);
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
}
