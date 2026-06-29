import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_download_model.dart';
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

    super.onInit();
  }

  // Map<String, Color> paymentStatusColor = {
  //   'PAID': Color(0xFF36B37E),
  //   'PENDING': Color(0xFFFFAB2A)
  // };

  Color paymentStatusColor(String status) {
    if (status == 'PAID') {
      return Color(0xFF36B37E);
    }
    return Color(0xFFFFAB2A);
  }

  bool onBackButton(BuildContext context) {
    Get.back();
    return true;
  }

  void addBatch(BuildContext context) async {
    loading = true;
    ProgressDialogUtils.showProgressIndicator();
    // _membershipBatchList= await batchDBRepo.getData();
    if (_membershipBatchList.any((element) => element.syncStatus == "0")) {
      syncBatch = false;
    } else {
      syncBatch = true;
    }
    update();
    if (syncBatch) {
      await BatchApiProvider(batchRepo: sl()).addNewBatch().then((value) async {
        if (value.response != null && value.response!.statusCode == 200) {
          final responseDecoded =
              jsonDecode(utf8.decode(base64Decode(value.response!.data)));
          if (responseDecoded['status'] == "SUCCESS") {
            ///add batch new batch data to db

            // await batchDBRepo.insertData(BatchDataModel(
            //     countAM: 0,
            //     batchId: responseDecoded['response']['BATCH_NO'],
            //     paymentStatus: "Pending",
            //     syncStatus: "0"));

            ///refresh batch list
            getMembershipBatchList(context);
            _membershipBatchList[_membershipBatchList.length - 1] =
                BatchDataModel(
                    countAM: 0,
                    batchId: responseDecoded['response']['BATCH_NO'],
                    paymentStatus: "Pending",
                    syncStatus: "0");

            print(_membershipBatchList[_membershipBatchList.length - 1]
                .toString());
            loading = false;
            update();
            Navigator.of(context).pop(); // loading dialog close
          } else {
            Navigator.of(context).pop(); // loading dialog close

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(responseDecoded["response"])));
          }
        } else {
          Navigator.of(context).pop(); // loading dialog close

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.error.toString())));
        }
        loading = false;
        update();
      });
    } else {
      showErrorAlertBatch(context);
    }
  }

  getMembershipBatchList(BuildContext context, {bool? reload}) async {
    loading = true;
    if (reload != null && reload) {
      update();
    }
    downloadExistingBatch(context: context);
    // _membershipBatchList = await batchDBRepo.getData();
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
              title: Text("Batch already exists!!"),
              content:
                  Text("Kindly sync existing batch before creating a new one"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"))
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
        builder: (context) => Center(child: CircularProgressIndicator()));
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

  MembershipRepo membershipRepo = MembershipRepo(dioClient: sl());

  Future<bool> getMembersbybatch(String batchId) async {
    ApiResponse apiResponse = await membershipRepo.downloadMembers(batchId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void downloadExistingBatch({
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

        // List<BatchDataModel> _membershipBatchList = await batchDBRepo.getData();

        /// add to batch list db
        await Future.forEach(batchDownloadResponse.response.batches,
            (element) async {
          _membershipBatchList.add(
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
                syncStatus: true == await getMembersbybatch(element.batchNo!)
                    ? '1'
                    : '0'),
          );
          // element as Batch;
          // if (_membershipBatchList
          //     .any((dbBatch) => element.batchNo == dbBatch.batchId)) {
          //   await batchDBRepo.updateData(
          //     BatchDataModel(
          //         countAM: int.parse(element.totalAm!),
          //         batchId: element.batchNo!,
          //         districtCode: element.districtCode,
          //         stateCode: element.stateCode,
          //         paymentStatus: element.paymentStatus == null
          //             ? "Pending"
          //             : element.paymentStatus == "PAID"
          //                 ? element.paymentStatus
          //                 : "Pending",
          //         syncStatus: "1"),
          //   );
          // } else {
          //   await batchDBRepo.insertData(
          //     BatchDataModel(
          //         countAM: int.parse(element.totalAm!),
          //         batchId: element.batchNo!,
          //         districtCode: element.districtCode,
          //         stateCode: element.stateCode,
          //         paymentStatus: element.paymentStatus == null
          //             ? "Pending"
          //             : element.paymentStatus == "PAID"
          //                 ? element.paymentStatus
          //                 : "Pending",
          //         syncStatus: "1"),
          //   );
          // }
        });

        /// to refresh batch list
        // await getMembershipBatchList(context);
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
