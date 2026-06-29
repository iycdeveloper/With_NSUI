import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/dio/logging_interceptor.dart';
import 'package:iyc/app/data/resources/repository/ro_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ROAccessController extends GetxController {
  TextEditingController mobileId = TextEditingController();

//for edit
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool disableFields = false;
  String? selectedGender;
  String? selectedDate;
  DateTime eventDate = DateTime.now();
  bool enableDOBEdit = false;
  List<DropdownItem> genders = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
    DropdownItem("Other", "O"),
  ];
  String? selectedCategory;
  List<Category>? categoryList;

  Districts? selectedEditDistrict;
  Assembly? selectedEditAssembly;
  String? selectedEditMandalam;
  List<Districts>? districtListEditScreen;
  getDistrictListeditScreen() async {
    // districtList = await DbServices.db.getDistrict(selectedState!);
    districtListEditScreen =
        await DbServices.db.getAllDistrict(nominationEditDetails['state']);
    Log.printILog(selectedState!.stateCode);
    Log.printILog(districtListEditScreen!.length);
    update();
    return true;
  }

  changeSelectedDistrict(Districts district) {
    selectedEditDistrict = district;
    // selectedDisName = district.name;

    // clearAssembly();
    selectedEditAssembly = null;
    selectedEditMandalam = null;
    assemblyListeditScreen = [];
    mandalamListEditDropDown = [];
    update();
    getAssemblyListEditScreen();
  }

  getMandalamListEditScreen() async {
    var mandalamList = await DbServices.db.getAllMandalams(
        selectedEditAssembly!,
        stateCode: nominationEditDetails['state']);
    if (mandalamList.isNotEmpty) {
      mandalamListEditDropDown = List.generate(
          mandalamList.length,
          (index) => DropdownItem(mandalamList[index].mandalamName,
              mandalamList[index].mandalamCode));
    }
    update();
  }

  clearAssembly() {
    // selectedAssemblyName = defaultAssembly;
    selectedEditAssembly = null;
    update();
  }

  List<DropdownItem>? mandalamListEditDropDown;

  List<Assembly>? assemblyListeditScreen;

  getAssemblyListEditScreen() async {
    assemblyListeditScreen = await DbServices.db.getAllAssembly(
        selectedEditDistrict!,
        stateCode: nominationEditDetails['state'].toString());
    update();
    return true;
  }

  changeSelectedAssemblyEditScreen(Assembly assembly) {
    selectedEditAssembly = assembly;
    // selectedAssemblyName = assembly.name;
    selectedEditMandalam = null;
    getMandalamListEditScreen();
    update();
  }

  changeGender(String val) {
    selectedGender = val;
    update();
  }

  changeCategory(String val) {
    selectedCategory = val;
    update();
  }

  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    update();
  }

  dynamic nominationEditDetails;
  clearAllEditScreen() {
    selectedEditAssembly = null;
    selectedEditCandidature = null;
    selectedEditDistrict = null;
    selectedEditMandalam = null;
    // mandalamListEditDropDown!.clear();
  }

  editInitcall(dynamic nominationDetails2) async {
    clearAllEditScreen();
    nominationEditDetails = nominationDetails2;
    var assemblyList = await DbServices.db
        .getAllAssemblyByState(nominationEditDetails['state']);
    for (var i in assemblyList) {
      if (i.name == nominationEditDetails['as_name']) {
        selectedEditAssembly = i;
      }
    }
    var districtList =
        await DbServices.db.getAllDistrict(nominationEditDetails['state']);
    for (var i in districtList) {
      if (i.name == nominationEditDetails['ds_name']) {
        selectedEditDistrict = i;
      }
    }

    var mandalamList = await DbServices.db.getAllMandalams(
        selectedEditAssembly!,
        stateCode: nominationEditDetails['state']);
    for (var i in mandalamList) {
      if (i.mandalamName == nominationEditDetails['mandalam_name']) {
        selectedEditMandalam = i.mandalamCode;
        // mandalamListEditDropDown
      }
    }
    // await Future.delayed(const Duration(microseconds: 100));
    getDistrictListeditScreen();
    getAssemblyListEditScreen();
    getMandalamListEditScreen();
    usernameController.text = nominationDetails2['first_name'];
    lastNameController.text = nominationDetails2['last_name'];
    if (nominationDetails2['gender'] != null) {
      DropdownItem result = genders
          .where((test) => test.value == nominationDetails2['gender'])
          .first;
      selectedGender = result.value;
    }
    if (nominationDetails2['dob'] != null) {
      DateTime date = DateFormat("dd/MM/yyyy").parse(nominationDetails2['dob']);
      selectedDate = "${date.day}-${date.month}-${date.year}";
    }

    if (nominationDetails2['category'] != null) {
      Category result = categoryList!
          .where((test) => nominationDetails2['category'] == test.categoryCode)
          .first;
      selectedCategory = result.categoryCode;
    }
    DropdownItem result2 = candidateLevelList
        .where((test) =>
            test.name.toLowerCase() ==
            nominationDetails2['contesting_for'].toString().toLowerCase())
        .first;
    selectedEditCandidature = result2.value;
    // update();
  }

  bool validateEditpage() {
    if (firstFormKey.currentState!.validate()) {
    } else {
      return false;
    }
    if (selectedGender == null) {
      CustomSnackBar.showErrorSnackBar('Select Gender');
      return false;
    }
    if (selectedCategory == null) {
      CustomSnackBar.showErrorSnackBar('Select Category');
      return false;
    }
    if (selectedDate == null) {
      CustomSnackBar.showErrorSnackBar('Select DOB');
      return false;
    }

    if (selectedEditCandidature == null) {
      CustomSnackBar.showErrorSnackBar('Select Ballot');
      return false;
    }

    if (selectedEditDistrict == null) {
      CustomSnackBar.showErrorSnackBar('Select District');
      return false;
    }
    if (selectedEditAssembly == null) {
      CustomSnackBar.showErrorSnackBar('Select Assembly');
      return false;
    }
    if (selectedEditMandalam == null) {
      CustomSnackBar.showErrorSnackBar('Select Mandalam');
      return false;
    }

    return true;
  }

  void onEditSubmit(BuildContext context) {
    if (validateEditpage()) {
      editValidate(context);
    }
  }

  editValidate(BuildContext context) async {
    String memberlevelid = '';
    if (selectedEditCandidature == 'STATE PRESIDENT') {
      memberlevelid = '10';
      update();
    } else if (selectedEditCandidature == 'STATE GENERAL SECRETARY') {
      memberlevelid = '20';
      update();
    } else if (selectedEditCandidature == 'DISTRICT PRESIDENT') {
      memberlevelid = '30';
      update();
    } else if (selectedEditCandidature == 'DISTRICT GENERAL SECRETARY') {
      memberlevelid = '80';
      update();
    } else if (selectedEditCandidature == 'ASSEMBLY') {
      memberlevelid = '40';
      update();
    } else {
      memberlevelid = '50';
      update();
    }

    // String assemblycode = '';
    // String districcode = '';
    // Assembly? assemblyList2;
    // String mandalamcode = '';

    // var assemblyList = await DbServices.db
    //     .getAllAssemblyByState(nominationEditDetails['state']);
    // for (var i in assemblyList) {
    //   if (i.name == nominationEditDetails['as_name']) {
    //     assemblyList2 = i;
    //   }
    // }
    // var districtList =
    //     await DbServices.db.getAllDistrict(nominationEditDetails['state']);
    // for (var i in districtList) {
    //   if (i.name == nominationEditDetails['ds_name']) {
    //     districcode = i.districtCode;
    //   }
    // }

    // var mandalamList = await DbServices.db.getAllMandalams(assemblyList2!,
    //     stateCode: nominationEditDetails['state']);
    // for (var i in mandalamList) {
    //   if (i.mandalamName == nominationEditDetails['mandalam_name']) {
    //     mandalamcode = i.mandalamCode;
    //   }
    // }

    Map<String, String> data = {
      "RO_ID": roId,
      "MEMBER_ID": nominationEditDetails['member_id'],
      "STATE_CODE": nominationEditDetails['state'],
      "DISTRICT_CODE": selectedEditDistrict!.districtCode,
      "ASSEMBLY_CODE": selectedEditAssembly!.assemblyCode,
      "MANDALAM_CODE": selectedEditMandalam!,
      "CONTESTING_FOR": selectedEditCandidature!,
      "MASTER_LEVEL_ID": "$memberlevelid",
      "FIRST_NAME": usernameController.text,
      "LAST_NAME": lastNameController.text,
      "DOB": "${eventDate.day}/${eventDate.month}/${eventDate.year}",
      "GENDER": "$selectedGender",
      "CATEGORY": selectedCategory!
    };
    Log.printELog(data);
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.editNominationDetails(data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        Get.back();
        CustomSnackBar.showSuccessSnackBar('Assignment added successfully');
      } else {
        Get.back();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    } else {
      Get.back();
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
  }
//

  bool loadingPage = false;
  bool showVideo = false;

  List<dynamic> batchMapList = [];
  SharedPreferences? sharedPreferences;
  late final RoRepo roRepo;

  States? selectedState;
  String? selectedDistrict;
  Districts? selectedDistrict1;
  String? selectedAssembly;
  String? selectedMandalamBlockWard;
  String? selectedCandidature;
  String? selectedEditCandidature;

  List<States>? stateList;
  List<DropdownItem> districtDropdownItems = [];
  List<DropdownItem> assemblyDropdownItems = [];
  List<DropdownItem> mandalamDropdownItems = [];
  List<DropdownItem> candidatureDropdownItems = [];

  List<dynamic> nominationDetails = [];

  dynamic selectedNomination;

  Map<String, String> category = {
    'G': 'General',
    'B': 'MBC',
    'M': 'Minority',
    'V': 'NT/VJNT',
    'O': 'OBC',
    'S': 'SC',
    'ST': 'T'
  };

  List<DropdownItem> candidateLevelList = [
    DropdownItem("State President", "STATE PRESIDENT"),
    DropdownItem("State General Secretary", "STATE GENERAL SECRETARY"),
    DropdownItem("District President", "DISTRICT PRESIDENT"),
    DropdownItem("District General Secretary", "DISTRICT GENERAL SECRETARY"),
    DropdownItem("Assembly/Ward", "ASSEMBLY"),
    DropdownItem("Mandalam/Block/Ward", "MANDALAM")
  ];

  String roId = '';

  void updateRemark(String value) {
    remarkText = value;
    update();
  }

  Color getStatusColor(String status) {
    if (status == "ACCEPT") return Colors.green;
    if (status == "ONHOLD") return Colors.yellow;
    if (status == 'REJECT') return Colors.red;
    return Colors.black;
  }

  @override
  void onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    roRepo = RoRepo();
    roRepo.dioClient = DioClient(Urls.baseUrl, Dio(),
        loggingInterceptor: LoggingInterceptor(),
        sharedPreferences: sharedPreferences!);
    await getStatesList();
    categoryList = await DbServices.db.getAllCategory();

    roId = await getRoDetails();
    update();
    super.onInit();
  }

  void updateShowVideo(bool value) {
    showVideo = value;
    update();
  }

  Future<void> getStatesList() async {
    var tempStateList = await DbServices.db.getAllStates(true);
    stateList = [];
    for (var i in tempStateList) {
      if (['TS', 'U1', 'U2', 'U3'].contains(i.stateCode)) {
      } else {
        stateList!.add(i);
      }
    }
    update();
  }

  Future<void> getDistrictList() async {
    districtDropdownItems.clear();
    var districtList =
        await DbServices.db.getAllDistrict(selectedState!.stateCode);

    for (var i in districtList) {
      districtDropdownItems.add(DropdownItem(i.name, i.districtCode));
    }
    update();
  }

  Future<void> getAssemblyList() async {
    assemblyDropdownItems.clear();
    var assemblyList = await DbServices.db.getAllAssembly(
      Districts(
          id: 0,
          districtCode: selectedDistrict!,
          name: 'name',
          stateCode: selectedState!.stateCode,
          isEnabled: 'isEnabled'),
    );
    for (var i in assemblyList) {
      assemblyDropdownItems.add(DropdownItem(i.name, i.assemblyCode));
    }
    update();
  }

  Future<void> getMandalamList() async {
    mandalamDropdownItems.clear();
    var assemblyList = await DbServices.db.getAllMandalams(
      Assembly(
          id: 0,
          districtCode: selectedDistrict!,
          name: 'name',
          stateCode: selectedState!.stateCode,
          isEnabled: 'isEnabled',
          assemblyCode: selectedAssembly!),
    );
    for (var i in assemblyList) {
      mandalamDropdownItems.add(DropdownItem(i.mandalamName, i.mandalamCode));
    }
    update();
  }

  void onChangeState(States value) async {
    Log.printDLog('Selected state ${value.stateCode}');
    selectedState = value;
    selectedDistrict = null;
    selectedAssembly = null;
    selectedMandalamBlockWard = null;
    districtDropdownItems.clear();
    assemblyDropdownItems.clear();
    mandalamDropdownItems.clear();
    await getDistrictList();
    update();
  }

  void changeDistrict(String district) async {
    selectedDistrict = district;
    selectedAssembly = null;
    selectedMandalamBlockWard = null;
    mandalamDropdownItems.clear();
    assemblyDropdownItems.clear();
    var assemblyList = await DbServices.db.getAllAssembly(
        Districts(
            id: 0,
            districtCode: selectedDistrict!,
            name: 'name',
            stateCode: selectedState!.stateCode,
            isEnabled: 'isEnabled'),
        stateCode: selectedState!.stateCode);
    for (var i in assemblyList) {
      assemblyDropdownItems.add(DropdownItem(i.name, i.assemblyCode));
    }
    // await getAssemblyList();
    update();
  }

  void changeAssembly(String assembly) async {
    selectedAssembly = assembly;
    selectedMandalamBlockWard = null;
    await getMandalamList();
    update();
  }

  void changeMandalameditscreen(value) {
    selectedEditMandalam = value;
    update();
  }

  void changeMandalam(String mandalam) async {
    selectedMandalamBlockWard = mandalam;
    update();
  }

  void changeCandidature(String candidature) async {
    if (selectedCandidature == candidature) return;
    selectedCandidature = candidature;
    // selectedState = null;
    selectedDistrict = null;
    selectedAssembly = null;
    selectedMandalamBlockWard = null;
    update();
  }

  void changeEditCandidature(String candidature) async {
    if (selectedEditCandidature == candidature) return;
    selectedEditCandidature = candidature;
    update();
  }

  void showNominationDetail(dynamic nominationDetail) {
    selectedNomination = nominationDetail;
    update();
  }

  Future<String> getRoDetails() async {
    loadingPage = true;
    ApiResponse apiResponse = await roRepo.getRoDetails();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        loadingPage = true;
        update();
        return responseDecoded['response'];
      } else {
        loadingPage = false;
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        return '';
      }
    }
    return '';
  }

  Future<void> getNomination() async {
    nominationDetails.clear();
    update();
    if (selectedState == null) {
      CustomSnackBar.showErrorSnackBar('Select state');
      return;
    }
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.getNomination(
        roId: roId,
        ballot: selectedCandidature,
        state: selectedState!.stateCode,
        district: selectedDistrict,
        assembly: selectedAssembly,
        mandalam: selectedMandalamBlockWard);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        nominationDetails = responseDecoded["response"];
        ProgressDialogUtils.closeDialog();
        update();
      } else {
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

  String remarkText = '';

  Future<void> updateNominationStatus(
      String roId, String memberId, String nominationStatus) async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.updateNominationStatus(
        roId, memberId, nominationStatus, remarkText);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        getNomination();
        Get.back();
        Get.back();
        CustomSnackBar.showSuccessSnackBar(responseDecoded['response']);
      } else {
        ProgressDialogUtils.closeDialog();
        getNomination();
        Get.back();
        Get.back();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }

  Future<void> searchRoPaymentStatus(String str) async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.checkRoPayment(str);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Get.back();
        batchMapList = responseDecoded["response"];
        update();
      } else {
        Get.back();
        update();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
  }
}
