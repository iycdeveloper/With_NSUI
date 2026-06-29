import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/membership_repo.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/blocks.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/nominations.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/view_model/membership/constituency_info_vm.dart';
import 'package:provider/provider.dart';

import 'membership_vm.dart';

class CandidatesInfoVM extends ChangeNotifier {
  String? membershipId;

  String? selectedStatePresidentNominations;

  String? selectedStateGSNominations;
  String? selectedDistrictNominations;
  String? selectedAssemblyNominations;
  String? selectedBlockNominations;
  String? selectedBoothNominations;

  List<Nomination> statePresidentNominationsList = [];
  List<Nomination> stateGeneralSecretaryNominationsList = [];

  List<Nomination> districtNominationsList = [];
  List<Nomination> assemblyNominationsList = [];
  List<Nomination> blockNominationsList = [];
  List<Nomination> boothNominationsList = [];
  States? selectedState;
  Districts? selectedDistrict;
  Assembly? selectedAssembly;
  Blocks? selectedBlock;
  Booth? selectedBooth;

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
    //         stateCode: selectedState!.stateCode,
    //         contestingFor: "State President");
    statePresidentNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "SP",
        state: selectedState == null ? '' : selectedState!.stateCode,
        assembly:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        district:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode);
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

    /// JK condtion checking
    // if (selectedState!.stateCode == "JK") {
    //   bool isUserFromJammu = AppConstants.jammuDistricts
    //       .contains(int.parse(selectedDistrict!.districtCode));
    //
    //   statePresidentNominationsList = isUserFromJammu
    //       ? tempList
    //           .where((element) =>
    //               AppConstants.jammuDistricts.contains(element.districtCode))
    //           .toList()
    //       : tempList
    //           .where((element) =>
    //               !(AppConstants.jammuDistricts.contains(element.districtCode)))
    //           .toList();
    // } else {
    //   statePresidentNominationsList = tempList;
    // }

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
    // notifyListeners();
  }

  Future searchForStateGeneralSecreNominations(BuildContext context) async {
    ///getting selected state/district/assembly code
    selectedState =
        Provider.of<ConstituencyInfoVM>(context, listen: false).selectedState!;
    selectedDistrict = Provider.of<ConstituencyInfoVM>(context, listen: false)
        .selectedDistrict;
    selectedAssembly = Provider.of<ConstituencyInfoVM>(context, listen: false)
        .selectedAssembly;

    ///get state data list from db
    // stateGeneralSecretaryNominationsList = await DbServices.db
    //     .searchForStateNominations(
    //         stateCode: selectedState!.stateCode,
    //         contestingFor: "State General Secretary");
    stateGeneralSecretaryNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "SGS",
        state: selectedState == null ? '' : selectedState!.stateCode,
        assembly:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        district:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode);
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

    /// JK condtion checking
    // if (selectedState!.stateCode == "JK") {
    //   bool isUserFromJammu = AppConstants.jammuDistricts
    //       .contains(int.parse(selectedDistrict!.districtCode));
    //
    //   stateGeneralSecretaryNominationsList = isUserFromJammu
    //       ? tempList
    //           .where((element) =>
    //               AppConstants.jammuDistricts.contains(element.districtCode))
    //           .toList()
    //       : tempList
    //           .where((element) =>
    //               !(AppConstants.jammuDistricts.contains(element.districtCode)))
    //           .toList();
    // } else {
    //   stateGeneralSecretaryNominationsList = tempList;
    // }
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

    //  notifyListeners();
  }

  Future searchForDistrictNominations(BuildContext context) async {
    // Log.printDLog(
    //     '${selectedState!.stateCode}, ${selectedDistrict!.districtCode}');
    // districtNominationsList = await DbServices.db.searchForDistrictNominations(
    //     stateCode: selectedState!.stateCode,
    //     districtCode: selectedDistrict!.districtCode,
    //     contestingFor: "District President");
    districtNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "DP",
        state: selectedState == null ? '' : selectedState!.stateCode,
        // district: selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        assembly:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        district:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode);
    if (result != null) {
      districtNominationsList = result
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
      districtNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }

    //
    if (districtNominationsList.isEmpty) {
      districtNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    if (districtNominationsList.any((element) =>
        element.csn.toString() ==
        (context.read<MembershipVM>().currentMember?.districtCandidate ??
            false))) {
      selectedDistrictNominations =
          context.read<MembershipVM>().currentMember?.districtCandidate;
    } else {
      selectedDistrictNominations = null;
    }
    // notifyListeners();
  }

  List<Nomination> districtGsNominationsList = [];
  String? selectedDistrictGsNominations;

  Future searchForDistrictGsNominations(BuildContext context) async {
    // districtGsNominationsList = await DbServices.db
    //     .searchForDistrictNominations(
    //         stateCode: selectedState!.stateCode,
    //         districtCode: selectedDistrict!.districtCode,
    //         contestingFor: "District General Secretary");

    //
    districtGsNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "DGS",
        state: selectedState == null ? '' : selectedState!.stateCode,
        // district: selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        assembly:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        district:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode);
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

    if (districtGsNominationsList.any((element) =>
        element.csn.toString() ==
        (context.read<MembershipVM>().currentMember?.districtGsCandidate ??
            false))) {
      selectedDistrictGsNominations =
          context.read<MembershipVM>().currentMember?.districtGsCandidate;
    } else {
      selectedDistrictGsNominations = null;
    }
    // notifyListeners();
  }

  Future searchForAssemblyNominations(BuildContext context) async {
    // assemblyNominationsList = await DbServices.db.searchForAssemblyNominations(
    //     stateCode: selectedState!.stateCode,
    //     districtCode: selectedDistrict!.districtCode,
    //     assemblyCode: selectedAssembly!.assemblyCode,
    //     contestingFor: "Assembly");

    //
    assemblyNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "VS",
        state: selectedState == null ? '' : selectedState!.stateCode,
        assembly:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        district:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        //  assembly:
        //     selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        // district:
        //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode);
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
    if (assemblyNominationsList.any((element) =>
        element.csn.toString() ==
        (context.read<MembershipVM>().currentMember?.assemblyCandidate ??
            false))) {
      selectedAssemblyNominations =
          context.read<MembershipVM>().currentMember?.assemblyCandidate;
    } else {
      selectedAssemblyNominations = null;
    }
    //notifyListeners();
  }

  Future searchForBlockNominations(BuildContext context) async {
    // blockNominationsList = await DbServices.db.searchForBlockNominations(
    //     stateCode: selectedState!.stateCode,
    //     districtCode: selectedDistrict!.districtCode,
    //     blockCode: selectedBlock?.blockCode ?? "0",
    //     contestingFor: "Block");

    //
    blockNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "MD".toUpperCase(),
        state: selectedState == null ? '' : selectedState!.stateCode,
        district:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        assembly:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        // district:
        //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        // blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode);
    if (result != null) {
      blockNominationsList = result
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
      blockNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }

    //
    if (blockNominationsList.isEmpty) {
      blockNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }
    if (blockNominationsList.any((element) =>
        element.csn.toString() ==
        (context.read<MembershipVM>().currentMember?.blockCandidate ??
            false))) {
      //print("here....................");
      selectedBlockNominations =
          context.read<MembershipVM>().currentMember?.blockCandidate;
    } else {
      selectedBlockNominations = null;
      //notifyListeners();
    }
  }

  String? selectedMandalamNominations;
  List<Nomination> mandalamNominationsList = [];

  Future searchFormandalamNominations(BuildContext context) async {
    // mandalamNominationsList = await DbServices.db.searchForMandalamNominations(
    //     stateCode: selectedState!.stateCode,
    //     districtCode: selectedDistrict!.districtCode,
    //     blockCode: selectedMandalam ?? "",
    //     contestingFor: "Mandalam");

    //
    mandalamNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "MD".toUpperCase(),
        state: selectedState == null ? '' : selectedState!.stateCode,
        district:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        assembly:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        // district:
        //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        // blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
        boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode);
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
    if (mandalamNominationsList.any((element) =>
        element.csn.toString() ==
        (context.read<MembershipVM>().currentMember?.mandalamCandidate ??
            false))) {
      //print("here....................");
      selectedMandalamNominations =
          context.read<MembershipVM>().currentMember?.mandalamCandidate;
    } else {
      selectedMandalamNominations = null;
      //notifyListeners();
    }
  }

  Future searchForBoothNominations(BuildContext context) async {
    // boothNominationsList = await DbServices.db.searchForBoothNominations(
    //     stateCode: selectedState!.stateCode,
    //     districtCode: selectedDistrict!.districtCode,
    //     blockCode: selectedBlock?.blockCode ?? "0",
    //     boothCode: selectedBooth!.boothCode,
    //     contestingFor: "Booth");
    //
    boothNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
      ballot: "MD",
      state: selectedState == null ? '' : selectedState!.stateCode,
      district: selectedDistrict == null ? '' : selectedDistrict!.districtCode,
      blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
      boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode,
      assembly: selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
      // district:
      //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
      mandalam: selectedMandalam,
      // blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
      // boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode
    );
    if (result != null) {
      boothNominationsList = result
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
      boothNominationsList.add(Nomination(
          id: 123456789,
          name: "NOTA",
          csn: 0,
          firstName: "NOTA",
          lastName: ""));
    }
    //
    if (boothNominationsList.isEmpty) {
      boothNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    }

    if (boothNominationsList.any((element) =>
        element.csn.toString() ==
        (context.read<MembershipVM>().currentMember?.boothCandidate ??
            false))) {
      selectedBoothNominations =
          context.read<MembershipVM>().currentMember?.boothCandidate;
    } else {
      selectedBoothNominations = null;
    }
    //notifyListeners();
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
    selectedDistrictNominations = val;
    notifyListeners();
  }

  changeDistrictGsNomination(String val) {
    selectedDistrictGsNominations = val;
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

  changeBlockNomination(String val) {
    selectedBlockNominations = val;
    notifyListeners();
  }

  changeBoothNomination(String val) {
    selectedBoothNominations = val;
    notifyListeners();
  }

  bool declarationStatus = false;

  changeDeclarationStatus(bool value) {
    declarationStatus = value;
    notifyListeners();
  }

  checkForPrefill(BuildContext context) async {
    /// for edit mode fetch data from table
    // selectedState =
    //     Provider.of<ConstituencyInfoVM>(context, listen: false).selectedState!;
    // print(selectedState!.stateCode);
    // statePresidentNominationsList = await DbServices.db
    //     .searchForStateNominations(
    //         stateCode: selectedState!.stateCode,
    //         contestingFor: "State President");
    // statePresidentNominationsList.add(Nomination(
    //     id: 123456789,
    //     name: "NO Vote",
    //     csn: 0,
    //     firstName: "No Vote",
    //     lastName: ""));

    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    selectedStatePresidentNominations =
        membershipRequestModel.statePresidentCandidate;
    debugPrint(membershipRequestModel.statePresidentCandidate);
    selectedStateGSNominations = membershipRequestModel.stateGSCandidate;
    debugPrint(membershipRequestModel.stateGSCandidate);
    return await initialize(context);
  }

  populateModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;
    membershipRequestModel
      ..statePresidentCandidate = selectedStatePresidentNominations
      ..stateGSCandidate = selectedStateGSNominations
      ..districtCandidate = selectedDistrictNominations
      ..districtGsCandidate = selectedDistrictGsNominations
      ..blockCandidate = selectedBlockNominations
      ..mandalamCandidate = selectedMandalamNominations
      ..assemblyCandidate = selectedAssemblyNominations ?? "999"
      ..boothCandidate = selectedBoothNominations;
    context.read<MembershipVM>().setCurrentMember(membershipRequestModel);
  }

  bool validatePage(BuildContext context) {
    selectedStatePresidentNominations == null
        ? showCustomSnackBar("Select State President Nomination", context)
        : selectedStateGSNominations == null
            ? showCustomSnackBar(
                "Select State General Secretary Nomination", context)
            : selectedDistrictNominations == null
                ? showCustomSnackBar("Select District Nomination", context)
                : !declarationStatus
                    ? showCustomSnackBar(
                        "Kindly accept declaration to continue", context)
                    : null;

    bool validated = true; // default value considering block is validated
    if (Provider.of<ConstituencyInfoVM>(context, listen: false).isBlockModel) {
      selectedBlockNominations == null
          ? showCustomSnackBar("select a Block Nomination", context)
          : selectedBoothNominations == null
              ? showCustomSnackBar("select a Booth Nomination", context)
              : null;
      validated =
          selectedBlockNominations != null && selectedBoothNominations != null;
    } else {
      selectedAssemblyNominations == null
          ? showCustomSnackBar("Select Assembly Nomination", context)
          : null;
      validated = selectedAssemblyNominations != null;
    }
    if (["KL", "TL", "KA", "DL", "HP", "HR", "TN", "MB", "TS","MP","GJ"]
        .contains(selectedState!.stateCode)) {
      if (selectedMandalamNominations == null ||
          selectedDistrictGsNominations == null) {
        showCustomSnackBar("Select Candidates Nominations", context);
        return false;
      }
    }

    // if (selectedState?.stateCode == "TS" && declarationStatus) {
    //   return true;
    // } else {
    final result = (selectedStatePresidentNominations != null &&
        selectedStateGSNominations != null &&
        selectedDistrictNominations != null &&
        validated &&
        declarationStatus);
    return result;
    // }
  }

  String? selectedMandalam;

  Future initialize(BuildContext context) async {
    isLoading = true;

    ///getting selected state/district/assembly code
    selectedState =
        Provider.of<ConstituencyInfoVM>(context, listen: false).selectedState!;
    selectedDistrict = Provider.of<ConstituencyInfoVM>(context, listen: false)
        .selectedDistrict;
    selectedAssembly = Provider.of<ConstituencyInfoVM>(context, listen: false)
        .selectedAssembly;
    selectedBlock =
        Provider.of<ConstituencyInfoVM>(context, listen: false).selectedBlock;
    selectedBooth =
        Provider.of<ConstituencyInfoVM>(context, listen: false).selectedBooth;
    selectedMandalam = Provider.of<ConstituencyInfoVM>(context, listen: false)
        .selectedMandalam;

    final result = await Future.wait<dynamic>([
      context
          .read<CandidatesInfoVM>()
          .searchForStatePresidentNominations(context),
      context
          .read<CandidatesInfoVM>()
          .searchForStateGeneralSecreNominations(context),
      context.read<CandidatesInfoVM>().searchForDistrictNominations(context),
      context.read<CandidatesInfoVM>().searchForDistrictGsNominations(context),
      if (["KL", "TL", "KA", "DL", "HP", "HR", "TN", "MB", "TS","MP","GJ"]
          .contains(selectedState!.stateCode))
        context.read<CandidatesInfoVM>().searchFormandalamNominations(context),
      Provider.of<ConstituencyInfoVM>(context, listen: false).isBlockModel
          ? context.read<CandidatesInfoVM>().searchForBlockNominations(context)
          : context
              .read<CandidatesInfoVM>()
              .searchForAssemblyNominations(context),
      context.read<CandidatesInfoVM>().searchForBoothNominations(context),
    ]);
    isLoading = false;
    notifyListeners();
    return result;
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
}
