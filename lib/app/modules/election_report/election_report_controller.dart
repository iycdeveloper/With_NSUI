import 'dart:convert';

import 'package:get/get.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/model/api_model/base/api_response.dart';

class ElectionReportController extends GetxController{

  List<dynamic> report = [];

  bool isLoading = true;

  @override
  void onInit() {
    getElectionReport();
    super.onInit();
  }

  Future<void> getElectionReport() async {
    update();
    ApiResponse apiResponse =
    await UnitManagementRepo().electionReport();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        report = responseDecoded['response'];
        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

}