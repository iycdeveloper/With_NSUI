import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/screens/ui/home/yuva_booth/add_yuva_user.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/yuva_booth/add_yuva_user_vm.dart';
import 'package:provider/provider.dart';

import '../../di_container.dart';
import '../../model/api_model/base/api_response.dart';

class YuvaBoothHomeVM extends ChangeNotifier {
  bool loadingPage = false;
  bool showError = false;
  YuvaUser? yuvaUser;
  List<YuvaUser>? yuvaUsersList;

  void getYuvaUser(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await sl<YuvaBoothRepo>().getYuvaUserNew();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        showError = false;
        loadingPage = false;
        if (responseDecoded['response'].length > 0)
          yuvaUser = yuvaUserFromJson(responseDecoded['response'].first);
        yuvaUsersList = yuvaUsersListFromJson(responseDecoded['response']);
        notifyListeners();
      } else {
        showError = true;
        loadingPage = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  initPage(BuildContext context) {
    checkObAccess(context);
  }

  bool showObAccess = false;
  bool isLoadingObAccess = false;

  checkObAccess(BuildContext context) async {
    isLoadingObAccess = true;

    ApiResponse apiResponse = await UnitManagementRepo().checkOBAccess();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        showObAccess = true;
        isLoadingObAccess = false;
      } else {
        showObAccess = false;
        isLoadingObAccess = false;

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }

      isLoadingObAccess = false;
      notifyListeners();
    }
  }

  String getAppbarName(String rolePriority) {
    switch (rolePriority) {
      case "1":
        return "Add Admin";
      case "2":
        return "Add Zonal in Charge";
      case "3":
        return "Add Leader";
      case "4":
        return "Add Sector in Charge";
      // case "5":
      //   return "Add Booth in Charge";

      default:
        return "";
    }
  }

  List<Widget> generateDialogOptions(
      BuildContext context, String loggedUserRoleId) {
    List<Widget> dialogOptionsList = [];
    for (int i = int.parse(loggedUserRoleId); i < 5; i++) {
      if (i == 4 && int.parse(loggedUserRoleId) < 4) break;
      dialogOptionsList.add(SimpleDialogOption(
        onPressed: () {
          navigateAddYuvaUser(context, i + 1, getAppbarName(i.toString()));
        },
        child: Text(getAppbarName(i.toString())),
      ));
    }

    return dialogOptionsList;
  }

  navigateAddYuvaUser(
      BuildContext context, int selectedRoleId, String appBarTitle) {
    Navigator.pop(context); // dialog pop
    toPage(
        context,
        ChangeNotifierProvider(
            create: (context) => AddYuvaUserVM(),
            child: AddYuvaUser(
                yuvaUser: yuvaUser!,
                yuvaUserList: yuvaUsersList!,
                roleId: selectedRoleId.toString(),
                title: appBarTitle)));
  }

// String getViewButtonName(String rolePriority) {
//   switch (rolePriority) {
//     case "1":
//       return "View Admin";
//     case "2":
//       return "View Assembly in Charge";
//     case "3":
//       return "View Zonal in Charge";
//     case "4":
//       return "View Sector in Charge";
//     case "5":
//       return "View Booth in Charge";
//
//     default:
//       return "";
//   }
// }
}
