import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/modules/check-in/widget/add_check_in_bottom_sheet.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/events/checkin_data.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/states.dart';

import '../../core/app_export.dart';

class CheckInController extends GetxController {
  bool isLoading = true;

  List<CheckInData> eventList = [];

  TextEditingController purposeController = TextEditingController();

  @override
  void onInit() {
    getStatesList();
    getCheckInData();
    super.onInit();
  }

  Future<void> getCheckInData() async {
    eventList = [];
    isLoading = true;
    ApiResponse apiResponse = await YuvaBoothRepo().getCheckInData();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        eventList = List<CheckInData>.from(
            responseDecoded["response"].map((x) => CheckInData.fromJson(x)));

        isLoading = false;
        update();
      } else {
        isLoading = false;
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

  void onClickCheckIn() async {
    if (purposeController.text.isEmpty &&
        selectedState == null &&
        selectedDistrict == null) {
      CustomSnackBar.showErrorSnackBar('fill all the details');
      return;
    }
    if (purposeController.text.isEmpty) {
      CustomSnackBar.showErrorSnackBar('Purpose is invalid');
      return;
    }
    if (selectedState == null) {
      CustomSnackBar.showErrorSnackBar('State is invalid');
      return;
    }
    if (selectedDistrict == null) {
      CustomSnackBar.showErrorSnackBar('District is invalid');
      return;
    }
    if (purposeController.text.isNotEmpty &&
        selectedState != null &&
        selectedDistrict != null) {
      Get.back();
      ProgressDialogUtils.showProgressIndicator();
      ApiResponse apiResponse = await YuvaBoothRepo().checkInYuvaBooth(
          purposeController.text, selectedState!.stateCode, selectedDistrict!);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        await getCheckInData().whenComplete(() {
          ProgressDialogUtils.closeDialog();
          checkInSuccessBottomSheet();
        });
        purposeController.clear();
        checkInSuccessBottomSheet();
      } else {
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(apiResponse.error);
      }
    }
  }

  List<States>? stateList;
  List<DropdownItem> districtDropdownItems = [];
  States? selectedState;
  String? selectedDistrict;

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

  Future<void> getDistrictList() async {
    districtDropdownItems.clear();
    var districtList =
        await DbServices.db.getDistricts(selectedState );
    for (var i in districtList) {
      districtDropdownItems.add(DropdownItem(i.name, i.districtCode));
    }
    update();
  }

  void onChangeState(States value) async {
    print("value" + value.toString());
    selectedState = value;
    await getDistrictList();
    update();
  }

  void changeDistrict(String districtCode) async {
    selectedDistrict = districtCode;

    update();
  }

  clearData() {
    districtDropdownItems.clear();
    purposeController.clear();
    selectedDistrict = null;
    selectedState = null;
    update();
  }
}
