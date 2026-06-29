import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/app/data/resources/repository/voters_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:pinput/pinput.dart';

class SearchVotersListVM extends ChangeNotifier {
  // List<Voter> filteredVotersList = [];
  List<dynamic> voterListData = [];
  List<Voter> allVotersList = [];
  bool loadingResult = false;

  String? selectedParliamentCode;
  String? selectedAssemblyCode;

  String? selectedParliamentName;
  String? selectedAssemblyName;
  List<String> parliamentList = [];
  List<DropdownItem> parliamentDropdownItems = [];
  List<DropdownItem> assemblyDropdownItems = [];
  // List<DropdownItem> districtDropdownItems = [];
  List<DropdownItem> stateDropdownItems = [];

  var votersListMap = [];

  List<Districts>? districtList;
  List<Assembly>? assemblyList;
  List<States>? stateList;
  String? selectedState;
  // String? selectedDistrict;

  String? langCode;
  initVotersList(BuildContext context, String? langCode) async {
    getStatesList();
    this.langCode = langCode;
    await LocalStorageServices()
        .getSelectedParliamentVoterSearch()
        .then((value) async {
      if (value.isNotEmpty) {
        selectedParliamentCode = value;
        selectedParliamentName = await LocalStorageServices()
            .getSelectedParliamentEnglishVoterSearch();
        selectedParliamentLocalName = await LocalStorageServices()
            .getSelectedParliamentLocalLangVoterSearch();
      }
    });
    await LocalStorageServices()
        .getSelectedAssemblyVoterSearch()
        .then((value) async {
      if (value.isNotEmpty) {
        selectedAssemblyCode = value;
        selectedAssemblyName = await LocalStorageServices()
            .getSelectedAssemblyEnglishVoterSearch();
        selectedAssemblyLocalName = await LocalStorageServices()
            .getSelectedAssemblyLocalLangVoterSearch();
      }
    });

    getAssemblyAndParliament(context: context);

    notifyListeners();
    // print(result);
  }

  getAssemblyAndParliament({BuildContext? context}) async {
    var workStateCode = selectedState ??
        'BR'; //await LocalStorageServices().getWorkStateCode();
    if (workStateCode == "") {
      showCustomSnackBar("Work state is not assigned to user", context!);
      return;
    }
    selectedParliamentCode = null;
    parliamentDropdownItems.clear();
    parliamentDropdownItems = await DbServices.db
        .getLocalNamedParliamentsForVoteList(stateCode: workStateCode);
    if (selectedParliamentCode != null) {
      assemblyDropdownItems.clear();
      assemblyDropdownItems = await DbServices.db
          .getLocalNamedAssemblyForVoteList(
              stateCode: selectedState ??
                  'BR', //await LocalStorageServices().getWorkStateCode(),
              loksabhaCode: selectedParliamentCode);
      notifyListeners();
    }
    notifyListeners();
  }

  // getAssemblyList() async {
  //   if (selectedParliamentCode != null)
  //     assemblyDropdownItems = await DbServicesVoter.db.getLocalNamedAssembly(
  //         stateCode: await LocalStorageServices().getWorkStateCode(),
  //         loksabhaCode: selectedParliamentCode);
  //   ;
  //   notifyListeners();
  //   return true;
  // }

  // getParliamentList() async {
  //   parliamentDropdownItems = await DbServicesVoter.db.getDistrictDropDown(
  //       stateCode: await LocalStorageServices().getWorkStateCode());
  //   return true;
  // }

  // Future<void> getDistrictList() async {
  //   districtDropdownItems.clear();
  //   var data =
  //       States(id: 0, name: '', stateCode: selectedState!, isEnabled: '');
  //   var districtList = await DbServices.db.getDistricts(data);
  //   for (var i in districtList) {
  //     districtDropdownItems.add(DropdownItem(i.name, i.districtCode));
  //   }
  //   notifyListeners();
  // }

  getStatesList() async {
    stateDropdownItems.clear();
    // districtDropdownItems.clear();
    parliamentDropdownItems.clear();
    assemblyDropdownItems.clear();
    // selectedDistrict = null;
    selectedAssemblyCode = null;
    selectedParliamentCode = null;
    stateList = await DbServices.db.getAllStates(true); // true pick all states
    for (var i in stateList!) {
      stateDropdownItems.add(DropdownItem(i.name, i.stateCode));
    }
    selectedState = 'BR';
    notifyListeners();
  }

