import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/app/data/resources/repository/banner_repo.dart';
import 'package:iyc/app/data/resources/repository/task_management_repo.dart';

import '../../model/api_model/base/api_response.dart';

class HomePageDashboardVM extends ChangeNotifier {
  bool loadingPage = false;
  bool showError = false;
  YuvaUser? yuvaUser;
  List<YuvaUser>? yuvaUsersList;

  String boothJodoError =
      "Yuva User details fetch failed BoothJodo Access not permitted for this user";

  Future getYuvaUser(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await YuvaBoothRepo().getYuvaUserNew();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        showError = false;
        loadingPage = false;
        yuvaUser = yuvaUserFromJson(responseDecoded['response'][0]);
        yuvaUsersList = yuvaUsersListFromJson(responseDecoded['response']);
        notifyListeners();
      } else {
        showError = true;
        loadingPage = false;
        boothJodoError = responseDecoded['response'];
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  int pendIngCount = 0;
  bool loadingTaskCount = false;

  initDashboard(BuildContext context) async {
    final result = await Future.wait(
        [getLocalSavedPendingTaskCount(), getYuvaUser(context), getBanners()]);
    notifyListeners();
  }

  List<String> bannerUrlList = [];

  Future getBanners() async {
    ApiResponse apiResponse = await BannerRepo().getBanners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        bannerUrlList = responseDecoded['response']
            .map<String>((x) => x["image_link"].toString())
            .toList();

        debugPrint(bannerUrlList.length.toString());
        return true;
        notifyListeners();
      } else {
        return false;
      }
    }
  }

  Future getLocalSavedPendingTaskCount() async {
    print('Count of pending task get updated');
    loadingTaskCount = true;
    final taskList = await TaskManagementRepo().getTaskListFromLocallySaved();
    if (taskList.isNotEmpty)
      pendIngCount = taskList
          .where((e) =>
              (e["TASK_STATUS"] == "PENDING") &&
              (DateTime.parse(e["TASK_END_DATE"]).isAfter(DateTime.now())))
          .toList()
          .length;
    loadingTaskCount = false;
    notifyListeners();
  }
}
