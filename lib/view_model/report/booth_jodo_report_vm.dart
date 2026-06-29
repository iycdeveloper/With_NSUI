import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/reports/booth_jodo_report_model.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/screens/ui/home/user_reports/booth_jodo_report.dart';

class BoothJodoReportVM extends ChangeNotifier {
  TextEditingController controller = TextEditingController();

  String? selectedReportType = "1";

  List<DropdownItem> reportTypeList = [
    DropdownItem("Assembly Wise", "1"),
    DropdownItem("Aggregator Wise ", "2"),
    DropdownItem("Booth Wise", "3"),
  ];

  changeReportType(val, BuildContext context) {
    selectedReportType = val;
    notifyListeners();
    getReports(context);
  }

  List<BoothJodoReportModel> boothJodoReportList = [];
  List<BoothJodoReportModel> boothJodoReportSearchList = [];
  bool loadingPage = false;
  Timer? debounce;

  getReports(BuildContext context, [bool reload = false]) async {
    loadingPage = true;
    if (reload) notifyListeners();
    ApiResponse apiResponse =
        await sl<YuvaBoothRepo>().getReports(selectedReportType!);
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

  void onSearchChanged() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      // loadingPage = true;
      notifyListeners();
      // Call your function here
      print('User stopped typing. Call your function now.');
      print(controller.text);
    });
  }

  onSearchByName(String value){
      boothJodoReportSearchList.clear();
      for(var i in boothJodoReportList){
        if((i.districtName!.contains(value.toUpperCase()) || i.assemblyName!.contains(value.toUpperCase())) && controller.text.length > 2){
          boothJodoReportSearchList.add(i);
        }
      }
    loadingPage = false;
    notifyListeners();
  }
}
