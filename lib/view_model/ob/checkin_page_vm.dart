import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';

import '../../model/api_model/base/api_response.dart';
import '../../model/api_model/events/checkin_data.dart';

class CheckInPageVM extends ChangeNotifier {
  bool isLoading = false;

  String description = "";

  List<CheckInData> eventList = [];

  Future getCheckInData(BuildContext context, [bool refresh = false]) async {
    eventList = [];
    isLoading = true;
    if (refresh) notifyListeners();
    ApiResponse apiResponse = await YuvaBoothRepo().getCheckInData();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        eventList = List<CheckInData>.from(
            responseDecoded["response"].map((x) => CheckInData.fromJson(x)));

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
}
