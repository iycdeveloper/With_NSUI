import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/batch_repo.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/helper/location_helper.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/api_model/membership/membership_download.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/primary_member.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/primary_member_db.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/ui/members/member_page.dart';
import 'package:iyc/screens/ui/membership_ui/membership.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/members/member_page_vm.dart';
import 'package:iyc/view_model/members/widgets/show_sync_bottom_sheet.dart';
import 'package:iyc/view_model/membership/membership_vm.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di_container.dart';

class MembersListVM extends ChangeNotifier {
  final ApiConfig apiConfig;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  MembersListVM({required this.apiConfig});

  MembershipRepo membershipRepo = MembershipRepo(dioClient: sl());

  final MembershipMemberDB membershipDbRepo = sl<MembershipMemberDB>();

  List<BatchMember> _membershipRequestList = [];

  List<BatchMember> get membershipRequestList => _membershipRequestList;
  bool loadingPage = false;
  bool isLoadingIncUser = false;
  bool showAddOption = true;
  bool isSyncMembers = false;
  bool isautoSync = false;

  setautoSync() {
    isautoSync = true;
    ChangeNotifier();
  }

  manualSync(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!isautoSync && membershipRequestList.isNotEmpty) {
      if (membershipRequestList[0].isSync == "0") {
        // final result=showSyncBottomSheet(context);
      //  final result =  showModalBottomSheet(
      //       context: Get.context!,
      //       isDismissible: false,
      //       // useSafeArea: false,
      //       enableDrag: false,
      //       useRootNavigator: true,
      //       isScrollControlled: true,
      //       builder: (BuildContext context) {
      //         return InteractiveViewer(
      //           child: Container(
      //               margin: const EdgeInsets.only(top: 100),
      //               decoration: const BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.only(
      //                       topLeft: Radius.circular(24),
      //                       topRight: Radius.circular(24))),
      //               width: double.maxFinite,
      //               height: double.maxFinite,
      //               child: ListView(children: [
      //                 Container(
      //                     decoration: BoxDecoration(
      //                         // color: Colors.white,
      //                         color: appTheme.indigo800,
      //                         borderRadius: const BorderRadius.only(
      //                             topLeft: Radius.circular(24),
      //                             topRight: Radius.circular(24))),
      //                     width: double.maxFinite,
      //                     padding: EdgeInsets.symmetric(
      //                         horizontal: 20.h, vertical: 17.v),
      //                     child: Text(
      //                       'title',
      //                     )),

                      

      //                 //below one is old
      //                 // CustomImageView(
      //                 //   url: url,
      //                 //   // color: Colors.black,
      //                 // ),
      //                 SizedBox(height: 15.v),
      //                 CustomOutlinedButton(
      //                     width: 220.h,
      //                     height: 40.h,
      //                     text: "Back".toUpperCase(),
      //                     buttonStyle: CustomButtonStyles.outlinePrimary,
      //                     onTap: (){
      //                       Navigator.pop(context, true);
      //                     }),
      //                 SizedBox(height: 5.v)
      //               ])),
      //         );
      //       },
      //     );
        final result = await Alert(
          context: context,
          type: AlertType.warning,
          style: const AlertStyle(
            backgroundColor: Color(0xff57b5eb),
            // descStyle: theme.textTheme.displayMedium!
            //     .copyWith(color: Colors.white, fontWeight: FontWeight.w400),

            // isCloseButton: true
          ),
          title: "Alert",
          desc: "Click on Ok to Sync the Data",
          buttons: [
            DialogButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context, false);
              },
              width: 120,
            ),
            DialogButton(
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context, true);
              },
              width: 120,
            )
          ],
        ).show();
        if (result == null) {
          final data = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (context) => MembershipVM(),
                  child: MemberShip(
                    member: membershipRequestList[0],
                    isUpdate: true,
                  ))));
          getMembershipList(context, membershipRequestList[0].batchId!);
          if (data.toString().toLowerCase().contains('completed')) {
            setautoSync();
            getVerificationBottomSheet(context);
            // initiateSyncMembership(context);
          } else {
            getMembershipList(context, membershipRequestList[0].batchId!);
            context.read<MembersListVM>().manualSync(context);
          }
        } else if (result) {
          getVerificationBottomSheet(context);

          // initiateSyncMembership(context);
        } else {
          final data = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                  create: (context) => MembershipVM(),
                  child: MemberShip(
                    member: membershipRequestList[0],
                    isUpdate: true,
                  ))));
          getMembershipList(context, membershipRequestList[0].batchId!);
          if (data.toString().toLowerCase().contains('completed')) {
            setautoSync();
            getVerificationBottomSheet(context);
            // initiateSyncMembership(context);
          } else {
            getMembershipList(context, membershipRequestList[0].batchId!);
            context.read<MembersListVM>().manualSync(context);
          }
        }
      }
    }
  }

  getVerificationBottomSheet(BuildContext context) {
    TextEditingController sumController = TextEditingController();
    var random = math.Random();
    int randomNumber1 = random.nextInt(98) + 1;
    int randomNumber2 = random.nextInt(98) + 1;
    mediaQueryData = MediaQuery.of(context);
    Get.bottomSheet(
      Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24))),
          width: double.maxFinite,
          height: 372.v,
          child: SingleChildScrollView(
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
                      Text("Verification",
                          style:
                              CustomTextStyles.titleMediumOnPrimaryContainer18),
                      // AppbarImage1(
                      //   onTap: () {
                      //     Get.back();
                      //   },
                      //   svgPath: ImageConstant.imgEpcircleclose,
                      // ),
                      const SizedBox()
                    ],
                  )),
              SizedBox(height: 33.v),
              CustomImageView(
                  svgPath: ImageConstant.imgTrash,
                  height: 69.adaptSize,
                  width: 69.adaptSize),
              SizedBox(height: 25.v),
              Text("$randomNumber1 + $randomNumber2 = ?",
                  style: theme.textTheme.titleLarge),
              SizedBox(height: 9.v),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: sumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter sum of above number',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Circular border
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.v),
              CustomOutlinedButton(
                  width: 220.h,
                  text: "Submit".toUpperCase(),
                  buttonStyle: CustomButtonStyles.outlinePrimary,
                  onTap: () {
                    if (sumController.text.isEmpty) {
                      // CustomSnackBar.showErrorSnackBar('Verification failed');
                      // Get.back();
                      Navigator.pop(context, false);
                    }
                    if (randomNumber1 + randomNumber2 ==
                        int.parse(sumController.text)) {
                      // Get.back();
                      Navigator.pop(context, true);
                      initiateSyncMembership(context);
                    } else {
                      // Get.back();
                      Navigator.pop(context, false);
                      // getVerificationBottomSheet(context);

                      // Get.back();
                    }
                  }),
              SizedBox(height: 5.v)
            ]),
          )),
    ).then((value) async {
      if (value == null) {
        Get.back();
        // getVerificationBottomSheet(context);
      } else if (value == false) {
        CustomSnackBar.showErrorSnackBar('Verification failed try again');
        await Future.delayed(const Duration(seconds: 2));
        getVerificationBottomSheet(context);
      } else {}
    });
  }

  getMembershipList(BuildContext context, String batchId,
      {bool? reload}) async {
    print('test2q12');
    if (reload != null && reload) {
      loadingPage = true;
      notifyListeners();
      _membershipRequestList = await membershipDbRepo.getData(batchId);
      if (_membershipRequestList.any((element) => element.isIncMember!) ||
          _membershipRequestList.length > 1) {
        showAddOption = false;
      }
      loadingPage = false;
      print("membershiplenght1:" + _membershipRequestList.length.toString());
      notifyListeners();
      return true;
    }

    loadingPage = true;
    await agrDownloadMembers(context: context, batchId: batchId);
    _membershipRequestList = await membershipDbRepo.getData(batchId);
    if (_membershipRequestList.any((element) => element.isIncMember!) ||
        _membershipRequestList.length > 1) {
      showAddOption = false;
    }
    print("membershiplenght2:" + _membershipRequestList.length.toString());

    loadingPage = false;
    notifyListeners();
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
      notifyListeners();
    } else {
      //  Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      returnValue = false;
    }

    return returnValue;
  }

  syncMembership(
    BuildContext context,
  ) async {
    var aggrId = await LocalStorageServices().getAgrIDMembership();
    if (aggrId.isEmpty) {
      CustomSnackBar.showErrorSnackBar('Something went wrong');
      aggrId = await getAggrId(context);
    }
    var memberData = [];
    for (var i in membershipRequestList) {
      memberData.add(jsonEncode(i));
    }
    for (var i in primaryMemberList) {
      var mapValue = i.toJson(i);
      mapValue.remove('MOBILE');
      mapValue.remove('ID');
      mapValue['MOBILE1'] = i.mobile;
      mapValue['ID_VALUE'] = i.idCardNumber;
      memberData.add(jsonEncode(mapValue));
    }
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
    log(testJsonData.toString());

    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.syncMembership, jsonData: testJsonData);
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
        notifyListeners();
        Navigator.of(context).pop();

        /// close loading

        await Alert(
          context: context,
          style: const AlertStyle(backgroundColor: Colors.white),
          type: AlertType.success,
          title: "SUCCESS",
          desc: "Sync complete",
          onWillPopActive: true,
          buttons: [
            DialogButton(
              color: Constants.themeGradients[0],
              child: const Text(
                "OKAY",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context, true);
              },
              width: 120,
            )
          ],
        ).show();

        getMembershipList(context, membershipRequestList.first.batchId!,
            reload: true);
      } else {
        Navigator.of(context).pop();
        if ('${responseDecoded["response"]}'.contains('Aggregator')) {
          Get.find<AuthService>().forceLogout();
        }
        Get.back();
        CustomSnackBar.showErrorSnackBar(
            responseDecoded["response"] ?? "Batch Sync Failed! Try Again");
      }
    } else {
      Navigator.of(context).pop();
      Get.back();
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
    // if (_membershipRequestList.isEmpty) {
    //   CustomSnackBar.showErrorSnackBar('Add one member');
    //   return;
    // }
    primaryMemberList = await primaryMemberDB
        .getDataByBatchId(_membershipRequestList.first.batchId!);

    if (membershipRequestList.isEmpty) {
      await Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR!",
        desc: "kindly add members before sync",
        style: const AlertStyle(backgroundColor: Colors.white),
        onWillPopActive: true,
        buttons: [
          DialogButton(
            color: Constants.themeGradients[0],
            child: const Text(
              "OKAY",
              style: TextStyle(color: Colors.black, fontSize: 20),
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
      bool? result = await s3uploadAllMemberImages();
      if (result == false) {
        Navigator.of(context).pop();
        await Alert(
          context: context,
          type: AlertType.error,
          title: "ERROR!",
          desc: "kindly Reupload the images and videos",
          style: const AlertStyle(backgroundColor: Colors.white),
          onWillPopActive: true,
          buttons: [
            DialogButton(
              color: Constants.themeGradients[0],
              child: const Text(
                "OKAY",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
              width: 120,
            )
          ],
        ).show();
      } else {
        checkS3Upload(context);
      }
    }
  }

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
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.checkS3Upload, jsonData: testJsonData);
    log(apiResponse.response.toString());
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
      notifyListeners();
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
          if (member.videoFilePath != null && member.videoFilePath != '')
            uploadProfileVideo(member),
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

  Future<bool> uploadDocumentAAdharIDFrontImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.adhaarIdFrontPath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_A.${member.adhaarIdFrontPath?.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> uploadDocumentAAdharIDBackImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.adhaarIdBackPath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_A_BACK.${member.adhaarIdBackPath?.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> uploadDocumentFrontImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.idDocumentFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_D.${member.idDocumentFilePath?.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> uploadDocumentBackImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.documentBackPath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_D_BACK.${member.documentBackPath?.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> uploadDocumentAmPhoto(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.amPhotoFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_P.${member.amPhotoFilePath?.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> uploadProfileVideo(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.videoFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}.${member.videoFilePath?.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> dobRange({required BuildContext context}) async {
    bool dobRangeDone = false;

    var testJsonData = '''[{
    "STATE":${await LocalStorageServices().getSTCode()},
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}"}]''';

    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.DOBRange, jsonData: testJsonData);
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
