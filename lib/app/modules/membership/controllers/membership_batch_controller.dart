import 'dart:convert';

import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/app/modules/membership%202/controllers/membership_member_list_controller.dart';
import 'package:iyc/app/modules/membership%202/screens/membership_member_create_screen.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_download_model.dart';
import 'package:iyc/model/api_model/membership/membership_download.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/batch/batch_api_provider.dart';
import 'package:iyc/app/data/resources/repository/batch_repo.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

class MembershipBatchController extends GetxController {
  ApiConfig? apiConfig;
  bool loading = false;
  bool syncBatch = true;
  bool isFirstTimeMembership = true;

  List<BatchDataModel> _membershipBatchList = [];
  List<BatchDataModel> get membershipBatchList =>
      _membershipBatchList.reversed.toList();

  int totalCount = 0;
  int totalUnpaidAmCount = 0;
  int totalPaidAmCount = 0;

  BatchDBRepo batchDBRepo = BatchDBRepo(sl());

  @override
  void onInit() async {
    apiConfig = sl();
    loading = true;
    dobRange(context: Get.context!);
    isFirstTimeMembership = await checkIsFirstTime();
    loading = false;
    update();
    if (!isFirstTimeMembership) {
      isFirstTimeMembership = false;
      update();
      getMembershipBatchList(Get.context!);
    }
    await downloadMemberList(context: Get.context!);

    super.onInit();
  }

  // Map<String, Color> paymentStatusColor = {
  //   'PAID': Color(0xFF36B37E),
  //   'PENDING': Color(0xFFFFAB2A)
  // };

  Color paymentStatusColor(String status) {
    if (status == 'PAID') {
      return const Color(0xFF36B37E);
    }
    return const Color(0xFFFFAB2A);
  }

  bool onBackButton(BuildContext context) {
    Get.back();
    return true;
  }

  // void addBatch(BuildContext context) async { //old one
  //   loading = true;
  //   ProgressDialogUtils.showProgressIndicator();
  //   _membershipBatchList = await batchDBRepo.getData();
  //   if (_membershipBatchList.any((element) => element.syncStatus == "0")) {
  //     syncBatch = false;
  //   } else {
  //     syncBatch = true;
  //   }
  //   update();
  //   if (syncBatch) {
  //     await BatchApiProvider(batchRepo: sl()).addNewBatch().then((value) async {
  //       if (value.response != null && value.response!.statusCode == 200) {
  //         final responseDecoded =
  //         jsonDecode(utf8.decode(base64Decode(value.response!.data)));
  //         if (responseDecoded['status'] == "SUCCESS") {
  //           ///add batch new batch data to db

  //           await batchDBRepo.insertData(BatchDataModel(
  //               countAM: 0,
  //               batchId: responseDecoded['response']['BATCH_NO'],
  //               paymentStatus: "Pending",
  //               syncStatus: "0"));

  //           ///refresh batch list
  //           getMembershipBatchList(context);
  //           loading = false;
  //           Navigator.of(context).pop(); // loading dialog close

  //         } else {
  //           Navigator.of(context).pop(); // loading dialog close

  //           ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(content: Text(responseDecoded["response"])));
  //         }
  //       } else {
  //         Navigator.of(context).pop(); // loading dialog close

  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(SnackBar(content: Text(value.error.toString())));
  //       }
  //       loading = false;
  //       update();
  //     });
  //   } else {
  //     showErrorAlertBatch(context);
  //   }
  // }

