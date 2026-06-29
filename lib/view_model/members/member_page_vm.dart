import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/blocks.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/mandalam.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/repository/batch_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/utils/app_constants.dart';

class MemberPageVM extends ChangeNotifier {
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController idProofController = TextEditingController();
//
  TextEditingController aadharController = TextEditingController();
//
  TextEditingController idTypeController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController districtNameController = TextEditingController();
  TextEditingController assemblyNameController = TextEditingController();
  TextEditingController mandalamNameController = TextEditingController();
  TextEditingController blockNameController = TextEditingController();
  TextEditingController statePresidentCandidateController =
      TextEditingController();
  TextEditingController stateGsCandidateController = TextEditingController();
  TextEditingController districtCandidateController = TextEditingController();
  TextEditingController districtCandidateGsController = TextEditingController();
  TextEditingController mandalamCandidateController = TextEditingController();
  TextEditingController assemblyCandidateController = TextEditingController();
  String? selectedIdImage;
  String? selectedAMImage;
  String? selectedStateName;
  String? selectedDisName;
  String? selectedAssemblyName;
  bool otpSent = false;
  bool otpVerified = false;

  BatchMember? currentMember;

  bool isLoading = false;
  Map<String, dynamic> csnDetails = {};

  onClickSendOtp(BuildContext context) {
    getCSNOTP(context, currentMember!.memberId!);
  }

  onClickValidateOtp(BuildContext context) {
    if (otpCodeController.text.length == 6) {
      validateCSNOTP(context, otpCodeController.text, currentMember!.memberId!);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Enter valid otp')));
    }
  }

