import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/batch_repo.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/helper/location_helper.dart';
import 'package:iyc/helper/network_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/api_model/membership/membership_download.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/primary_member.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/primary_member_db.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../di_container.dart';
import '../../../widgets/app_bar/appbar_image_1.dart';

class MembershipMemberListController extends GetxController {
  String batchId = Get.arguments;

  ApiConfig? apiConfig;
  MembershipRepo membershipRepo = MembershipRepo(dioClient: sl());
  final MembershipMemberDB membershipDbRepo = sl<MembershipMemberDB>();
  List<BatchMember> _membershipRequestList = [];
  List<BatchMember> get membershipRequestList =>
      _membershipRequestList; //.reversed.toList();
  bool loadingPage = false;
  bool isLoadingIncUser = false;
  bool showAddOption = true;
  bool isSyncMembers = false;

  @override
  void onInit() async {
    // sl.registerLazySingleton(() => BatchDBRepo(sl()));
    apiConfig = sl();
    await getMembershipList(Get.context!, batchId);
    super.onInit();
  }

  Future<bool> getMembershipList(BuildContext context, String batchId,
      {bool? reload}) async {
    // ProgressDialogUtils.showProgressIndicator();
    if (reload != null && reload) {
      loadingPage = true;
      update();
      _membershipRequestList = await membershipDbRepo.getData(batchId);
      if (_membershipRequestList.any((element) => element.isIncMember!) ||
          _membershipRequestList.length > 1) {
        showAddOption = false;
      }
      loadingPage = false;
      update();
      // ProgressDialogUtils.closeDialog();
      return true;
    }

    loadingPage = true;
    await agrDownloadMembers(context: context, batchId: batchId);
    _membershipRequestList = await membershipDbRepo.getData(batchId);
    if (_membershipRequestList.any((element) => element.isIncMember!) ||
        _membershipRequestList.length > 1) {
      showAddOption = false;
    }

    loadingPage = false;
    update();
    ProgressDialogUtils.closeDialog();
    return true;
  }

  Future<bool> agrDownloadMembers({
    required BuildContext context,
    required String batchId,
  }) async {
    bool returnValue = false;
    ApiResponse apiResponse = await membershipRepo.downloadMembers(batchId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        /// add api membership data to local db
        MembershipDownloadResponse memberData =
            MembershipDownloadResponse.fromJson(responseDecoded);
        _membershipRequestList = await membershipDbRepo.getData(batchId);
        memberData.response.batchMember!.forEach((element) async {
          element.isSync = "1";
          if (_membershipRequestList
              .any((dbMember) => dbMember.memberId == element.memberId)) {
            return;
          } else {
            await membershipDbRepo.insertData(element);
          }

          /// add batch am count
          // Provider.of<BatchListProvider>(context, listen: false)
          //     .updateAMCount(
          //     context: context,
          //     data:
          //     BatchDataModel(batchId: batchId, countAM: value + 1));

          ///update batch list
          // Provider.of<MembershipListProvider>(context, listen: false)
          //     .getMembershipList(context, batchId);

          returnValue = true;
        });
        //  Navigator.of(context).pop();
      } else {
        //  Navigator.of(context).pop();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
        returnValue = false;
      }
      update();
    } else {
      //  Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      returnValue = false;
    }

