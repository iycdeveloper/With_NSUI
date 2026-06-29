

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/repository/task_management_repo.dart';

class TaskCalenderVM extends ChangeNotifier{
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();

  Map<String, Color> stringColorMap = {
    'red': Colors.red,
    'yellow': Colors.yellow,
    'green': Colors.green
  };

  String starOfCurrentMonth = '0';
  Map<String, String> ratings = {};

  bool isLoading = true;

  Map<String, String>? selectedDateDetails;
  Map<String, Map<String, String>> dateWiseDetail = {};

  String currentMonth = DateTime.now().month.toString();
  String currentYear = DateTime.now().year.toString();

  onClickDate(String date){
    if(dateWiseDetail.keys.contains(date)){
      selectedDateDetails = dateWiseDetail[date]!;
      print(date);
      print(dateWiseDetail[date]);
    }
    else{
      selectedDateDetails = null;
    }
    notifyListeners();
  }

  getCurrentMonthYear(String yy, String mm){
    currentMonth = mm;
    currentYear = yy;
    isLoading = true;
    selectedDateDetails = null;
    notifyListeners();
    getPageDetails();
  }

  getPageDetails() async {
    ApiResponse apiRatingResponse = await TaskManagementRepo().getTaskRating(currentMonth, currentYear);
    if (apiRatingResponse.response != null &&
        apiRatingResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiRatingResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        for(var date in responseDecoded['response']){
          var i = date as Map<String, dynamic>;
          ratings['${i.values.first}'] = '${i.values.last}';
          dateWiseDetail['${i.values.first}'] = {
            "date": '${i.values.first}',
            "total_tasks": i["count"],
            "completed_tasks": i["completed"]
          };
        }
        print(dateWiseDetail);
      }
    }
    ApiResponse apiStarResponse = await TaskManagementRepo().getTaskStar(currentMonth, currentYear);
    if (apiStarResponse.response != null &&
        apiStarResponse.response!.statusCode == 200) {
      var responseDecoded =
      jsonDecode(utf8.decode(base64.decode(apiStarResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        starOfCurrentMonth = responseDecoded['response'].toString();
      }
    }
    isLoading = false;
    notifyListeners();
  }

  changeSelectedDay(BuildContext context, DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }

  void changeFocusedDay(BuildContext context, DateTime focused) {
    focusedDay = focused;
    notifyListeners();
  }
}