  bool isEnableCSNverify = false;
  setMemberDetails(BatchMember member) async {
    currentMember = member;
    isLoading = true;
    List<DropdownItem> idProofList = [
      DropdownItem("Passport", "PP"),
      DropdownItem("Adhar Card", "AC"),
      DropdownItem("Driving Licence", "LD"),
      DropdownItem("Voter ID Card", "EI"),
      DropdownItem("E Voter ID", "EV"),
    ];
    List<Category> categoryList = await DbServices.db.getAllCategory();
    List<States> stateList = await DbServices.db.getAllStates(true);
    Log.printELog(member.stateCode);
    List<Districts> districtList =
        await DbServices.db.getAllDistrict(member.stateCode ?? '');
    List<Assembly> assemblyList = await DbServices.db.getAssemblyForVotersList(
        districtList.firstWhere(
            (element) => element.districtCode == member.districtCode),
        stateCode: member.stateCode);

    List<Blocks> blockList = await DbServices.db.getBlocks(districtList
        .firstWhere((element) => element.districtCode == member.districtCode));

    usernameController.text = member.firstName ?? "";
    lastNameController.text = member.lastName ?? "";
    professionController.text = member.profession ?? "";
    fatherNameController.text = member.relativeName ?? "";
    mobileController.text = member.mobile!;
    emailController.text = member.email!;
    addressController.text = member.address!;
    pinController.text = member.pin!;
    genderController.text = member.gender == "M" ? "MALE" : "FEMALE";
    dobController.text = member.dob!;
    //
    String category = '';
    var matchingCategory = categoryList
        .where((element) => element.categoryCode == member.category)
        .toList();
    if (matchingCategory.isNotEmpty) {
      category = matchingCategory.first.name;
    }

    categoryController.text = category;
    educationController.text = member.education!;
    //
    String idtype = '';
    var matchingidtype =
        idProofList.where((element) => element.value == member.idType).toList();
    if (matchingidtype.isNotEmpty) {
      idtype = matchingidtype.first.name;
    }
    idTypeController.text = idtype;

    idProofController.text = member.idValue!;
    aadharController.text = member.adhaarNumber ?? '';
    selectedIdImage = member.idDocumentFilePath ?? "";
    selectedAMImage = member.amPhotoFilePath ?? "";
    print("---");
    print(member.stateName);

    String stateanme = '';
    var matchingState = stateList
        .where((element) => element.stateCode == member.stateCode)
        .toList();
    if (matchingState.isNotEmpty) {
      stateanme = matchingState.first.name;
    }
    stateNameController.text = stateanme;

    String districname = '';

    var matchDistrict = districtList
        .where((element) => element.districtCode == member.districtCode)
        .toList();
    if (matchDistrict.isNotEmpty) {
      districname = matchDistrict.first.name;
    }
    districtNameController.text = districname;
    //
    if (!AppConstants.blockStatesList.contains(member.stateCode)) {
      assemblyNameController.text = assemblyList
          .firstWhere((element) => element.assemblyCode == member.assemblyCode)
          .name;
    } else {
      blockNameController.text = blockList
          .firstWhere((element) => element.blockCode == member.blockCode)
          .blockName;
    }
    if (["KL", "TL", "KA", "DL", "HP", "HR", "TN", "MB", "TS", "MP", "GJ"]
        .contains(member.stateCode)) {
      List<Mandalam> mandalamList = await DbServices.db.getAllMandalams(
          assemblyList.firstWhere(
              (element) => element.assemblyCode == member.assemblyCode));
      mandalamNameController.text = mandalamList
          .firstWhere((element) => element.mandalamCode == member.mandalamCode)
          .mandalamName;
    }
    if (member.statePresidentCandidate!.contains('**') &&
        member.statePresidentCandidate!.contains('**')) {
      isEnableCSNverify = true;
      notifyListeners();
    }
    statePresidentCandidateController.text =
        "State President Candidate CSN : ${member.statePresidentCandidate?.toString()}";
    stateGsCandidateController.text =
        "SGS Candidate CSN : ${member.stateGSCandidate?.toString()}";
    districtCandidateController.text =
        "District Candidate CSN : ${member.districtCandidate.toString()}";
    // if (member.stateCode == "KL") {
    districtCandidateGsController.text =
        "District GS Candidate CSN : ${member.districtGsCandidate.toString()}";
    mandalamCandidateController.text =
        "Mandalam Candidate CSN : ${member.mandalamCandidate.toString()}";
    // }
    assemblyCandidateController.text =
        "Assembly Candidate CSN : ${member.assemblyCandidate.toString()}";
    // /// for fetch member data from table
    // Provider.of<MembershipDbRepo>(context, listen: false)
    //     .getDatabaseRow(id).then((value) {
    //
    // });
    isLoading = false;
    notifyListeners();
  }

  validateCSNOTP(BuildContext context, String memberID, String otp) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
    ApiResponse apiResponse =
        await BatchRepo(dioClient: sl()).validateCSNOTP(memberID, otp);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        statePresidentCandidateController.text =
            responseDecoded["response"][0]['CSN_SP'];
        stateGsCandidateController.text =
            responseDecoded["response"][0]['CSN_SG'];
        districtCandidateController.text =
            responseDecoded["response"][0]['CSN_DP'];
        assemblyCandidateController.text =
            responseDecoded["response"][0]['CSN_AP'];
        districtCandidateGsController.text =
            responseDecoded["response"][0]['CSN_BT'];
        mandalamCandidateController.text =
            responseDecoded["response"][0]['CSN_BL'];
        otpVerified = true;
        notifyListeners();
        csnDetails = responseDecoded["response"][0];
        print(responseDecoded["response"]);
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop(); // pop loading

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
    } else {
      Navigator.of(context).pop(); // pop loading

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
    return true;
  }

  getCSNOTP(BuildContext context, String memberID) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
    ApiResponse apiResponse =
        await BatchRepo(dioClient: sl()).getCSNOTP(memberID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        otpSent = true;
        notifyListeners();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop(); // pop loading

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
    } else {
      Navigator.of(context).pop(); // pop loading

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
    return true;
  }
}