  // onChangeDistrict(String value) async {
  //   selectedDistrict = value;
  //   selectedAssemblyCode = null;
  //   selectedParliamentCode = null;
  //   parliamentDropdownItems.clear();
  //   assemblyDropdownItems.clear();
  //   //
  //   selectedAssemblyLocalName = null;
  //   selectedAssemblyName = null;
  //   selectedParliamentLocalName = null;
  //   selectedParliamentName = null;
  //   await getDistrictList();
  //   await getAssemblyAndParliament();
  // }

  onChangeState(String value) async {
    selectedState = value;
    // selectedDistrict = null;
    selectedAssemblyCode = null;
    selectedParliamentCode = null;
    //
    selectedAssemblyLocalName = null;
    selectedAssemblyName = null;
    selectedParliamentLocalName = null;
    selectedParliamentName = null;

    //
    // districtDropdownItems.clear();
    parliamentDropdownItems.clear();
    assemblyDropdownItems.clear();
    // await getDistrictList();
    await getAssemblyAndParliament();
  }

  changeParliament(String parliament) async {
    selectedParliamentCode = parliament;
    selectedAssemblyCode = null;
    selectedAssemblyLocalName = null;
    selectedAssemblyName = null;
    assemblyDropdownItems.clear();
    assemblyDropdownItems = await DbServices.db
        .getLocalNamedAssemblyForVoteList(
            stateCode: selectedState ??
                'BR', //await LocalStorageServices().getWorkStateCode(),
            loksabhaCode: selectedParliamentCode);
    notifyListeners();
  }

  String? selectedAssemblyLocalName;
  String? selectedParliamentLocalName;

  changeAssembly(String assembly) {
    selectedAssemblyCode = assembly;
    notifyListeners();
    selectedAssemblyName = assemblyDropdownItems
        .firstWhere((element) => element.value == selectedAssemblyCode)
        .englishLangName;
    selectedAssemblyLocalName = assemblyDropdownItems
            .firstWhere((element) => element.value == selectedAssemblyCode)
            .localLangName ??
        "";

    selectedParliamentName = parliamentDropdownItems
        .firstWhere((element) => element.value == selectedParliamentCode)
        .englishLangName;
    selectedParliamentLocalName = parliamentDropdownItems
            .firstWhere((element) => element.value == selectedParliamentCode)
            .localLangName ??
        "";

    Future.wait([
      LocalStorageServices().setSelectedAssemblyVoterSearch(assembly),
      LocalStorageServices()
          .setSelectedParliamentVoterSearch(selectedParliamentCode!),
      LocalStorageServices()
          .setSelectedAssemblyEnglishVoterSearch(selectedAssemblyName!),
      LocalStorageServices()
          .setSelectedParliamentEnglishVoterSearch(selectedParliamentName!),
      if (selectedParliamentLocalName?.isNotEmpty ?? false)
        LocalStorageServices().setSelectedParliamentLocalLangVoterSearch(
            selectedParliamentLocalName!),
      if (selectedAssemblyLocalName?.isNotEmpty ?? false)
        LocalStorageServices()
            .setSelectedAssemblyLocalLangVoterSearch(selectedAssemblyLocalName!)
    ]);
  }

  searchVoter(BuildContext context, String keyword) async {
    FocusScope.of(context).unfocus();
    loadingResult = true;
    notifyListeners();

    final apiResponse = await VotersRepo().getVotersList(
      keyword,
      selectedVoterSearchType == 0 ? "NAME" : "EPIC",
      selectedState ?? 'BR',
      selectedAssemblyCode,
      selectedParliamentCode,
      selectedAssemblyName ?? "",
      selectedParliamentName ?? "",
      selectedAssemblyLocalName,
      selectedParliamentLocalName,
      langCode,
    );
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        loadingResult = false;
        voterListData = responseDecoded["response"];
        // filteredVotersList = votersListFromJson(responseDecoded["response"]);

        notifyListeners();
      } else {
        loadingResult = false;
        notifyListeners();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  Timer? _timer;
  String? previousKeyword;

  searchVoterByKeyword(String keyword, BuildContext context,
      {int? throttleTime}) {
    _timer?.cancel();
    if (keyword.isNotEmpty) {
      previousKeyword = keyword;
      _timer =
          Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
        searchVoter(context, keyword);
        _timer?.cancel();
      });
    }
  }

  void clearVoterList() {
    allVotersList.clear();
    voterListData.clear();
    // filteredVotersList.clear();
    notifyListeners();
  }

  bool showSearch = false;

  void idControllerListner(TextEditingController controller) {
    if (controller.length > 0) {
      showSearch = true;
    } else {
      showSearch = false;
    }
    notifyListeners();
  }

  int selectedVoterSearchType = 0;

  void changeVoterSearchType(int? index) {
    if (index != null) selectedVoterSearchType = index;
    notifyListeners();
  }
}
