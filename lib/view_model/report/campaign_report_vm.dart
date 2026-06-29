import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/reports/booth_jodo_report_model.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/screens/ui/home/user_reports/booth_jodo_report.dart';

class CampaignReportVM extends ChangeNotifier {
  String selectedReportType = "1";
  String selectedCampaignId = "";


  List<DropdownItem> reportTypeList = [
    DropdownItem("Assembly Report", "1"),
    DropdownItem("Aggregator Report", "2"),
    // DropdownItem("Report Type 3", "3"),
  ];

  List<BoothJodoReportModel> boothJodoReportListByName = [];

  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();

  Timer? debounce;

  void onSearchChanged() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      loadingPage = true;
      notifyListeners();
      // Call your function here
      print('User stopped typing. Call your function now.');
      print(controller.text);
      if(selectedReportType == '1'){
        onSearchByName(controller1.text);
      }else{
        onSearchByName(controller.text);
      }

    });
  }

  onSearchByName(String value){
    if(selectedReportType == '1'){
      boothJodoReportListByName.clear();
      for(var i in boothJodoReportList){
        if((i.districtName!.contains(value.toUpperCase()) || i.assemblyName!.contains(value.toUpperCase())) && controller1.text.length > 2){
          print(i.name);
          boothJodoReportListByName.add(i);
          print(boothJodoReportListByName);
        }
      }
    }else{
      boothJodoReportListByName.clear();
      for(var i in boothJodoReportList){
        if((i.name!.contains(value.toUpperCase()) || i.districtName!.contains(value.toUpperCase()) || i.assemblyName!.contains(value.toUpperCase())) && controller.text.length > 2){
          print(i.name);
          boothJodoReportListByName.add(i);
          print(boothJodoReportListByName);
        }
      }
    }
    loadingPage = false;
    notifyListeners();
  }

  changeReportType(val, BuildContext context) {
    selectedReportType = val;
    notifyListeners();
    getReports(context, selectedCampaignId);
  }

  List<BoothJodoReportModel> boothJodoReportList = [];
  bool loadingPage = false;

  getReports(BuildContext context, String campaignId,
      [bool reload = false]) async {
    loadingPage = true;
    if (reload) notifyListeners();
    ApiResponse apiResponse =
        await sl<CampaignRepo>().getReports(selectedReportType, campaignId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = false;

        boothJodoReportList = List<BoothJodoReportModel>.from(
            responseDecoded["response"]
                .map((x) => BoothJodoReportModel.fromJson(x)));
        notifyListeners();
      } else {
        loadingPage = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  void initCampaign(String campaignId) {
    selectedCampaignId = campaignId;
  }
}
