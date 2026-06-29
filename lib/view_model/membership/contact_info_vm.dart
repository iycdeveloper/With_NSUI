import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../di_container.dart';
import 'membership_vm.dart';

class ContactInfoVM extends ChangeNotifier {
  @override
  void dispose() {
    mobileFocus.dispose();
    pinCodeFocus.dispose();
    otpCodeFocus.dispose();
    super.dispose();
  }

  final ApiConfig apiConfig;

  ContactInfoVM({required this.apiConfig});

  GlobalKey<FormState> thirdFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileFormKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final FocusNode mobileFocus = FocusNode();
  final FocusNode otpCodeFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode pinCodeFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  bool otpSend = false;
  bool otpVerified = false;
  String isEdited = "0";
  String? membershipId;
  bool isRegisteredMobileFocus = false;
  bool isRegisteredPinCodeFocus = false;
  bool isRegisteredOtpPinFocus = false;

  bool isLoading = false;
  bool disableFields = false;
  List<String> scrutinyCodeList = [];

  changeEditStatus() {
    isEdited = "1";
    notifyListeners();
  }

  changePhoneNumberStatus() {
    print("calledd");
    otpSend = false;
    otpVerified = false;
    notifyListeners();
  }

  getOtp(BuildContext context) async {
    showNetworkLoadingDialog(context);
    Map d = {
      "ST_CODE": "${await LocalStorageServices().getSTCode()}",
      "MOBILE": "${mobileController.text}",
      "CHANNEL": "${AppConstants.channel}",
      "V":
          "${context.read<MembershipVM>().isLegalCellReg ? AppConstants.legalCellVersion : AppConstants.membershipVersion}",
      "DEVICE_ID": "${await getDeviceIdentifier()}"
    };
    if (context.read<MembershipVM>().isLegalCellReg)
      d.addAll({
        "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
        "USER_ID": "${await LocalStorageServices().getUserId()}",
        "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}",
        "ORG": "LC"
      });
    var testJsonData = '''[${json.encode(d)}]''';
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: context.read<MembershipVM>().isLegalCellReg
            ? Urls.getOtpLegalCell
            : Urls.checkAMMobile,
        jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        otpSend = true;
        notifyListeners();
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  checkPrefillData(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    addressController.text = membershipRequestModel.address ?? "";
    pinController.text = membershipRequestModel.pin ?? "";
    mobileController.text = membershipRequestModel.mobile ?? "";
    emailController.text = membershipRequestModel.email ?? "";
    if (membershipRequestModel.verificationCode != null &&
        membershipRequestModel.verificationCode!.isNotEmpty) otpVerified = true;
    if (membershipRequestModel.scrutinyCode != null) {
      scrutinyCodeList = membershipRequestModel.scrutinyCode!.split(';');
      scrutinyCodeList.forEach((element) {
        if (element == "2") {
          disableFields = true;
        }
        if (element == "9") {
          disableFields = true;
        }
        if (element == "1") {
          disableFields = true;
        }
      });
    }
  }

  populateModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    membershipRequestModel.address = addressController.text;
    membershipRequestModel.pin = pinController.text;
    if (verificationCodeController.text.isNotEmpty)
      membershipRequestModel.verificationCode = verificationCodeController.text;
    membershipRequestModel.city = "City Name Something";
    membershipRequestModel.mobile = mobileController.text;
    membershipRequestModel.email = emailController.text;
    membershipRequestModel.modifiedOn = DateTime.now().toString();
    membershipRequestModel.isSync = "0";
    membershipRequestModel.isEditedScrutiny = "0";
    context.read<MembershipVM>().setCurrentMember(membershipRequestModel);
  }

  Future<bool> validatePage(BuildContext context) async {
    // return true;
    /// bypass otp verification for test state
    var stateCode = Get.find<HomeController>().profileController.userDetail?.stateCode??'';
    if(stateCode == 'TS') return true;

    if (!otpVerified) await verifyOtpForMember(context);
    return otpVerified;
  }

  verifyOtpForMember(BuildContext context) async {
    if (!otpSend) {
      CustomSnackBar.showErrorSnackBar("kindly get OTP and then verify it");
      return false;
    }
    if (verificationCodeController.text.isEmpty) {
      CustomSnackBar.showErrorSnackBar("kindly fill verification code send to your mobile");
      return false;
    }
    showNetworkLoadingDialog(context);
    Map d = {
      "ST_CODE": "${await LocalStorageServices().getSTCode()}",
      "MOBILE": "${mobileController.text}",
      "OTP": "${verificationCodeController.text}",
      "CHANNEL": "${AppConstants.channel}",
      "V":
          "${context.read<MembershipVM>().isLegalCellReg ? AppConstants.legalCellVersion : AppConstants.membershipVersion}",
      "DEVICE_ID": "${await getDeviceIdentifier()}"
    };
    if (context.read<MembershipVM>().isLegalCellReg)
      d.addAll({
        "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
        "USER_ID": "${await LocalStorageServices().getUserId()}",
        "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}",
        "ORG": "LC",
      });
    var testJsonData = '''[${json.encode(d)}]''';
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: context.read<MembershipVM>().isLegalCellReg
            ? Urls.verifyLegalCellMobile
            : Urls.verifyAMMobile,
        jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        otpVerified = true;
        notifyListeners();
      } else {
        otpVerified = false;
        Navigator.of(context).pop();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
      notifyListeners();
    } else {
      otpVerified = false;
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
  }

  void init(BuildContext context) {
    if (!isRegisteredMobileFocus) {
      isRegisteredMobileFocus = true;
      mobileFocus.addListener(() {
        bool hasFocus = mobileFocus.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      });
    }
    if (!isRegisteredPinCodeFocus) {
      isRegisteredPinCodeFocus = true;
      pinCodeFocus.addListener(() {
        bool hasFocus = pinCodeFocus.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      });
    }
    if (!isRegisteredOtpPinFocus) {
      isRegisteredOtpPinFocus = true;
      otpCodeFocus.addListener(() {
        bool hasFocus = otpCodeFocus.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      });
    }
  }
}
