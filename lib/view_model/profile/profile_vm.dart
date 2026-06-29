import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/data/resources/repository/auth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/app/data/resources/repository/task_management_repo.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/utils/utils.dart';

import '../../di_container.dart';
import '../../model/api_model/base/api_response.dart';
import '../../model/offline_model/database/assembly.dart';
import '../../model/offline_model/database/districts.dart';
import '../../model/offline_model/database/states.dart';

class ProfileVm extends ChangeNotifier {
  bool isLoading = false;
  UserDetail? userDetail;
  final AuthRepo authRepo = sl<AuthRepo>();

  late List<Districts> districtList;
  List<Assembly> assemblyList = [];
  late List<States> stateList;

  String userPoint = "0";

  getUserProfile(BuildContext context) async {
    isLoading = true;
    ApiResponse apiResponse = await authRepo.getUserDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      print(responseDecoded["response"].runtimeType);
      print("its respons...........");

      if (responseDecoded['status'] == "SUCCESS") {
        userDetail = UserDetail.fromJson(responseDecoded["response"]['BASIC_DETAILS'][0]);

        print(userDetail!.profilePic);

        stateList = await DbServices.db.getAllStates(true);

        // print(stateList[0].id);
        // districtList = [];

        districtList = await DbServices.db.getDistricts(stateList.firstWhere(
            (element) => element.stateCode == userDetail!.stateCode));

        // print(districtList[0].id);

        if (districtList
            .any((element) => element.districtCode == userDetail!.districtCode))
          assemblyList = await DbServices.db.getAssembly(
              districtList.firstWhere((element) =>
                  element.districtCode == userDetail!.districtCode));

        isLoading = false;
      } else {
        isLoading = false;
        showCustomSnackBar(responseDecoded["response"], context);
      }
    }
    isLoading = false;
    notifyListeners();
  }

  getUserPoints(BuildContext context) async {
    isLoading = true;
    ApiResponse apiResponse = await TaskManagementRepo().getUserPoints();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        userPoint = responseDecoded["response"][0]["POINTS"];
      } else {
        isLoading = false;
        showCustomSnackBar(responseDecoded["response"], context);
      }
    }
  }

  String authPoint = "0";

  getAuthPoint(BuildContext context) async {
    isLoading = true;
    ApiResponse apiResponse = await TaskManagementRepo().getAuthPoints();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        print("########################################");
        authPoint =  responseDecoded["response"];
        notifyListeners();
        print(responseDecoded["response"]);
        // userPoint = responseDecoded["response"][0]["POINTS"];
      } else {
        isLoading = false;
        showCustomSnackBar(responseDecoded["response"], context);
      }
    }
  }

  getProfilePic(BuildContext context) async {
    isLoading = true;
    ApiResponse apiResponse = await authRepo.getUserProfilePhoto();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        userPoint = responseDecoded["response"][0]["POINTS"];
      } else {
        isLoading = false;
        showCustomSnackBar(responseDecoded["response"], context);
      }
    }
  }

  // downloadIdCard(BuildContext context) async {
  //   final result = await toPage(
  //       context,
  //       IdCard(
  //         userDetail: userDetail!,
  //       ));
  //   if (result != null && result) {
  //     showCustomSnackBar("ID card saved to Download/IYC/ID folder", context);
  //     // await Alert(
  //     //   context: context,
  //     //   type: AlertType.success,
  //     //   onWillPopActive: true,
  //     //   title: "SUCCESS",
  //     //   desc: "ID card saved to Download/IYC/ID folder",
  //     //   buttons: [
  //     //     DialogButton(
  //     //       child: Text(
  //     //         "OKAY",
  //     //         style: TextStyle(color: Colors.white, fontSize: 20),
  //     //       ),
  //     //       onPressed: () => Navigator.of(context).pop(),
  //     //       width: 120,
  //     //     )
  //     //   ],
  //     // ).show();
  //   }
  // }
}
