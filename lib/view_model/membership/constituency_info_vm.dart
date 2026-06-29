import 'package:flutter/cupertino.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/blocks.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/mandalam.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:provider/provider.dart';

import 'membership_vm.dart';

class ConstituencyInfoVM extends ChangeNotifier {
  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>?assemblyList;

  Blocks? selectedBlock;
  List<Blocks>? blocksList;
  List<DropdownItem>? blockListDropDown;

  String? districtCode;
  Districts? selectedDistrict;
  States? selectedState;
  Assembly? selectedAssembly;
  String? membershipId;
  final String defaultState = "Select State";
  final String defaultConstituency = "Select Parliamentary Constituency";
  final String defaultAssembly = "Select Assembly Constituency";
  String selectedStateName = "Select State";
  String? selectedDisName;
  String? selectedAssemblyName;

  List<Mandalam>? mandalamList;
  bool mandalamEnabled = false; //
  String? selectedMandalam;
  List<DropdownItem>? mandalamListDropDown;

  bool isBlockModel =
      false; // upto assembly only instead of upto block and booth if it is true
  bool disableFields = false;
  bool enableDistrictEdit = false;
  List<String> scrutinyCodeList = [];

  List<Booth>? boothsList;
  List<Booth>? defaultBoothsList = null;
  Booth? selectedBooth;
  List<DropdownItem>? boothListDropDown;

  GlobalKey _dropdownButtonKey = GlobalKey();

  get dropdownButtonKey => _dropdownButtonKey;

