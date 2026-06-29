import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  changeSelectedCandidate(String candidate, BuildContext context) {
    selectedCandidate = candidate;
    notifyListeners();
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

        /// payment failed status display
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" ERROR.  no nomination found")));
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(" Candidates not available")));
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
}
