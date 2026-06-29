import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/nomination_member.dart';
import 'package:iyc/model/offline_model/database/nominations.dart';
import 'package:iyc/app/data/resources/repository/nomination_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';

import '../../di_container.dart';

class UpdateCandidateVM extends ChangeNotifier {
  String? membershipId;

  String? selectedStatePresidentNominations;

  String? selectedStateGSNominations;
  String? selectedDistrictPresidentNominations;
  String? selectedAssemblyNominations;
  String? selectedMandalamNominations;
  String? selectedDistrictGSNominations;

  List<Nomination> statePresidentNominationsList = [];
  List<Nomination> stateGeneralSecretaryNominationsList = [];

  List<Nomination> districtPresidentNominationsList = [];
  List<Nomination> assemblyNominationsList = [];
  List<Nomination> mandalamNominationsList = [];
  List<Nomination> districtGsNominationsList = [];

  late NominationMember currentNominationMember;
  bool isLoading = true;
  MembershipRepo membershipRepo = MembershipRepo(dioClient: sl());

  refresh() {
    try {
      membershipId = "";
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }

  Future searchForStatePresidentNominations(BuildContext context) async {
    ///get state data list from db
    // statePresidentNominationsList = await DbServices.db
    //     .searchForStateNominations(
    //         stateCode: currentNominationMember.stateCode!,
    //         contestingFor: "State President");
    statePresidentNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "SP",
        state: currentNominationMember.stateCode ?? '',
        assembly: currentNominationMember.assemblyCode ?? '',
        district: currentNominationMember.districtCode ?? '',
        mandalam: currentNominationMember.mandalamCode ?? '',
        blackCode: currentNominationMember.blockCode ?? '',
        boothCode: '');
    if (result != null) {
      statePresidentNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : Random().nextInt(100),
              firstName: test['FIRST_NAME'],
              lastName: test['LAST_NAME'],
              masterLevelId: test['MASTER_LEVEL_ID'] == null
                  ? int.parse(test['MASTER_LEVEL_ID'].toString())
                  : 0))
          .toList();
      statePresidentNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }
    if (statePresidentNominationsList.isEmpty) {
      statePresidentNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    return true;
  }

  Future searchForStateGeneralSecreNominations(BuildContext context) async {
    ///get state data list from db
    // stateGeneralSecretaryNominationsList = await DbServices.db
    //     .searchForStateNominations(
    //         stateCode: currentNominationMember.stateCode!,
    //         contestingFor: "State General Secretary");
    stateGeneralSecretaryNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "SGS",
        state: currentNominationMember.stateCode ?? '',
        assembly: currentNominationMember.assemblyCode ?? '',
        district: currentNominationMember.districtCode ?? '',
        mandalam: currentNominationMember.mandalamCode ?? '',
        blackCode: currentNominationMember.blockCode ?? '',
        boothCode: '');
    if (result != null) {
      stateGeneralSecretaryNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : 0,
              firstName: test['FIRST_NAME'],
              lastName: test['LAST_NAME'],
              masterLevelId: test['MASTER_LEVEL_ID'] == null
                  ? int.parse(test['MASTER_LEVEL_ID'].toString())
                  : 0))
          .toList();
      stateGeneralSecretaryNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }
    if (stateGeneralSecretaryNominationsList.isEmpty) {
      stateGeneralSecretaryNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    return true;
  }

  Future searchForDistrictNominations(BuildContext context) async {
    // Log.printDLog(
    //     'message ${currentNominationMember.stateCode!} ${currentNominationMember.districtCode!}');
    // districtPresidentNominationsList = await DbServices.db
    //     .searchForDistrictNominations(
    //         stateCode: currentNominationMember.stateCode!,
    //         districtCode: currentNominationMember.districtCode!,
    //         contestingFor: "District President");
    districtPresidentNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "DP",
        state: currentNominationMember.stateCode ?? '',
        assembly: currentNominationMember.assemblyCode ?? '',
        district: currentNominationMember.districtCode ?? '',
        mandalam: currentNominationMember.mandalamCode ?? '',
        blackCode: currentNominationMember.blockCode ?? '',
        boothCode: '');
    if (result != null) {
      districtPresidentNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : 0,
              firstName: test['FIRST_NAME'],
              lastName: test['LAST_NAME'],
              masterLevelId: test['MASTER_LEVEL_ID'] == null
                  ? int.parse(test['MASTER_LEVEL_ID'].toString())
                  : 0))
          .toList();
      districtPresidentNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }

    //
    if (districtPresidentNominationsList.isEmpty) {
      districtPresidentNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    return true;
  }

  Future searchForDistrictGsNominations(BuildContext context) async {
    // Log.printDLog(
    //     '${currentNominationMember.stateCode!}, ${currentNominationMember.districtCode!}');
    // districtGsNominationsList = await DbServices.db
    //     .searchForDistrictNominations(
    //         stateCode: currentNominationMember.stateCode!,
    //         districtCode: currentNominationMember.districtCode!,
    //         contestingFor: "District General Secretary");
    districtGsNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "DGS",
        state: currentNominationMember.stateCode ?? '',
        assembly: currentNominationMember.assemblyCode ?? '',
        district: currentNominationMember.districtCode ?? '',
        mandalam: currentNominationMember.mandalamCode ?? '',
        blackCode: currentNominationMember.blockCode ?? '',
        boothCode: '');
    if (result != null) {
      districtGsNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : 0,
              firstName: test['FIRST_NAME'],
              lastName: test['LAST_NAME'],
              masterLevelId: test['MASTER_LEVEL_ID'] == null
                  ? int.parse(test['MASTER_LEVEL_ID'].toString())
                  : 0))
          .toList();
      districtGsNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }

    //
    if (districtGsNominationsList.isEmpty) {
      districtGsNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    return true;
  }

  Future searchForAssemblyNominations(BuildContext context) async {
    // assemblyNominationsList = await DbServices.db.searchForAssemblyNominations(
    //     stateCode: currentNominationMember.stateCode!,
    //     districtCode: currentNominationMember.districtCode!,
    //     assemblyCode: currentNominationMember.assemblyCode!,
    //     contestingFor: "Assembly");
    assemblyNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "VS",
        state: currentNominationMember.stateCode ?? '',
        assembly: currentNominationMember.assemblyCode ?? '',
        district: currentNominationMember.districtCode ?? '',
        mandalam: currentNominationMember.mandalamCode ?? '',
        blackCode: currentNominationMember.blockCode ?? '',
        boothCode: '');
    if (result != null) {
      assemblyNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : 0,
              firstName: test['FIRST_NAME'],
              lastName: test['LAST_NAME'],
              masterLevelId: test['MASTER_LEVEL_ID'] == null
                  ? int.parse(test['MASTER_LEVEL_ID'].toString())
                  : 0))
          .toList();
      assemblyNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }
    //
    if (assemblyNominationsList.isEmpty) {
      assemblyNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    return true;
  }

  Future searchForMandalamNominations(BuildContext context) async {
    // mandalamNominationsList = await DbServices.db.searchForMandalamNominations(
    //     stateCode: currentNominationMember.stateCode!,
    //     districtCode: currentNominationMember.districtCode!,
    //     blockCode: currentNominationMember.mandalamCode ??
    //         currentNominationMember.blockCode ??
    //         "", // mandalam code is considering block code in db
    //     contestingFor: "Mandalam");
    mandalamNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "MD".toUpperCase(),
        state: currentNominationMember.stateCode ?? '',
        assembly: currentNominationMember.assemblyCode ?? '',
        district: currentNominationMember.districtCode ?? '',
        mandalam: currentNominationMember.mandalamCode ?? '',
        blackCode: currentNominationMember.blockCode ?? '',
        boothCode: '');
    if (result != null) {
      mandalamNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : 0,
              firstName: test['FIRST_NAME'],
              lastName: test['LAST_NAME'],
              masterLevelId: test['MASTER_LEVEL_ID'] == null
                  ? int.parse(test['MASTER_LEVEL_ID'].toString())
                  : 0))
          .toList();
      mandalamNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }
    //
    if (mandalamNominationsList.isEmpty) {
      mandalamNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    return true;
  }

  changeStateNomination(String val) {
    selectedStatePresidentNominations = val;
    notifyListeners();
  }

  changeStateGSNomination(String val) {
    selectedStateGSNominations = val;
    notifyListeners();
  }

  changeDistrictNomination(String val) {
    selectedDistrictPresidentNominations = val;
    notifyListeners();
  }

  changeDistrictGsNomination(String val) {
    selectedDistrictGSNominations = val;
    notifyListeners();
  }

  changeAssemblyNomination(String val) {
    selectedAssemblyNominations = val;
    notifyListeners();
  }

  changeMandalamNomination(String val) {
    selectedMandalamNominations = val;
    notifyListeners();
  }

  bool declarationStatus = false;

  changeDeclarationStatus(bool value) {
    declarationStatus = value;
    notifyListeners();
  }

  Future<dynamic> getNominationBallotList({
    String? ballot,
    String? state,
    String? district,
    String? assembly,
    String? mandalam,
    String? blackCode,
    String? boothCode,
  }) async {
    // ProgressDialogUtils.showProgressIndicator();
    print('API TYPE::$ballot');
    ApiResponse apiResponse = await membershipRepo.getNominationBallotData(
        ballot: ballot ?? '',
        state: state ?? '',
        district: district ?? '',
        assembly: assembly ?? '',
        mandalam: mandalam ?? '',
        blackCode: blackCode ?? '',
        boothCode: boothCode ?? '');
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        print('API TYPE::$ballot');

        return responseDecoded["response"];
        // ProgressDialogUtils.closeDialog();
        // update();
      } else {
        return null;
        // ProgressDialogUtils.closeDialog();
        // CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
    return null;
  }

  bool validatePage(BuildContext context) {
    selectedStatePresidentNominations == null
        ? showCustomSnackBar("Select State President Nomination", context)
        : selectedStateGSNominations == null
            ? showCustomSnackBar(
                "Select State General Secretary Nomination", context)
            : selectedDistrictPresidentNominations == null
                ? showCustomSnackBar("Select District Nomination", context)
                : selectedAssemblyNominations == null
                    ? showCustomSnackBar("Select Assembly Nomination", context)
                    : !declarationStatus
                        ? showCustomSnackBar(
                            "Kindly accept declaration to continue", context)
                        : null;

    final result = (selectedStatePresidentNominations != null &&
        selectedStateGSNominations != null &&
        selectedDistrictPresidentNominations != null &&
        selectedAssemblyNominations != null &&
        declarationStatus);
    return result;
  }

  Future initialize(
      BuildContext context, NominationMember nominationMember) async {
    isLoading = true;
    currentNominationMember = nominationMember;
    final result = await Future.wait([
      searchForStatePresidentNominations(context),
      searchForStateGeneralSecreNominations(context),
      searchForDistrictNominations(context),
      searchForAssemblyNominations(context),
      // if ((currentNominationMember.stateCode!) == "KL")
      searchForDistrictGsNominations(context),
      if (["KL", "TL", "KA", "DL", "HP", "HR", "TN", "MB", "MP","GJ","JH"]
          .contains(currentNominationMember.stateCode))
        searchForMandalamNominations(context)
    ]);
    print(result);
    isLoading = false;
    await Future.delayed(Duration.zero);
    notifyListeners();
    return result;
  }

  void submit(BuildContext context) async {
    if (validatePage(context)) {
      showNetworkLoadingDialog(context);

      ApiResponse apiResponse =
          await NominationRepo(dioClient: sl()).updateCsn({
        "MEMBER_ID": "${currentNominationMember.memberId}",
        "CSN_SP": "$selectedStatePresidentNominations",
        "CSN_SG": "$selectedStateGSNominations",
        "CSN_DP": "$selectedDistrictPresidentNominations",
        "CSN_AP": "$selectedAssemblyNominations",
        "CSN_DG": "${selectedDistrictGSNominations ?? ""}",
        "CSN_MP": "${selectedMandalamNominations ?? ""}",
      });
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
        print(responseDecoded);
        if (responseDecoded['status'] == "SUCCESS") {
          CustomSnackBar.showSuccessSnackBar(responseDecoded['response']);
          Navigator.of(context).pop(); // loading dialog
          Navigator.of(context).pop();
          Navigator.of(context).pop(); // page close

          notifyListeners();
        } else {
          Navigator.of(context).pop();
          CustomSnackBar.showSuccessSnackBar(responseDecoded['response']);
        }
      }
    }
  }
}
