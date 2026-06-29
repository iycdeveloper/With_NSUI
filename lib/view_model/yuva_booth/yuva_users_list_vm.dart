import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_users_model.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/home/yuva_booth/add_yuva_user.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/yuva_booth/add_yuva_user_vm.dart';
import 'package:provider/provider.dart';

import '../../di_container.dart';

class YuvaUsersListVM extends ChangeNotifier {
  bool loadingPage = false;
  List<YuvaUsersModel> yuvaUsersList = [];

  List<Assembly> assemblyList = [];
  List<Districts> districtList = [];

  String? selectedStateCode;
  States? selectedState;
  String selectedStateName = "Select Work State";
  List<States>? stateList;

  getStatesList() async {
    stateList = await DbServices.db.getAllStates(true); // true pick all states

    ///set selected state on login
    String stateCode = "${await LocalStorageServices().getSTCode()}";
    stateList!.forEach((element) {
      if (element.stateCode == stateCode) {
        selectedState = element;
      }
    });
    selectedStateName = selectedState!.name;
    notifyListeners();
    getDistrictList();
    notifyListeners();
  }

  getAssemblyList() async {
    /// district null all assembly in states will return
    assemblyList = await DbServices.db.getAssembly(null,
        stateCode: await LocalStorageServices().getWorkStateCode());
    print(assemblyList.length);
    notifyListeners();
    return true;
  }

  changeSelectedState(States state, BuildContext context) {
    selectedState = state;

    notifyListeners();
    getYuvaUsers(context);
    getDistrictList();
  }

  getDistrictList() async {
    districtList = await DbServices.db.getDistricts(null,
        stateCode: await LocalStorageServices().getWorkStateCode());
    notifyListeners();
    return districtList;
  }

  String? roleId;

  init(String? roleId, BuildContext context) {
    this.roleId = roleId;
    getYuvaUser(context);
    if (roleId == "1") getStatesList();
    getAssemblyList();
    getDistrictList();
  }

  void getYuvaUsers(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await sl<YuvaBoothRepo>().getAllYuvaUsers(
        selectedState?.stateCode ??
            await LocalStorageServices().getWorkStateCode());
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = false;

        yuvaUsersList = List<YuvaUsersModel>.from(
            responseDecoded["response"].map((x) => YuvaUsersModel.fromJson(x)));
        notifyListeners();
      } else {
        loadingPage = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  bool showError = false;
  YuvaUser? yuvaUser;
  List<YuvaUser>? yuvaUsers;

  void getYuvaUser(BuildContext context) async {
    ApiResponse apiResponse = await sl<YuvaBoothRepo>().getYuvaUserNew();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        if (responseDecoded['response'].length > 0)
          yuvaUser = yuvaUserFromJson(responseDecoded['response'].first);
        yuvaUsers = yuvaUsersListFromJson(responseDecoded['response']);
        notifyListeners();
      } else {
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  navigateAddYuvaUser(
      BuildContext context, int selectedRoleId, String appBarTitle) {
    Navigator.pop(context); // dialog pop
    try{
      toPage(
          context,
          ChangeNotifierProvider(
              create: (context) => AddYuvaUserVM(),
              child: AddYuvaUser(
                  yuvaUser: yuvaUser!,
                  yuvaUserList: yuvaUsers!,
                  roleId: selectedRoleId.toString(),
                  title: appBarTitle)));
    }catch(e){
      print(e);
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

  List<Widget> generateDialogOptions(BuildContext context, String loggedUserRoleId) {
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
}
