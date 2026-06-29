import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';

class ViewPointsVM extends ChangeNotifier {
  bool loadingPage = false;
  List<dynamic> pointsList = [];

  String? selectedLeaderBoard = "STATE";

  var dropdownList = [
    DropdownItem(
      "STATE",
      "STATE",
    ),
    DropdownItem(
      "DISTRICT",
      "DISTRICT",
    ),
    DropdownItem(
      "ASSEMBLY",
      "ASSEMBLY",
    ),
  ];

  void getPoints(BuildContext context, {bool isRefresh = false}) async {
    loadingPage = true;
    if (isRefresh) notifyListeners();
    ApiResponse apiResponse =
        await sl<YuvaBoothRepo>().getLeaderBoardPoints(selectedLeaderBoard!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = false;
        pointsList = await decodeData(responseDecoded);
        // boothJodoList = List<BoothJodo>.from(
        //     responseDecoded["response"].map((x) => BoothJodo.fromJson(x)));
        print(pointsList);
        notifyListeners();
      } else {
        loadingPage = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  decodeData(dynamic responseDecoded) async {
    var result = responseDecoded["response"].map((x) => x).toList();
    return result;
  }

  void changeLeaderBoardType(String? val, BuildContext context) {
    selectedLeaderBoard = val;
    notifyListeners();
    getPoints(context, isRefresh: true);
  }
}
