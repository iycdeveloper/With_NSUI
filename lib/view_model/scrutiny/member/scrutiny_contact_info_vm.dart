import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../../di_container.dart';

class ScrutinyContactInfoVM extends ChangeNotifier {
  ScrutinyContactInfoVM();

  ApiConfig apiConfig = sl<ApiConfig>();
  GlobalKey<FormState> thirdFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileFormKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FocusNode mobileFocus = FocusNode();
  final FocusNode otpCodeFocus = FocusNode();
  final FocusNode verificationCodeFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode pinFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();

  bool otpSend = false;
  bool otpVerified = false;
  String isEdited = "0";
  String? membershipId;

  bool disabledContactEditing = true;
  bool enableOtp = false;
  bool isLoading = false;
  bool disableFields = true; // all text fields are disabled
  List<String> scrutinyCodeList = [];

  changeEditStatus() {
    isEdited = "1";
    notifyListeners();
  }

  checkPrefillData(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    addressController.text = membershipRequestModel.address ?? "";
    pinController.text = membershipRequestModel.pin ?? "";
    mobileController.text = membershipRequestModel.mobile ?? "";
    emailController.text = membershipRequestModel.email ?? "";
    verificationCodeController.text = membershipRequestModel.verificationCode ?? "";

    Log.printILog(membershipRequestModel.scrutinyCode);
    scrutinyCodeList = membershipRequestModel.scrutinyCode!.split(';');

    scrutinyCodeList.forEach((element) {
      if(element == "1"){
        enableOtp = true;
      }
      if(element == '5'){
        disabledContactEditing = false;
        enableOtp = true;
      }
    });


    // if (membershipRequestModel.scrutinyCode != null) {
    //   if (membershipRequestModel.scrutinyCode!.contains("1")) {
    //     print(true);
    //     enableOtp = true;
    //   }
    //   if (membershipRequestModel.scrutinyCode!.contains("5")) {
    //     print(true);
    //     disabledContactEditing = false;
    //   }
    // }
  }

  getOtp(BuildContext context) async {
    showNetworkLoadingDialog(context);
    var testJsonData = '''[{
    "ST_CODE":"${await LocalStorageServices().getSTCode()}",
    "MOBILE":"${mobileController.text}",
    "CHANNEL":"${AppConstants.channel}",
    "V":"${AppConstants.membershipVersion}",
    "DEVICE_ID":"${await getDeviceIdentifier()}"}]''';
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.checkAMMobile, jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        otpSend = true;
        notifyListeners();
      } else {
        Navigator.of(context).pop();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
  }

  Future<void> verifyOtpForMember() async {
    if (!otpSend) {
      CustomSnackBar.showErrorSnackBar("kindly get OTP and then verify it");
      return;
    }
    if (verificationCodeController.text.isEmpty) {
      CustomSnackBar.showErrorSnackBar("kindly fill verification code send to your mobile");
      return;
    }
    ProgressDialogUtils.showProgressIndicator();
    Map d = {
      "ST_CODE": "${await LocalStorageServices().getSTCode()}",
      "MOBILE": "${mobileController.text}",
      "OTP": "${verificationCodeController.text}",
      "CHANNEL": "${AppConstants.channel}",
      "V":"${AppConstants.membershipVersion}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}",
      "ORG": "LC",
    };
    var testJsonData = '''[${json.encode(d)}]''';
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.verifyAMMobile,
        jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        otpVerified = true;
        notifyListeners();
      } else {
        otpVerified = false;
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
      notifyListeners();
    } else {
      otpVerified = false;
      ProgressDialogUtils.closeDialog();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
  }

  populateModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    membershipRequestModel.address = addressController.text;
    membershipRequestModel.pin = pinController.text;
    membershipRequestModel.mobile = mobileController.text;
    membershipRequestModel.email = emailController.text;
    membershipRequestModel.modifiedOn = DateTime.now().toString();
    membershipRequestModel.isSync = "0";
    membershipRequestModel.isEditedScrutiny = "0";
    membershipRequestModel.verificationCode = verificationCodeController.text;
    context
        .read<ScrutinyMembershipEditVM>()
        .setCurrentMember(membershipRequestModel);
  }

  refresh() {
    try {
      membershipId = "";
      verificationCodeController.clear();
      addressController.clear();
      pinController.clear();
      mobileController.clear();
      emailController.clear();
      mobileFormKey.currentState!.reset();
      thirdFormKey.currentState!.reset();
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }
}
