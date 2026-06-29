
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/events/verify_event_data.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';

class VerifyEventVM extends ChangeNotifier{
  bool isLoading = true;
  List<VerifyEventData> eventList = [];

  Future getVerifyEventsList(BuildContext context) async {
    ApiResponse apiResponse = await UnitManagementRepo().getVerifyEvent();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        print(responseDecoded["response"]);
        eventList = List<VerifyEventData>.from(
            responseDecoded["response"].map((x) => VerifyEventData.fromJson(x)));
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  Future verifyEvent(BuildContext context, String id, String rating) async {
    ApiResponse apiResponse = await UnitManagementRepo().verifyEvent(id, rating);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        print(responseDecoded["response"]);
        notifyListeners();
      } else {
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

}