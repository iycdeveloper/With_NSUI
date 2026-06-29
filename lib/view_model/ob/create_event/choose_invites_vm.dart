import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/events/ob_user.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';

class ChooseInvitesVM extends ChangeNotifier {
  bool isLoading = false;
  bool enableButton = true;
  bool isSelectAll = false;

  List<ObUser> selectedObUsers = [];
  List<ObUser> stateObUsers = [];
  List<ObUser> districtObUsers = [];
  List<ObUser> assemblyObUsers = [];

  List<ObUser> tempObUsers = []; // for sorting and filtering
  List<ObUser> resultList = [];

  /// resultant selected ob users list

  // for dropdowns
  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>? assemblyList;

  String? selectedOBState;
  String? selectedOBDistrict;
  String? selectedOBAssembly;

  int currentObIndex = 0;
  String appBarTitle = "State OB users";

  /// for switching ob list

  changeSelectAllSwitch(bool value) {
    print(value);
    if (isSelectAll) {
      resultList = [];

      tempObUsers.forEach((element) {
        element.isSelected = false;
      });
    } else {
      tempObUsers.forEach((element) {
        element.isSelected = true;
        resultList.add(element);
      });
    }
    isSelectAll = value;
    notifyListeners();
  }

  initObList(BuildContext context) async {
    isLoading = true;
    final result = await Future.wait([
      getStateObUsers(context),
      getDistrictObUsers(context),
      getAssemblyObUsers(context)
    ]);
    isLoading = false;
    notifyListeners();
  }

  changeSelection(bool value, int index) {
    tempObUsers[index].isSelected = value;
    if (value) {
      resultList.add(tempObUsers[index]);
    } else {
      resultList.removeWhere((element) => element.id == tempObUsers[index].id);
    }
    notifyListeners();
  }

  Future getStateObUsers(BuildContext context) async {
    ApiResponse apiResponse = await UnitManagementRepo().getStateOBUsers();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        stateObUsers = List<ObUser>.from(responseDecoded["response"].map((x) {
          selectedOBState = x["STATE"];
          return ObUser.fromJson(x);
        }));
        tempObUsers = stateObUsers;
        districtList =
            await DbServices.db.getDistricts(null, stateCode: selectedOBState);
        assemblyList =
            await DbServices.db.getAssembly(null, stateCode: selectedOBState);
        notifyListeners();
        return true;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
        return false;
      }
    }
  }

  Future getDistrictObUsers(BuildContext context) async {
    ApiResponse apiResponse = await UnitManagementRepo().getDistrictOBUsers();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        districtObUsers =
            List<ObUser>.from(responseDecoded["response"].map((x) {
          return ObUser.fromJson(x);
        }));

        notifyListeners();
        return true;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
        return false;
      }
    }
  }

  Future getAssemblyObUsers(BuildContext context) async {
    ApiResponse apiResponse = await UnitManagementRepo().getAssemblyOBUsers();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        assemblyObUsers =
            List<ObUser>.from(responseDecoded["response"].map((x) {
          return ObUser.fromJson(x);
        }));

        notifyListeners();
        return true;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
        return false;
      }
    }
  }

  showNextObUsers(BuildContext context) async {
    if (currentObIndex == 0) {
      tempObUsers.clear();
      tempObUsers = districtObUsers;
      appBarTitle = "District OB User";
      currentObIndex = 1;

      final availableObDistrictList =
          districtObUsers.map((e) => e.districtCode).toSet().toList();
      districtList = districtList
          ?.where((element) =>
              availableObDistrictList.contains(element.districtCode))
          .toList();
      enableButton = true;
      notifyListeners();
      return;
    } else if (currentObIndex == 1) {
      tempObUsers.clear();

      tempObUsers = assemblyObUsers;
      currentObIndex = 2;

      final availableObAssemblyList =
          assemblyObUsers.map((e) => e.assemblyCode).toSet().toList();
      assemblyList = assemblyList
          ?.where((element) =>
              availableObAssemblyList.contains(element.districtCode))
          .toList();

      appBarTitle = "Assembly OB User";
      enableButton = true;
      isSelectAll = false; // default
      notifyListeners();

      return;
    } else if (currentObIndex == 2) {
      return Navigator.of(context).pop(resultList);
    }
  }

  void changeSelectedValue(val, BuildContext context) {
    switch (currentObIndex) {
      case 0:
        selectedOBState = val;
        tempObUsers =
            stateObUsers.where((element) => element.stateCode == val).toList();

        break;
      case 1:
        selectedOBDistrict = val;
        tempObUsers = districtObUsers
            .where((element) => element.districtCode == val)
            .toList();

        break;
      case 2:
        selectedOBAssembly = val;
        tempObUsers = assemblyObUsers
            .where((element) => element.assemblyCode == val)
            .toList();
    }

    notifyListeners();
  }
}
