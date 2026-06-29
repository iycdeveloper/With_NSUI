import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/modules/election_report/view_report/html_view.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/states.dart';

class ViewReportController extends GetxController {
  Map<String, dynamic> reportData = Get.arguments;
  List<States>? stateList;
  States? selectedState;
  String? selectedMonth;
  String? selectedYear;
  List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<DropdownItem> monthDropdownItems = [];
  List<DropdownItem> yearsDropdownItems = [];

  @override
  void onInit() {
    for (var i in monthNames) {
      monthDropdownItems.add(DropdownItem(i, i));
    }
    for (int i = 2020; i <= 2030; i++) {
      yearsDropdownItems.add(DropdownItem('$i', '$i'));
    }
    Log.printILog(reportData);
    getStatesList();
    super.onInit();
  }

  void onChangeState(States value) async {
    selectedState = value;
    update();
  }

  void onChangeMonth(String value) async {
    selectedMonth = value;
    update();
  }

  void onChangeYear(String value) async {
    selectedYear = value;
    update();
  }

  Future<void> getStatesList() async {
    var tempStateList = await DbServices.db.getAllStates(true);
    stateList = [];
    for (var i in tempStateList) {
      if (['TS', 'U1', 'U2', 'U3'].contains(i.stateCode)) {
      } else {
        stateList!.add(i);
      }
    }
    update();
  }

  Future<void> getElectionUnitReport() async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await UnitManagementRepo().electionUnitReport(
        selectedState!.stateCode,
        selectedState!.name,
        selectedYear!,
        selectedMonth!,
        '${monthNames.indexOf(selectedMonth!) + 1}');
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        Log.printILog(responseDecoded['response']);
        Navigator.push(
          Get.context!,
          MaterialPageRoute(builder: (context) => HtmlViewer(htmlContent: responseDecoded['response'])),
        );
        update();
      } else {
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

  bool validateForm() {
    if(selectedState == null){
      CustomSnackBar.showErrorSnackBar('Select state');
      return false;
    }
    if(selectedYear == null){
      CustomSnackBar.showErrorSnackBar('Select year');
      return false;
    }
    if(selectedMonth == null){
      CustomSnackBar.showErrorSnackBar('Select month');
      return false;
    }

    return true;
  }
}