  addBatch(BuildContext context) async {
    loading = true;
    // notifyListeners();
    showNetworkLoadingDialog(context);
    // _membershipBatchList = await sl<BatchDBRepo>().getData();

    // if (_membershipBatchList.any((element) => element.syncStatus == "0")) {
    //   syncBatch = false;
    // } else {
    //   syncBatch = true;
    // }
    // notifyListeners();
    if (syncBatch) {
      await BatchApiProvider(batchRepo: sl()).addNewBatch().then((value) async {
        if (value.response != null && value.response!.statusCode == 200) {
          final responseDecoded =
              jsonDecode(utf8.decode(base64Decode(value.response!.data)));
          if (responseDecoded['status'] == "SUCCESS") {
            ///add batch new batch data to db

            await sl<BatchDBRepo>().insertData(BatchDataModel(
                countAM: 0,
                batchId: responseDecoded['response']['BATCH_NO'],
                paymentStatus: "Pending",
                syncStatus: "0"));

            ///refresh batch list
            await getMembershipBatchList(context);
            //

            // context.read<MembersListVM>().clear();
            // final aggrId = await LocalStorageServices().getAgrIDMembership();
            // final stateCode = await LocalStorageServices().getSTCode();
            // final data = await Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context1) => MembershipMemberCreateScreen(
            //           member: BatchMember(
            //               memberId: (1).toString().length < 2
            //                   ? responseDecoded['response']['BATCH_NO'] +
            //                       "0" +
            //                       (1).toString().padLeft(1, "0")
            //                   : responseDecoded['response']['BATCH_NO'] +
            //                       "0" +
            //                       (1).toString(),
            //               batchId: responseDecoded['response']['BATCH_NO'],
            //               isSync: "0",
            //               aggrId: aggrId,
            //               stateCode: stateCode),
            //         )));
            Get.back();
            final aggrId = await LocalStorageServices().getAgrIDMembership();
            final stateCode = await LocalStorageServices().getSTCode();
            print((1).toString().length < 2
                ? responseDecoded['response']['BATCH_NO'] +
                    "0" +
                    (1).toString().padLeft(1, "0")
                : responseDecoded['response']['BATCH_NO'] +
                    "0" +
                    (1).toString());
            print(aggrId);
            print(stateCode);
            RoutesManagement.goToMembershipMemberCreateScreen(
              BatchMember(
                  memberId: (1).toString().length < 2
                      ? responseDecoded['response']['BATCH_NO'] +
                          "0" +
                          (1).toString().padLeft(1, "0")
                      : responseDecoded['response']['BATCH_NO'] +
                          "0" +
                          (1).toString(),
                  batchId: responseDecoded['response']['BATCH_NO'],
                  isSync: "0",
                  aggrId: aggrId,
                  stateCode: stateCode),
              isUpdate: false,
              isLegalCell:
                  false, // Explicitly passing these ensures the array is fully populated
              isUpdateToDB: false,
            );
            // Get.put(MembershipMemberListController());
            await Future.delayed(const Duration(seconds: 2));
            // if (data.toString().toLowerCase().contains('completed')) {
            //   await Future.delayed(const Duration(seconds: 2));

            //   Get.find<MembershipMemberListController>()
            //       .initiateSyncMembership(context);
            // } else {
            //   Get.find<MembershipMemberListController>().getMembershipList(
            //       context, responseDecoded['response']['BATCH_NO']);
            //   // Get.find<MembershipMemberListController>().manualSync(context);
            await downloadExistingBatch(context: context);
            await downloadMemberList(context: context);
            //   // Navigator.of(context).pop();
            // }
            //

            // Navigator.of(context).pop(); // loading dialog close
          } else {
            // Navigator.of(context).pop(); // loading dialog close

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(responseDecoded["response"])));
          }
        } else {
          // Navigator.of(context).pop(); // loading dialog close

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.error.toString())));
        }
        loading = false;
        update();
      });
    } else {
      // Navigator.of(context).pop();
      showErrorAlertBatch(context);
    }
    // Navigator.of(context).pop();
    loading = false;
    update();
  }

  List<BatchMember>? memberList = [];
  List<BatchMember>? filtermemberList = [];
  MembershipRepo membershipRepo = MembershipRepo(dioClient: sl());

  Future<bool> downloadMemberList({
    //new one
    required BuildContext context,
  }) async {
    bool returnValue = false;
    ApiResponse apiResponse = await membershipRepo.downloadMembersNew('');
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        /// add api membership data to local db
        MembershipDownloadResponse memberData =
            MembershipDownloadResponse.fromJson(responseDecoded);
        memberList = memberData.response.batchMember!;
        for (var item in memberList!) {
          item.isSync = "1"; // or true / any value you want
        }
        // log(_membershipRequestList.length.toString());
        filtermemberList = memberList!.reversed.toList();
        update();

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

  getMembershipBatchList(BuildContext context, {bool? reload}) async {
    loading = true;
    if (reload != null && reload) {
      update();
    }
    _membershipBatchList = await batchDBRepo.getData();
    totalCount = await countAm();
    totalUnpaidAmCount = await countAmUnPaid(_membershipBatchList);
    totalPaidAmCount = totalCount - totalUnpaidAmCount;
    Log.printILog(totalUnpaidAmCount);
    loading = false;
    update();
  }

  Future<int> countAm() async {
    var sum = 0;
    sum = _membershipBatchList.fold(0, (sum, element) => sum + element.countAM);
    Log.printILog("sum by reduce is : $sum");
    return sum;
  }

  Future<int> countAmUnPaid(List<BatchDataModel> batchDtaList) async {
    var sum = 0;
    sum = _membershipBatchList.fold(
        0,
        (sum, element) =>
            sum + (element.paymentStatus != "PAID" ? element.countAM : 0));
    print("sum by reduce is : $sum");
    return sum;
  }

  Future<bool> dobRange({required BuildContext context}) async {
    bool dobRangeDone = false;

    var testJsonData = '''[{
    "STATE":"${await LocalStorageServices().getSTCode()}",
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}"}]''';

    ApiResponse apiResponse = await apiConfig!
        .postData(endpointUrl: Urls.DOBRange, jsonData: testJsonData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        DobRangeModel dobRangeModel = DobRangeModel.fromJson(responseDecoded);
        await LocalStorageServices()
            .setDobStartRange(dobRangeModel.response.dobstartrange!);
        await LocalStorageServices()
            .setDobEndRange(dobRangeModel.response.dobendrange!);
        dobRangeDone = true;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
    }
    return dobRangeDone;
  }

  void updateAMCount(
      {required BuildContext context, required BatchDataModel data}) async {
    await batchDBRepo.updateAMCount(data);
    loading = false;
    update();
  }

  void showErrorAlertBatch(BuildContext context) {
    Navigator.pop(context);
    loading = false;
    update();
    showDialog(
        context: context,
        builder: (newContext) => AlertDialog(
              title: const Text("Batch already exists!!"),
              content: const Text(
                  "Kindly sync existing batch before creating a new one"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"))
              ],
            ));
  }

  Future<bool> checkIsFirstTime() async {
    final result = await LocalStorageServices().getInitMemberStatus();
    return result == "false" ? false : true;
  }

  Future<bool> getAggrId(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    ApiResponse apiResponse = await BatchRepo(dioClient: sl()).getAggrId();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        await LocalStorageServices()
            .setAggrIDForMembership(responseDecoded["response"]["AGGR_ID"]);
        await LocalStorageServices().setInitMemberStatus("false");
        isFirstTimeMembership = false;
        update();
        Navigator.of(context).pop(); // pop loading
      } else {
        Navigator.of(context).pop(); // pop loading
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    } else {
      Navigator.of(context).pop(); // pop loading
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
    return true;
  }

  downloadExistingBatch({
    required BuildContext context,
  }) async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await sl<BatchRepo>().downloadExistingBatch();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        BatchDownloadResponse batchDownloadResponse =
            BatchDownloadResponse.fromJson(responseDecoded);

        List<BatchDataModel> _membershipBatchList = await batchDBRepo.getData();

        /// add to batch list db
        await Future.forEach(batchDownloadResponse.response.batches,
            (element) async {
          element as Batch;
          if (_membershipBatchList
              .any((dbBatch) => element.batchNo == dbBatch.batchId)) {
            await batchDBRepo.updateData(
              BatchDataModel(
                  countAM: int.parse(element.totalAm!),
                  batchId: element.batchNo!,
                  districtCode: element.districtCode,
                  stateCode: element.stateCode,
                  paymentStatus: element.paymentStatus == null
                      ? "Pending"
                      : element.paymentStatus == "PAID"
                          ? element.paymentStatus
                          : "Pending",
                  syncStatus: "1"),
            );
          } else {
            await batchDBRepo.insertData(
              BatchDataModel(
                  countAM: int.parse(element.totalAm!),
                  batchId: element.batchNo!,
                  districtCode: element.districtCode,
                  stateCode: element.stateCode,
                  paymentStatus: element.paymentStatus == null
                      ? "Pending"
                      : element.paymentStatus == "PAID"
                          ? element.paymentStatus
                          : "Pending",
                  syncStatus: "1"),
            );
          }
        });

        /// to refresh batch list
        await getMembershipBatchList(context);
        ProgressDialogUtils.closeDialog();
      } else {
        ProgressDialogUtils.closeDialog();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      update();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }
}
