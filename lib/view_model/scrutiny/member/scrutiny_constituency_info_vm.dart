import 'package:iyc/utils/scrutiny_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/provider/scrutiny/member/scrutiny_member_edit_vm.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

import '../../../di_container.dart';

class ScrutinyConstituencyInfoVM extends ChangeNotifier {
  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>? assemblyList;

  String? districtCode;
  Districts? selectedDistrict;
  States? selectedState;
  Assembly? selectedAssembly;
  String? membershipId;
  final String defaultState = "Select State";
  final String defaultConstituency = "Select Parliamentary Constituency";
  final String defaultAssembly = "Select Assembly Constituency/Block";
  String selectedStateName = "Select State";
  String? selectedDisName;
  String? selectedAssemblyName;

  bool disableFields = false;
  bool enableDistrictEdit = false;
  List<String> scrutinyCodeList = [];

  getStatesList() async {
    stateList = await DbServices.db.getAllStates();

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

  // changeSelectedState(States state) {
  //   selectedState = state;
  //   selectedStateName = state.name;
  //   // searchForStateNominations(state.stateCode);
  //   clearDistrict();
  //   notifyListeners();
  //   getDistrictList();
  // }
  // searchForStateNominations(String mStateCode) async {
  //   print("start");
  //   await DbServices.db.searchForStateNominations(
  //       AppConstants.TBL_NOMINATION_CSN,
  //       "State General Secretary",
  //       AppConstants.TBL_NOMINATION_CSN_CONTESTING_FOR,
  //       mStateCode,
  //       AppConstants.TBL_NOMINATION_CSN_STATE_CODE);
  //   print("----");
  //   notifyListeners();
  // }
  getDistrictList() async {
    districtList = await DbServices.db.getDistricts(selectedState!);
    notifyListeners();
    return true;
  }

  changeSelectedDistrict(Districts district) {
    selectedDistrict = district;
    selectedDisName = district.name;

    clearAssembly();
    notifyListeners();
    getAssemblyList();
  }

  clearDistrict() {
    selectedDisName = defaultConstituency;
    selectedAssemblyName = defaultAssembly;
    selectedDistrict = null;
    selectedAssembly = null;
    notifyListeners();
  }

  getAssemblyList() async {
    assemblyList = await DbServices.db.getAssembly(selectedDistrict!);
    notifyListeners();
    return true;
  }

  changeSelectedAssembly(Assembly assembly) {
    selectedAssembly = assembly;
    selectedAssemblyName = assembly.name;
    notifyListeners();
  }

  clearAssembly() {
    selectedAssemblyName = defaultAssembly;
    selectedAssembly = null;
    notifyListeners();
  }

  refresh() {
    membershipId = "";
    selectedStateName = defaultState;
    selectedState = null;
    clearDistrict();
    notifyListeners();
  }

  checkForPrefillData(BuildContext context) async {
    /// for edit mode fetch data from table
    ///
    stateList = await DbServices.db.getAllStates();

    ///set selected state on login
    String stateCode =
        context.read<ScrutinyMembershipEditVM>().currentMember!.stateCode !=
                null
            ? context.read<ScrutinyMembershipEditVM>().currentMember!.stateCode!
            : "${await LocalStorageServices().getSTCode()}";
    stateList!.forEach((element) {
      if (element.stateCode == stateCode) {
        selectedState = element;
      }
    });
    selectedStateName = selectedState!.name;
    await getDistrictList();
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    membershipRequestModel.stateName = selectedState!.name;
    membershipRequestModel.stateCode = selectedState!.stateCode;

    selectedStateName = (membershipRequestModel.stateName == "null" ||
            membershipRequestModel.stateName == null)
        ? defaultState
        : membershipRequestModel.stateName!;

    /// Bare firstWhere calls here threw "Bad state: No element" and killed the
    /// page whenever a member's district/assembly wasn't in the local list.
    if (membershipRequestModel.districtCode != null &&
        membershipRequestModel.districtCode != "null") {
      for (final district in districtList ?? []) {
        if (district.districtCode == membershipRequestModel.districtCode) {
          selectedDistrict = district;
          break;
        }
      }
    }

    selectedDisName = selectedDistrict?.name;
    if (selectedDistrict != null) await getAssemblyList();
    if (membershipRequestModel.assemblyCode != null &&
        membershipRequestModel.assemblyCode != "null") {
      for (final assembly in assemblyList ?? []) {
        if (assembly.assemblyCode == membershipRequestModel.assemblyCode) {
          selectedAssembly = assembly;
          break;
        }
      }
    }

    selectedAssemblyName = selectedAssembly?.name;
    if (membershipRequestModel.scrutinyCode != null) {
      scrutinyCodeList = ScrutinyCodes.parse(membershipRequestModel.scrutinyCode);
      print("---scrutinyCode");
      scrutinyCodeList.forEach((element) {
        print(element);
        if (element == "2") {
          disableFields = true;
        }
        if (element == "9") {
          disableFields = true;
        }
        if (element == "1") {
          enableDistrictEdit = true;
          disableFields = true;
        }
      });
    }
    notifyListeners();
    return true;
  }

  populateIntoModel(BuildContext context) {
    BatchMember membershipRequestModel =
        context.read<ScrutinyMembershipEditVM>().currentMember!;
    membershipRequestModel
      ..districtCode = selectedDistrict?.districtCode
      ..districtName = selectedDistrict?.name
      ..assemblyCode = selectedAssembly?.assemblyCode
      ..modifiedOn = DateTime.now().toString()
      ..isEditedScrutiny = "0"
      ..assemblyName = selectedAssembly?.name;
    context
        .read<ScrutinyMembershipEditVM>()
        .setCurrentMember(membershipRequestModel);
  }

  bool validatePage(BuildContext context) {
    selectedDistrict == null
        ? showCustomSnackBar("select a Parliamentary", context)
        : selectedAssembly == null
            ? showCustomSnackBar("Select an Assembly", context)
            : null;
    return selectedDistrict != null && selectedAssembly != null;
  }
}
