import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/api_model/batch/batch_download_model.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/repository/batch_repo.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';

import '../../di_container.dart';
import '../../utils/app_constants.dart';
import 'batch_api_provider.dart';

class BatchListProvider extends ChangeNotifier {
  final ApiConfig apiConfig;

  BatchListProvider({required this.apiConfig});

  bool loading = false;
  bool syncBatch = true;

  bool isFirstTimeMembership = true;

  List<BatchDataModel> _membershipBatchList = [];

  List<BatchDataModel> get membershipBatchList => _membershipBatchList;

  int totalCount = 0;
  int totalUnpaidAmCount = 0;
  int totalPaidAmCount = 0;

  ///----------------------------------
  onBackButton(BuildContext context) {
    // toPushNamedAndRemoveUntil(context: context, widgetName: '/');
    Navigator.of(context).pop();
    return true;
  }

  addBatch(BuildContext context) async {
    loading = true;
    // notifyListeners();
    showNetworkLoadingDialog(context);
    _membershipBatchList = await sl<BatchDBRepo>().getData();

    if (_membershipBatchList.any((element) => element.syncStatus == "0")) {
      syncBatch = false;
    } else {
      syncBatch = true;
    }
    notifyListeners();
    if (syncBatch) {
      // ApiResponse apiResponse = await BannerRepo().checkBannerAccess();
      // if (apiResponse.response != null &&
      //     apiResponse.response!.statusCode == 200) {
      //   final responseDecoded =
      //       jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      //   print(responseDecoded);
      //   if (responseDecoded['status'] == "SUCCESS") {
      //     //    Navigator.of(context).pop(); // loading dialog
      //
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text(responseDecoded['response'])));
      //     notifyListeners();
      //   } else {
      //     // Navigator.of(context).pop();
      //
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text(responseDecoded['response'])));
      //   }
      // }
      // final result = await toPage(
      //     context,
      //     ChangeNotifierProvider(
      //       create: (_) => BannerPageVM(),
      //       child: BannerPage(),
      //     ));
      //
      // print(result);
      // if (result == null) {
      //   Navigator.of(context).pop();
      //   loading = false;
      //   notifyListeners();
      //   return;
      // }

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
            getMembershipBatchList(context);
            loading = false;
            Navigator.of(context).pop(); // loading dialog close
            // ///navigate to membership form
            //  toPage(
            //     context,
            //     MembershipMain(
            //       batchId: responseDecoded['response']['BATCH_NO'],
            //       syncStatus: false,
            //     ));
            /// create new membership
            // await Provider.of<RegPersonProvider>(context, listen: false)
            //     .addPersonDetails(
            //         context, responseDecoded['response']['BATCH_NO']);

            ///navigate to membership form
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => MembershipRegisterHomePage(
            //       batchId:responseDecoded['response']['BATCH_NO'],
            //       editMode: false,
            //     )));
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
        notifyListeners();
      });
    } else {
      showErrorAlertBatch(context);
    }
  }

  getMembershipBatchList(BuildContext context, {bool? reload}) async {
    loading = true;
    if (reload != null && reload) {
      notifyListeners();
    }
    _membershipBatchList = await sl<BatchDBRepo>().getData();
    totalCount = await countAm();
    totalUnpaidAmCount = await countAmUnPaid(_membershipBatchList);
    totalPaidAmCount = totalCount - totalUnpaidAmCount;
    print(totalUnpaidAmCount);
    loading = false;
    notifyListeners();
  }

  countAm() async {
    var sum = 0;
    sum = _membershipBatchList.fold(0, (sum, element) => sum + element.countAM);
    print("sum by reduce is : $sum");
    return sum;
  }

  countAmUnPaid(List<BatchDataModel> batchDtaList) async {
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

    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.DOBRange, jsonData: testJsonData);
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

  updateAMCount(
      {required BuildContext context, required BatchDataModel data}) async {
    await sl<BatchDBRepo>().updateAMCount(data);
    loading = false;
    notifyListeners();
  }

  showErrorAlertBatch(BuildContext context) {
    Navigator.pop(context);
    loading = false;
    notifyListeners();
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

  checkIsFirstTime() async {
    final result = await LocalStorageServices().getInitMemberStatus();
    return result == "false" ? false : true;
  }

  getAggrId(BuildContext context) async {
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
        notifyListeners();
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

  initialize(BuildContext context) async {
    loading = true;
    dobRange(context: context);

    isFirstTimeMembership = await checkIsFirstTime();

    loading = false;
    notifyListeners();

    if (!isFirstTimeMembership) {
      isFirstTimeMembership = false;
      notifyListeners();
      getMembershipBatchList(context);
    }
  }

  void downloadExistingBatch({
    required BuildContext context,
  }) async {
    showNetworkLoadingDialog(context, willPopScope: false);
    ApiResponse apiResponse = await sl<BatchRepo>().downloadExistingBatch();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        BatchDownloadResponse batchDownloadResponse =
            BatchDownloadResponse.fromJson(responseDecoded);

        List<BatchDataModel> _membershipBatchList =
            await sl<BatchDBRepo>().getData();

        /// add to batch list db
        await Future.forEach(batchDownloadResponse.response.batches,
            (element) async {
          element as Batch;
          if (_membershipBatchList
              .any((dbBatch) => element.batchNo == dbBatch.batchId)) {
            await sl<BatchDBRepo>().updateData(
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
            await sl<BatchDBRepo>().insertData(
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
        // batchDownloadResponse.response.batches.forEach((element) async {
        //   if (_membershipBatchList
        //       .any((dbBatch) => element.batchNo == dbBatch.batchId)) {
        //     await sl<BatchDBRepo>().updateData(
        //       BatchDataModel(
        //           countAM: int.parse(element.totalAm!),
        //           batchId: element.batchNo!,
        //           districtCode: element.districtCode,
        //           stateCode: element.stateCode,
        //           paymentStatus: element.paymentStatus == null
        //               ? "Pending"
        //               : element.paymentStatus == "PAID"
        //                   ? element.paymentStatus
        //                   : "Pending",
        //           syncStatus: "1"),
        //     );
        //   } else {
        //     await sl<BatchDBRepo>().insertData(
        //       BatchDataModel(
        //           countAM: int.parse(element.totalAm!),
        //           batchId: element.batchNo!,
        //           districtCode: element.districtCode,
        //           stateCode: element.stateCode,
        //           paymentStatus: element.paymentStatus == null
        //               ? "Pending"
        //               : element.paymentStatus == "PAID"
        //                   ? element.paymentStatus
        //                   : "Pending",
        //           syncStatus: "1"),
        //     );
        //   }
        // });

        /// to refresh batch list
        await getMembershipBatchList(context);
        Navigator.of(context).pop();
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
}
