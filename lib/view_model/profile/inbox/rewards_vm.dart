import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/repository/rewards_repo.dart';

class RewardsVm extends ChangeNotifier{
  bool isLoading = true;

  List<dynamic> rewards = [];

  initPage(){
    getRewardsDetails();
  }

  getRewardsDetails() async {
    ApiResponse apiStarResponse = await RewardsRepo().getRewardsDetail();
    if (apiStarResponse.response != null &&
        apiStarResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiStarResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        // print(responseDecoded['response']);
        rewards = responseDecoded['response'];
      }
      isLoading = false;
      notifyListeners();
    }
  }

  String correctDateFormat(String date){
    DateTime dateTime = DateTime.parse(date);
    // Format DateTime into 'Month Day' format (e.g., 'August 21')
    String formattedDate = DateFormat('MMMM d').format(dateTime);
    return formattedDate;
  }
}