import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/api_model/scrutiny/scrutiny_batch_download.dart';
import 'package:iyc/app/data/resources/db_provider/scrutiny/scrutiny_batch_db_repo.dart';
import 'package:iyc/app/data/resources/repository/scrutiny_repo.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/utils/utils.dart';

import '../../di_container.dart';
import '../../utils/app_constants.dart';

class ScrutinyBatchVM extends ChangeNotifier {
  final ScrutinyRepo scrutinyRepo;
  final ApiConfig apiConfig;
  ScrutinyBatchVM({required this.scrutinyRepo, required this.apiConfig});

  ScrutinyBatchDBRepo _scrutinyBatchDBRepo = sl<ScrutinyBatchDBRepo>();

  bool loading = false;
  bool syncBatch = true;
  bool batchDownload = false;
  List<BatchDataModel> scrutinyBatchList = [];
  List<BatchDataModel> _allScrutinyList = [];

  ///----------------------------------
  onBackButton(BuildContext context) {
    toPushNamedAndRemoveUntil(context: context, widgetName: '/');
  }

  initScrutinyBatch(BuildContext context) async {
    loading = true;
    if (await checkScrutinyStatus(context)) {
      downloadScrutinyBatches(context: context);
    }
  }

  checkScrutinyStatus(BuildContext context) async {
    ApiResponse apiResponse = await sl<ScrutinyRepo>().checkScrutinyStatus();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        await LocalStorageServices()
            .setScrutinyAgrID(responseDecoded['response']["AGGR_ID"]);
        return true;
      } else {
        loading = false;
        notifyListeners();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
        return false;
      }
    }
    return false;
  }

  onSearch(BuildContext, String str) {
    print("all scrutiny length ${_allScrutinyList.length}");

    scrutinyBatchList = _allScrutinyList
        .where((element) =>
            element.batchId.toUpperCase().contains(str.toUpperCase()))
        .toList();
    print(scrutinyBatchList.length);
    notifyListeners();
  }

  clearSearch() {
    scrutinyBatchList = _allScrutinyList;
    notifyListeners();
  }

  Future<bool> downloadScrutinyBatches({
    required BuildContext context,
  }) async {
    loading = true;
    if (batchDownload == false) {
      // showNetworkLoadingDialog(context);

      ApiResponse apiResponse = await scrutinyRepo.downloadBatch();

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
        if (responseDecoded['status'] == "SUCCESS") {
          ScrutinyBatchDownloadResponse batchDownloadResponse =
              ScrutinyBatchDownloadResponse.fromJson(responseDecoded);
          batchDownload = true;

          _allScrutinyList = batchDownloadResponse.response.batches;

          scrutinyBatchList = _allScrutinyList;
          loading = false;
          notifyListeners();
        } else {
          loading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseDecoded["response"])));
        }
      } else {
        // Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(apiResponse.error.toString())));
      }
    }
    return true;
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    return dobRangeDone;
  }
}
