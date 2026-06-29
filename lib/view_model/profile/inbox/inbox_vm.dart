import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/task/task.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/app/data/resources/repository/auth_repo.dart';
import 'package:iyc/app/data/resources/repository/task_management_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InboxVM extends ChangeNotifier {
  bool isLoading = false;
  List<Task> taskList = [];
  List<Task> allTaskList = [];

  UserDetail? userDetail;
  final AuthRepo authRepo = sl<AuthRepo>();

  String? dailyTaskCount;
  String? dailyTaskCompleted;

  getUserProfile(BuildContext context) async {
    isLoading = true;
    ApiResponse apiResponse = await authRepo.getUserDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        userDetail = UserDetail.fromJson(responseDecoded["response"]['BASIC_DETAILS'][0]);
        isLoading = false;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  getDailyTaskStatus(BuildContext context) async {
    ApiResponse apiResponse = await TaskManagementRepo().getDailyTaskStatus();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        print(responseDecoded['response']);
        dailyTaskCount = responseDecoded['response'][0]['TOTAL']!;
        if(responseDecoded['response'][0]['COMPLETED'].isNotEmpty){
          dailyTaskCompleted = responseDecoded['response'][0]['COMPLETED']!;
        }else{
          dailyTaskCompleted = '0';
        }
        print('$dailyTaskCount------------------$dailyTaskCompleted');
      }
    }
    notifyListeners();
  }

  getAllTasks(BuildContext context, [bool refresh = false]) async {
    taskList = [];
    isLoading = true;
    if (refresh) notifyListeners();
    ApiResponse apiResponse = await TaskManagementRepo().getTaskList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        allTaskList = List<Task>.from(responseDecoded["response"].map((x) => Task.fromJson(x)));
        taskList = allTaskList;
        taskList = await _sortTask("PENDING");
        await sl<SharedPreferences>()
            .setString("task_list", jsonEncode(responseDecoded["response"]));

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

  final List<String> options = ['New', 'Completed', 'Expired'];

  sortTasks(BuildContext context, int index, [bool refresh = true]) async {
    taskList = [];
    isLoading = true;
    switch (index) {
      case 0:
        taskList = await _sortTask("PENDING");
        break;
      case 1:
        taskList = allTaskList
            .where((value) => value.taskStatus == "COMPLETED")
            .toList();
        break;
      case 2:
        taskList = allTaskList
            .where((value) =>
                value.taskEndDate.isBefore(DateTime.now().subtract(Duration(days: 1))) &&
                value.taskStatus != "COMPLETED")
            .toList();
        break;
    }
    isLoading = false;
    notifyListeners();
  }

  _sortTask(String status) async {
    final tempTaskList = allTaskList
        .where((value) => ((value.taskStatus == status) &&
            (value.taskEndDate.isAfter(DateTime.now().subtract(Duration(days: 1))))))
        .toList();
    return tempTaskList;
  }
}
