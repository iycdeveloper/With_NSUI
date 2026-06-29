import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/reports/booth_jodo_report_model.dart';

class CampaignReportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  String campaignId = Get.arguments;

  late TabController tabviewController =
  Get.put(TabController(vsync: this, length: 3));

  Timer? debounce;
  int currentIndex = 0;
  bool isLoading = true;
  int selectedIndex = -1;
  List<BoothJodoReportModel> boothJodoReportList = [];
  List<BoothJodoReportModel> boothJodoReportSearchList = [];

  @override
  void onInit() {
    getReports(campaignId);
    searchController.addListener(onSearchChanged);
    super.onInit();
  }

  void updateSelectedIndex(int index){
    if(selectedIndex == index){
      selectedIndex = -1;
    }
    else{
      selectedIndex = index;
    }
    update();
  }

  void updateCurrentIndex(int index) {
    currentIndex = index;
    selectedIndex = -1;
    getReports(campaignId);
    update();
  }

  getReports(String campaignId, [bool reload = false]) async {
    isLoading = true;
    update();
    ApiResponse apiResponse =
    await CampaignRepo().getReports('${currentIndex+1}', campaignId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        isLoading = false;

        boothJodoReportList = List<BoothJodoReportModel>.from(
            responseDecoded["response"]
                .map((x) => BoothJodoReportModel.fromJson(x)));
        update();
      } else {
        isLoading = false;
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

  void onSearchChanged() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void onSearchByName(String value){
    boothJodoReportSearchList.clear();
    for(var i in boothJodoReportList){
      if((i.districtName!.contains(value.toUpperCase()) || i.assemblyName!.contains(value.toUpperCase())) && searchController.text.length > 2){
        boothJodoReportSearchList.add(i);
        Log.printILog(boothJodoReportSearchList);
      }
    }
    isLoading = false;
    update();
  }
}