    return returnValue;
  }

  syncMembership(BuildContext context, {Map<String, dynamic>? data}) async {
    var aggrId = await LocalStorageServices().getAgrIDMembership();
//

//Old functionality below
    // if (aggrId.isEmpty) {
    //   CustomSnackBar.showErrorSnackBar('Something went wrong');
    //   aggrId = await getAggrId(context);
    // }
    var memberData = [];
    // for (var i in membershipRequestList) {
    //   memberData.add(jsonEncode(i));
    // }
    // for (var i in primaryMemberList) {
    //   var mapValue = i.toJson(i);
    //   mapValue.remove('MOBILE');
    //   mapValue.remove('ID');
    //   mapValue['MOBILE1'] = i.mobile;
    //   mapValue['ID_VALUE'] = i.idCardNumber;
    //   memberData.add(jsonEncode(mapValue));
    // }

    memberData.add(jsonEncode(data));
    print(memberData.length);
    for (var i in memberData) {
      print(i);
    }
    showNetworkLoadingDialog(context,
        willPopScope: false, msg: 'Fetching Location .....');
    Position? _locationData;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await LocationHelper().reqService();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      }
      if (serviceEnabled) {
        _locationData = await Geolocator.getCurrentPosition();
      } else {
        CustomSnackBar.showErrorSnackBar('Enable location permission');
        Navigator.of(context).pop();
        return;
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackBar('Enable location permission');
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop();
    showNetworkLoadingDialog(context,
        willPopScope: false, msg: 'Syncing ......');
    String testJsonData = '''[{"V":"${AppConstants.membershipVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${_locationData.latitude}",
    "LONGITUDE":"${_locationData.longitude}",
    "BATCH_NO":"${_membershipRequestList.first.batchId}",
    "AGGR_ID":"$aggrId",
    "MEMBER_DATA":${memberData}}]''';

    ApiResponse apiResponse = await apiConfig!
        .postData(endpointUrl: Urls.syncMembership, jsonData: testJsonData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        await sl<BatchDBRepo>().updateData(BatchDataModel(
            batchId: membershipRequestList.first.batchId!,
            countAM: membershipRequestList.length,
            syncStatus: "1"));
        membershipRequestList.forEach((element) async {
          element.isSync = "1";
          await membershipDbRepo.updateMembershipTable(element);
        });
        isSyncMembers = true;
        showAddOption = false;
        update();
        Navigator.of(context).pop();

        /// close loading

        // await Alert(
        //   context: context,
        //   type: AlertType.success,
        //   style: const AlertStyle(backgroundColor: Colors.white),
        //   title: "SUCCESS",
        //   desc: "Sync complete",
        //   onWillPopActive: true,
        //   buttons: [
        //     DialogButton(
        //       color: Constants.themeGradients[0],
        //       child: const Text(
        //         "OKAY",
        //         style: TextStyle(color: Colors.black, fontSize: 20),
        //       ),
        //       onPressed: () async {
        //         Navigator.pop(context, true);
        //       },
        //       width: 120,
        //     )
        //   ],
        // ).show();
        // await membershipNSUISuccessBottomSheet();

        Get.bottomSheet(Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24))),
            width: double.maxFinite,
            height: mediaQueryData.size.height * 0.45,
            child: Column(children: [
              Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      color: appTheme.indigo800,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
                  // decoration: AppDecoration.heading,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Member Submission",
                          style:
                              CustomTextStyles.titleMediumOnPrimaryContainer18),
                      AppbarImage1(
                        onTap: () {
                          Get.back();
                        },
                        svgPath: ImageConstant.imgEpcircleclose,
                      ),
                    ],
                  )),
              SizedBox(height: 33.v),
              CustomImageView(
                  svgPath: 'assets/nsui/svg/backtoprofile.svg',
                  height: 69.adaptSize,
                  width: 69.adaptSize),
              SizedBox(height: 15.v),
              Text("Thanks for the Submission",
                  style: theme.textTheme.titleLarge),
              Text("Member data wil be added to batch after verification",
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: Colors.blueAccent)),
              // Spacer(),
              SizedBox(height: 25.v),

              CustomElevatedButtonNSUI(
                
                  width: mediaQueryData.size.width * 0.7,
                  buttonStyle: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue)),
                  text: 'Back to Home',
                  onTap: Get.back),
              SizedBox(height: 25.v),
            ])));

        getMembershipList(context, membershipRequestList.first.batchId!,
            reload: true);
      } else {
        Navigator.of(context).pop();
        if ('${responseDecoded["response"]}'.contains('Aggregator')) {
          Get.find<AuthService>().forceLogout();
        }
        CustomSnackBar.showErrorSnackBar(
            responseDecoded["response"] ?? "Batch Sync Failed! Try Again");
      }
    } else {
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
  }

  Future<String> getAggrId(BuildContext context) async {
    showNetworkLoadingDialog(context,
        willPopScope: false, msg: 'Fetching aggr ID .....');
    ApiResponse apiResponse = await BatchRepo(dioClient: sl()).getAggrId();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        return responseDecoded["response"]["AGGR_ID"];
      } else {
        Navigator.of(context).pop(); // pop loading
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    } else {
      Navigator.of(context).pop(); // pop loading
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
    return 'true';
  }

  List<PrimaryMember> primaryMemberList = [];

  // BatchMember? batchMember;

  PrimaryMemberDB primaryMemberDB = sl<PrimaryMemberDB>();

  initiateSyncMembership(BuildContext context) async {
    Log.printDLog('initiateSyncMembership');
    if (_membershipRequestList.isEmpty) {
      CustomSnackBar.showErrorSnackBar('Add one member');
      return;
    }
    primaryMemberList = await primaryMemberDB
        .getDataByBatchId(_membershipRequestList.first.batchId!);

    if (membershipRequestList.isEmpty) {
      await Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR!",
        desc: "kindly add members before sync",
        onWillPopActive: true,
        buttons: [
          DialogButton(
            child: const Text(
              "OKAY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
            width: 120,
          )
        ],
      ).show();

      return false;
    }

    showNetworkLoadingDialog(context,
        willPopScope: false, msg: 'Uploading photo ....');
    await dobRange(context: context);
    if (_membershipRequestList
        .any((element) => element.tmpId!.startsWith("INC"))) {
      /// INC member directly sync
      Navigator.of(context).pop();

      /// pop initial loading dialog
      syncMembership(context);
    } else {
      // if(!await networkConfig!.isConnected) {
      //   return ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Please check your internet connection')));
      // }

      await s3uploadAllMemberImages();
      checkS3Upload(context);
    }
  }

  NetworkConfig? networkConfig;
  checkS3Upload(
    BuildContext context,
  ) async {
    // showNetworkLoadingDialog(context);
    var testJsonData = '''[{
    "V":"${AppConstants.membershipVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
    "MEMBER_ID":"${membershipRequestList.map((e) => e.memberId).reduce((value, element) => "$value , $element")}", 
    "ST_CODE":"${membershipRequestList.first.stateCode}",
    "CHANNEL":"M"
    }]''';
    ApiResponse apiResponse = await apiConfig!
        .postData(endpointUrl: Urls.checkS3Upload, jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();

        /// close loading
        await syncMembership(context);
      } else {
        Navigator.of(context).pop();

        /// close loading
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      update();
    } else {
      Navigator.of(context).pop();

      /// close loading error http
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
    }
  }

  s3uploadAllMemberImages() async {
    bool? returnValue;
    for (var member in _membershipRequestList) {
      final uploadResult = await Future.wait(
        [
          if (member.idDocumentFilePath != null &&
              member.idDocumentFilePath != '')
            uploadDocumentFrontImage(member),
          if (member.documentBackPath != null && member.documentBackPath != '')
            uploadDocumentBackImage(member),
          if (member.amPhotoFilePath != null && member.amPhotoFilePath != '')
            uploadDocumentAmPhoto(member),
          if (member.videoFilePath != null) uploadProfileVideo(member),
          //

          if (member.adhaarIdFrontPath != null &&
              member.adhaarIdFrontPath != '')
            uploadDocumentAAdharIDFrontImage(member),
          if (member.adhaarIdBackPath != null && member.adhaarIdBackPath != '')
            uploadDocumentAAdharIDBackImage(member)
        ],
      );
      if (uploadResult.contains(false)) {
        returnValue = false;
      } else if (returnValue == null || returnValue) {
        returnValue = true;
      }
    }
    return returnValue;
  }

  Future<bool> uploadDocumentFrontImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.idDocumentFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_D.${member.idDocumentFilePath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadDocumentAAdharIDFrontImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.adhaarIdFrontPath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_A.${member.adhaarIdFrontPath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadDocumentAAdharIDBackImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.adhaarIdBackPath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_A_BACK.${member.adhaarIdBackPath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadDocumentBackImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.documentBackPath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_D_BACK.${member.documentBackPath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadDocumentAmPhoto(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.amPhotoFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_P.${member.amPhotoFilePath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadProfileVideo(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.videoFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}.${member.videoFilePath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> dobRange({required BuildContext context}) async {
    bool dobRangeDone = false;

    var testJsonData = '''[{
    "STATE":${await LocalStorageServices().getSTCode()},
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}"}]''';

    ApiResponse apiResponse = await apiConfig!
        .postData(endpointUrl: Urls.DOBRange, jsonData: testJsonData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        DobRangeModel dobRangeModel = DobRangeModel.fromJson(responseDecoded);
        sl<SharedPreferences>()
            .setString("s3_access_token", dobRangeModel.response.s3Code!);
        sl<SharedPreferences>()
            .setString("s3_secret_key", dobRangeModel.response.s3Secret!);
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
