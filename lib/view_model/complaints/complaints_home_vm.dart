import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/complaints_repo.dart';
import 'package:iyc/screens/ui/complaints/complaints_details.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/complaints/complaints_details_vm.dart';
import 'package:provider/provider.dart';

import '../../di_container.dart';

class ComplaintsHomeVM extends ChangeNotifier {
  List<DropdownItem>? candidatureLevelList;
  List<DropdownItem>? candidatesDropdownList;

  List<dynamic>? candidatesList;

  // [
  //     // DropdownItem("Male", "M"),
  //     // DropdownItem("Female", "F"),
  //   ];

  Completer<void>? updateDialogCompleter;

  // void handleUpdateBox() {
  //   if (updateDialogCompleter != null) return;

  //   updateDialogCompleter = Completer();
  //   CustomSnackBar.showUpdateAppBox();
  // }

  bool loadingPage = false;
  String? selectedLevel;
  String? selectedCandidate;

  String? userMemberId;
  String? userAssembly;
  String? userDistrict;
  String? userMandalam;
  String? userBlock;
  String? userState;

  bool showError = false;
  changeSelectedLevel(String candidatureLevel, BuildContext context) {
    selectedCandidate = null;
    candidatesDropdownList = null;
    selectedLevel = candidatureLevel;
    notifyListeners();
    getCandidatesNomination(context);
  }

  submit(BuildContext context) {
    if (selectedCandidate == null) {
      CustomSnackBar.showErrorSnackBar("Select Candidate");

      return;
    }
    if (selectedLevel == null) {
      CustomSnackBar.showErrorSnackBar("Select Level of Candidature");

      return;
    }
    toPage(
        context,
        ChangeNotifierProvider(
          create: (context) => ComplaintDetailsVm(),
          child: ComplaintsDetails(
            candidateData: candidatesList!
                .where((element) => element["MEMBER_ID"] == selectedCandidate)
                .first,
            candidatePost: selectedLevel!,
            userMemberId: userMemberId!,
            userMemberState: userState!,
          ),
        ));
  }

  changeSelectedCandidate(String candidate, BuildContext context) {
    selectedCandidate = candidate;
    notifyListeners();
  }

  getCandidatureLevel(BuildContext context) async {
    ApiResponse apiResponse = await sl<ComplaintsRepo>().getCandidatureLevels();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        candidatureLevelList = List.generate(
            responseDecoded["response"]["COMMITTEE"].length,
            (index) => DropdownItem(
                responseDecoded["response"]["COMMITTEE"][index],
                responseDecoded["response"]["COMMITTEE"][index]));

        loadingPage = false;
        showError = false;
        notifyListeners();
      } else {
        loadingPage = false;
        showError = true;
        notifyListeners();
        if (responseDecoded['error_code'] == 1001) {
          // handleUpdateBox();
        } else if (responseDecoded['error_code'] == 9999) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(" ERROR.  no nomination found")));
        } else {}

        /// payment failed status display
      }
    }
  }

  getCandidatesNomination(BuildContext context) async {
    notifyListeners();
    ApiResponse apiResponse = await sl<ComplaintsRepo>().getNominationComplaint(
        selectedLevel!,
        userState,
        userDistrict,
        userAssembly,
        userBlock,
        userMandalam);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        candidatesList = responseDecoded["response"];
        candidatesDropdownList = List.generate(
            candidatesList!.length,
            (index) => DropdownItem(
                "${candidatesList![index]["FIRST_NAME"]} ${candidatesList![index]["LAST_NAME"]}",
                candidatesList![index]["MEMBER_ID"]));
        notifyListeners();
      } else {
        /// payment failed status display

        if (responseDecoded['error_code'] == 1001) {
          // handleUpdateBox();
        } else if (responseDecoded['error_code'] == 9999) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(" Candidates not available")));
        } else {}
      }
    }
  }

  void getMemberDetails(BuildContext context) async {
    loadingPage = true;
    ApiResponse apiResponse = await sl<ComplaintsRepo>().getMemberDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        userMemberId = responseDecoded["response"][0]["MEMBER_ID"];
        userState = responseDecoded["response"][0]["STATE_CODE"];
        userDistrict = responseDecoded["response"][0]["DISTRICT_CODE"] ?? "";
        userAssembly = responseDecoded["response"][0]["ASSEMBLY_CODE"] ?? "";
        userBlock = responseDecoded["response"][0]["BLOCK_CODE"] ?? "";
        userMandalam = responseDecoded["response"][0]["MANDALAM_CODE"] ?? "";
        getCandidatureLevel(context);
      } else {
        showError = true;
        loadingPage = false;
        notifyListeners();
        if (responseDecoded['error_code'] == 1001) {
          // handleUpdateBox();
        } else if (responseDecoded['error_code'] == 9999) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseDecoded['response'])));
        } else {}
      }
    }
  }
}