  void openDropdown() {
    print("open dropdown");
    _dropdownButtonKey.currentContext?.visitChildElements((element) {
      if (element.widget != null && element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget != null && element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
              return;
            });
          }
        });
      }
    });
  }

  void onInit(BuildContext context){
    if (["KL", "TL", "KA", "DL", "HP", "HR", "TN","MB","TS","MP","GJ"].contains(selectedState?.stateCode)) {
      mandalamEnabled = true;
      Log.printDLog("Mandalam Enabled for state ${selectedState?.stateCode}");
    }
    getStatesList(context);
  }

  getStatesList(BuildContext context) async {
    stateList =
        await DbServices.db.getAllStates(true); //fetch all state code condition

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

  getMandalamList() async {
    Log.printILog('Inside Mandalam');
    if (!mandalamEnabled) return;
    Log.printILog('Mandalam enabled');
    mandalamList = await DbServices.db.getAllMandalams(selectedAssembly!, stateCode: selectedState!.stateCode
    );
    if (mandalamList?.isNotEmpty ?? false)
      mandalamListDropDown = List.generate(
          mandalamList!.length,
          (index) => DropdownItem(mandalamList![index].mandalamName,
              mandalamList![index].mandalamCode));
    notifyListeners();
    return true;
  }

  clearMandalams() {
    selectedMandalam = null;
    mandalamList = null;
    mandalamListDropDown = null;
    notifyListeners();
  }

  void changeMandalam(value) {
    selectedMandalam = value;
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
    districtList = await DbServices.db.getAllDistrict(selectedState?.stateCode??'');
    notifyListeners();
    return true;
  }

  getBlocksList() async {
    blocksList = await DbServices.db.getBlocks(selectedDistrict!);
    if (blocksList?.isNotEmpty ?? false)
      blockListDropDown = List.generate(
          blocksList!.length,
          (index) => DropdownItem(
              blocksList![index].blockName, blocksList![index].blockCode));
    notifyListeners();
  }

  getBoothList() async {
    boothsList = await DbServices.db.getBooths(selectedBlock!);
    if (boothsList?.isNotEmpty ?? false)
      boothListDropDown = List.generate(
          boothsList!.length,
          (index) => DropdownItem(
              "${boothsList![index].boothCode}:${boothsList![index].boothName}",
              boothsList![index].boothCode));
    notifyListeners();
  }

  changeSelectedDistrict(Districts district) {
    selectedDistrict = district;
    selectedDisName = district.name;

    clearAssembly();
    notifyListeners();
    getAssemblyList();
    getBlocksList();
  }

  clearDistrict() {
    selectedDisName = defaultConstituency;
    selectedAssemblyName = defaultAssembly;
    selectedDistrict = null;
    selectedAssembly = null;
    selectedBlock = null;
    notifyListeners();
  }
  getAssemblyList() async {
    assemblyList = await DbServices.db.getAllAssembly(selectedDistrict!, stateCode: selectedState?.stateCode
    );
    notifyListeners();
    return true;
  }

  changeSelectedAssembly(Assembly assembly) {
    selectedAssembly = assembly;
    selectedAssemblyName = assembly.name;

    clearMandalams();
    getMandalamList();
    notifyListeners();
  }

  clearAssembly() {
    selectedAssemblyName = defaultAssembly;
    selectedAssembly = null;
    selectedBlock = null;
    selectedBooth = null;
    clearMandalams();
    notifyListeners();
  }

  clearBlock() {
    selectedBlock = null;
    selectedBooth = null;
    notifyListeners();
  }

  void changeBlock(value) {
    selectedBlock =
        blocksList!.firstWhere((element) => element.blockCode == value);
    clearBooth();

    notifyListeners();
    getBoothList();
  }

  clearBooth() {
    selectedBooth = null;
    boothsList = defaultBoothsList;
    boothListDropDown = null;
  }

  refresh() {
    membershipId = "";
    selectedStateName = defaultState;
    selectedState = null;
    clearDistrict();
    notifyListeners();
  }

  createBoothList() async {
    List<Booth> _boothList = List.generate(
        600,
        (index) => Booth(
            id: int.parse((index + 1).toString().padLeft(3, '0')),
            districtCode: "",
            stateCode: "",
            assemblyCode: "",
            blockCode: '',
            boothCode: (index + 1).toString().padLeft(3, '0'),
            boothName: 'Booth No: ${(index + 1).toString().padLeft(3, '0')}'));
    return _boothList;
  }

  creteBoothListDropDown() async {
    List<DropdownItem> _boothListDropDown = List.generate(
        boothsList!.length,
        (index) => DropdownItem(
            "${boothsList![index].boothName}", boothsList![index].boothCode));
    return _boothListDropDown;
  }

  checkForPrefillData(BuildContext context) async {
    BatchMember membershipRequestModel =
        context.read<MembershipVM>().currentMember!;

    /// for edit mode fetch data from table
    ///

    ///set selected state on login
    String stateCode =
        context.read<MembershipVM>().currentMember?.stateCode != null
            ? context.read<MembershipVM>().currentMember!.stateCode!
            : "${await LocalStorageServices().getSTCode()}";

    isBlockModel = AppConstants.blockStatesList.contains(stateCode);
    stateList = await DbServices.db.getAllStates(true);

    stateList!.forEach((element) {
      if (element.stateCode == stateCode) {
        selectedState = element;
      }
    });
    selectedStateName = selectedState!.name;

    if (!AppConstants.blockStatesList.contains(selectedState!.stateCode)) {
      boothsList = await createBoothList();
      boothListDropDown =
          await creteBoothListDropDown(); // create default booth list count 500 if not from block, booth available
    }
    await getDistrictList();

    membershipRequestModel.stateName = selectedState!.name;
    membershipRequestModel.stateCode = selectedState!.stateCode;

    selectedStateName = (membershipRequestModel.stateName == "null" ||
            membershipRequestModel.stateName == null)
        ? defaultState
        : membershipRequestModel.stateName!;

    if (membershipRequestModel.districtCode != null &&
        membershipRequestModel.districtCode != "null")
      selectedDistrict = districtList!.firstWhere((element) =>
          element.districtCode == membershipRequestModel.districtCode);

    selectedDisName = selectedDistrict?.name;
    if (selectedDistrict != null) {
      await getAssemblyList();
      await getBlocksList();
    }
    if (membershipRequestModel.assemblyCode != null &&
        membershipRequestModel.assemblyCode != "null") //null string may populated in db checking
      selectedAssembly = assemblyList!.firstWhere((element) =>
          element.assemblyCode == membershipRequestModel.assemblyCode);
    if (["KL", "TL", "KA", "DL", "HP", "HR" , "TN","TS","MP","GJ"].contains(membershipRequestModel.stateCode)) {
      try{
        await getMandalamList();
      } catch(e){
        Log.printELog(e);
      }

      selectedMandalam = mandalamList
          ?.firstWhere((element) =>
              element.mandalamCode == membershipRequestModel.mandalamCode)
          .mandalamCode;
      notifyListeners();
    }

    if (membershipRequestModel.blockCode != null &&
        membershipRequestModel.blockCode != "")
      selectedBlock = blocksList!.firstWhere(
          (element) => element.blockCode == membershipRequestModel.blockCode);

    if (selectedBlock != null) await getBoothList();

    if (membershipRequestModel.boothCode != null &&
        membershipRequestModel.boothCode!.isNotEmpty &&
        membershipRequestModel.boothCode != "null")
      selectedBooth = boothsList!.firstWhere(
          (element) => element.boothCode == membershipRequestModel.boothCode);

    selectedAssemblyName = selectedAssembly?.name;
    if (membershipRequestModel.scrutinyCode != null) {
      scrutinyCodeList = membershipRequestModel.scrutinyCode!.split(';');
      scrutinyCodeList.forEach((element) {
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
        context.read<MembershipVM>().currentMember!;
    membershipRequestModel
      ..districtCode = selectedDistrict?.districtCode
      ..districtName = selectedDistrict?.name
      ..assemblyCode = selectedAssembly?.assemblyCode
      ..blockCode = selectedBlock?.blockCode
      ..boothCode = selectedBooth?.boothCode
      ..modifiedOn = DateTime.now().toString()
      ..isEditedScrutiny = "0"
      ..assemblyName = selectedAssembly?.name
      ..mandalamCode = selectedMandalam ?? "";
    //TODO: uncomment for refer id primary memnber cross check
    // ..referrerId = selectedState!.isPrimary == "1"
    //     ? membershipRequestModel.memberId
    //     : "";

    /// TODO: need to make booth dynamic
    context.read<MembershipVM>().setCurrentMember(membershipRequestModel);
  }

  bool validatePage(BuildContext context) {
    selectedDistrict == null
        ? showCustomSnackBar("select a District", context)
        // : selectedBlock == null
        //     ? showCustomSnackBar("Select a Block", context)
        : selectedBooth == null
            ? showCustomSnackBar("Select a Booth", context)
            : null;

    bool validated =
        true; // default value considering block/ assembly is validated
    if (isBlockModel) {
      selectedBlock == null
          ? showCustomSnackBar("select a BlocK", context)
          : null;
      validated = selectedBlock != null;
    } else {
      selectedAssembly == null
          ? showCustomSnackBar("select a Assembly", context)
          : null;
      validated = selectedAssembly != null;
    }
    if (["KL", "TL", "KA", "DL", "HP", "HR" , "TN","TS","MP","GJ"].contains(selectedState?.stateCode)) {
      if (selectedMandalam == null) {
        showCustomSnackBar("select a mandalam", context);
        return false;
      }
    }

    return selectedDistrict != null &&
        // selectedBlock != null &&
        selectedBooth != null &&
        validated;
  }

  void changeBooth(String val) {
    selectedBooth =
        boothsList!.firstWhere((element) => element.boothCode == val);
    notifyListeners();
  }
}
