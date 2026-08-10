import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/membership/membership_download.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/app/data/resources/db_provider/scrutiny/scrutiny_members_db_repo.dart';
import 'package:iyc/app/data/resources/repository/scrutiny_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/screens/ui/membership_ui/batch/batch_main.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../di_container.dart';

class ScrutinyMembersListVM extends ChangeNotifier {
  final ScrutinyRepo scrutinyRepo;
  ScrutinyMembershipDBRepo _scrutinyMembershipDBRepo =
      sl<ScrutinyMembershipDBRepo>();

  ScrutinyMembersListVM({required this.scrutinyRepo});

  List<BatchMember> _scrutinyBatchMembersList = [];

  List<BatchMember> get scrutinyMemberstList => _scrutinyBatchMembersList;
  bool loading = true;

  Future<bool> willPopCallback(BuildContext context, String batchId) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BatchMain()));
    return true;
  }

  Future<bool> scrutinyDownloadBatchMembers({
    required BuildContext context,
    required String batchId,
  }) async {
    bool returnValue = false;
    await getScrutinyMembersList(context, batchId);
    ApiResponse apiResponse = await scrutinyRepo.downloadAM(batchId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      log(responseDecoded.toString());
      if (responseDecoded['status'] == "SUCCESS") {
        /// add api membership data to local db
        MembershipDownloadResponse memberData =
            MembershipDownloadResponse.fromJsonforScrutiny(responseDecoded);

        final alreadyExist = _scrutinyBatchMembersList.any((dbMember) =>
            memberData.response.batchMember!.first.batchId == dbMember.batchId);
        if (alreadyExist) {
          /// member id already exit no changes
        } else {
          memberData.response.batchMember!.forEach((element) async {
            await _scrutinyMembershipDBRepo.insertData(element);
          });
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
        await getScrutinyMembersList(context, batchId);
      } else {
        //  Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
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

  Future<void> getScrutinyMembersList(
      BuildContext context, String batchId) async {
    _scrutinyBatchMembersList =
        await _scrutinyMembershipDBRepo.getData(batchId);
    loading = false;
    notifyListeners();
  }

  checkScrutinyListSynced() {
    if (_scrutinyBatchMembersList
        .any((element) => element.isEditedScrutiny == "1")) {
      return _scrutinyBatchMembersList.every((element) =>
          (element.isEditedScrutiny == "1" && element.isSync == "1"));
    }
    return true;
  }

  checkScrutinyMembersEdited() {
    if (_scrutinyBatchMembersList
        .where((element) => element.isEditedScrutiny == "1")
        .toList()
        .isEmpty) {
      return false; // no list in db is edited
    }
    return true; //  scrutiny list edited and saved in db
  }

  syncScrutinyBatch(BuildContext context) async {
    if (!checkScrutinyMembersEdited()) {
      showCustomSnackBar("Edit Member details before sync", context);
      return; // no scrutiny edited close execution;
    }
    showNetworkLoadingDialog(context, willPopScope: false);
    List<BatchMember> scrutinySyncMembersList = [];

    // await dobRange(context: context);
    await s3uploadAllMemberImages(_scrutinyBatchMembersList
        .where((element) => element.isEditedScrutiny == "1")
        .toList()
        .where((element) => element.scrutinyCode!.contains("2"))
        .toList());
    for (int a = 0; a < scrutinyMemberstList.length; a++) {
      if (scrutinyMemberstList[a].isEditedScrutiny == "1") {
        if (scrutinyMemberstList[a].scrutinyCode!.contains(";")) {
          /// need to create multiple member data
          var listScrutinyCode =
              scrutinyMemberstList[a].scrutinyCode!.split(";");
          listScrutinyCode.removeWhere((e) => e == "");
          for (int i = 0; i < listScrutinyCode.length; i++) {
            var member = scrutinyMemberstList[a].copyWith();
            member.scrutinyCode = listScrutinyCode[i];

            scrutinySyncMembersList.add(member);
          }
        } else {
          scrutinySyncMembersList.add(scrutinyMemberstList[a]);
        }
      }
    }

    print(scrutinySyncMembersList.first.scrutinyCode);
    print(scrutinySyncMembersList.last.scrutinyCode);
    print(scrutinySyncMembersList.length);
    if (scrutinySyncMembersList.isNotEmpty) {
      ApiResponse apiResponse =
          await scrutinyRepo.syncBatch(membersList: scrutinySyncMembersList);

      print(apiResponse.response!.statusCode);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
        print(responseDecoded);
        if (responseDecoded['status'] == "SUCCESS") {
          Navigator.of(context).pop();
          await Alert(
            context: context,
            type: AlertType.success,
            title: "SUCCESS",
            desc: "Sync complete",
            style: const AlertStyle(backgroundColor: Colors.white),
            onWillPopActive: true,
            closeFunction: () async {
              ///update db status
              scrutinyMemberstList.forEach((element) async {
                if (element.isEditedScrutiny == "1") {
                  element.isSync = "1";
                }

                await _scrutinyMembershipDBRepo.updateMembershipTable(element);
              });
              Navigator.pop(context);
            },
            buttons: [
              DialogButton(
                color: Constants.themeGradients[0],
                child: Text(
                  "OKAY",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () async {
                  ///update db status
                  scrutinyMemberstList.forEach((element) async {
                    if (element.isEditedScrutiny == "1") {
                      element.isSync = "1";
                    }

                    await _scrutinyMembershipDBRepo
                        .updateMembershipTable(element);
                  });
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
        } else {
          await Alert(
            context: context,
            type: AlertType.error,
            title: "Error!",
            desc: responseDecoded["response"] ?? "Error!",
            buttons: [
              DialogButton(
                child: Text(
                  "OKAY",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
          Navigator.of(context).pop();
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Up to date")));
    }
    loading = false;
    notifyListeners();
  }

  // checkS3Upload(
  //   BuildContext context,
  // ) async {
  //   // showNetworkLoadingDialog(context);
  //   var testJsonData = '''[{
  //   "MEMBER_ID":"${_scrutinyBatchMembersList.map((e) => e.memberId).reduce((value, element) => "$value , $element")}",
  //   "ST_CODE":"${_scrutinyBatchMembersList.first.stateCode}",
  //   "CHANNEL":"M",
  //   "V":"${AppConstants.membershipVersion}",
  //   "DEVICE_ID":"c9f13fa9-f4ad-443e-965f-394064716da5"}]''';
  //   ApiResponse apiResponse = await apiConfig.postData(
  //       endpointUrl: Urls.checkS3Upload, jsonData: testJsonData);
  //
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     final responseDecoded =
  //         jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
  //     print(responseDecoded);
  //     if (responseDecoded['status'] == "SUCCESS") {
  //       Navigator.of(context).pop();
  //       await syncMembership(context);
  //     } else {
  //       Navigator.of(context).pop();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
  //     }
  //     notifyListeners();
  //   } else {
  //     Navigator.of(context).pop();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(apiResponse.error.message.toString())));
  //   }
  // }

  s3uploadAllMemberImages(List<BatchMember> scrutinyBatchMembersList) async {
    bool? returnValue;
    if (scrutinyMemberstList.isEmpty) {
      return false;
    }
    for (var member in scrutinyBatchMembersList) {
      final uploadResult = await Future.wait(
        [
          if (member.idDocumentFilePath != null) ...[
            if (!member.idDocumentFilePath!.contains('http'))
              uploadDocumentFrontImage(member),
          ],
          if (member.documentBackPath != null) ...[
            if (!member.documentBackPath!.contains('http'))
              uploadDocumentBackImage(member),
          ],
          if (member.amPhotoFilePath != null) ...[
            if (!member.amPhotoFilePath!.contains('http'))
              uploadDocumentAmPhoto(member),
          ],
          if (member.videoFilePath != null) ...[
            if (!member.videoFilePath!.contains('http'))
              uploadProfileVideo(member),
          ],
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
        destDir: "NSUI/SCRUTINY/${member.stateCode}/OM/${member.memberId}",
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
        destDir: "NSUI/SCRUTINY/${member.stateCode}/OM/${member.memberId}",
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
        destDir: "NSUI/SCRUTINY/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_P.${member.amPhotoFilePath?.split(".").last}");
    Log.printDLog(result);
    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> uploadProfileVideo(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(member.videoFilePath!),
        destDir: "NSUI/SCRUTINY/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}.${member.videoFilePath?.split(".").last}");

    if (result is String)
      return true;
    else
      return false;
  }

  Future<bool> dobRange({required BuildContext context}) async {
    bool dobRangeDone = false;

    ApiResponse apiResponse = await scrutinyRepo.getDobRange();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
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
