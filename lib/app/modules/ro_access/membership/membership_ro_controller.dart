import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/dio/logging_interceptor.dart';
import 'package:iyc/app/data/resources/repository/ro_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberShipRoController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController mobileId = TextEditingController();

  late TabController tabviewController =
      Get.put(TabController(vsync: this, length: 2));
  int currentIndex = 0;
  void updateCurrentIndex(int index) {
    currentIndex = index;
    update();
  }

  String remarkText = '';
  // bool loadingPage = false;
  bool showVideo = false;

  List<dynamic> batchMapList = [];
  SharedPreferences? sharedPreferences;
  late final RoRepo roRepo;

  List<dynamic> pending = [];
  List<dynamic> completed = [];

  String roId = '';
  List<States>? stateList;
  Map<String, String> category = {
    'G': 'General',
    'B': 'MBC',
    'M': 'Minority',
    'V': 'NT/VJNT',
    'O': 'OBC',
    'S': 'SC',
    'ST': 'T'
  };
  Map<String, String> scrutinyStatus = {
    '0': 'INPROCESS',
    '1': 'ONHOLD',
    '2': 'REJECT'
  };

  Color getStatusColor(String status) {
    if (status == "0") return Color(0xff006400);
    if (status == "1") return Color(0xFFFF8C00);
    if (status == '2') return Colors.red;
    return Colors.black;
  }
  bool enableSearchButton = false;
  bool searchDataFound = false;
  void _onMobileIdChanged() {
    if(mobileId.text.length > 3){
      enableSearchButton = true;
    }else{
      enableSearchButton = false;
    }
    update();
  }

  @override
  void onInit() async {
    mobileId.addListener(_onMobileIdChanged);
    sharedPreferences = await SharedPreferences.getInstance();
    roRepo = RoRepo();
    roRepo.dioClient = DioClient(Urls.baseUrl, Dio(),
        loggingInterceptor: LoggingInterceptor(),
        sharedPreferences: sharedPreferences!);
    roId = await getRoDetails();
    if(roId.isNotEmpty){
      await getNomination();
    }
    await getStatesList();
    update();
    super.onInit();
  }

  String stateName = '';
  String districtName = '';
  String assemblyName = '';
  String mandalamName = '';

  void updateRemark(String value) {
    remarkText = value;
    update();
  }

  void clearSearch(){
    enableSearchButton = false;
    searchDataFound = false;
    getNomination();
  }

  void searchMemberDetails(String roId, String memberId) async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.roSearchMember(roId, memberId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Log.printILog(responseDecoded['response']);
        var membershipList = responseDecoded["response"];
        completed.clear();
        pending.clear();
        for (var i in membershipList) {
          if (i['ro_status'] == 'CORRECT' || i['ro_status'] == 'INCORRECT') {
            completed.add(i);
          } else {
            pending.add(i);
          }
        }
        searchDataFound = true;
        update();
        ProgressDialogUtils.closeDialog();
      }
      else {
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        return ;
      }
    }
    else{
      ProgressDialogUtils.closeDialog();
    }
    return;

  }

  void initData(dynamic nominationDetail) async {
    try {
      stateName = stateList!
          .firstWhere((element) =>
              element.stateCode == '${nominationDetail['state_code']}')
          .name;

      ///--------
      await getDistrictList('${nominationDetail['state_code']}').then((value) {
        districtName = value
            .firstWhere((element) =>
                element.districtCode == '${nominationDetail['district_code']}')
            .name;
      });

      ///---
      await getAssemblyList('${nominationDetail['state_code']}',
              '${nominationDetail['district_code']}')
          .then((value) {
        assemblyName = value
            .firstWhere((element) =>
                element.assemblyCode == '${nominationDetail['assembly_code']}')
            .name;
      });
      Log.printDLog(
          'StateName $stateName, DistrictName:$districtName, AssemblyName:$assemblyName');
    } catch (e) {
    } finally {
      update();
    }
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

  Future<List<Districts>> getDistrictList(String stateCode) async {
    List<Districts> districtList =
        await DbServices.db.getAllDistrict(stateCode);
    Log.printDLog(districtList);
    return districtList;
  }

  Future<List<Assembly>> getAssemblyList(
      String stateCode, String districtCode) async {
    List<Assembly> assemblyList = await DbServices.db.getAllAssembly(
      Districts(
          id: 0,
          districtCode: districtCode,
          name: 'name',
          stateCode: stateCode,
          isEnabled: 'isEnabled'),
    );
    return assemblyList;
  }

  Future<dynamic> getMandalamList(
      String stateCode, String districtCode, String assemblyCode) async {
    var assemblyList = await DbServices.db.getAllMandalams(
      Assembly(
          id: 0,
          districtCode: districtCode,
          name: 'name',
          stateCode: stateCode,
          isEnabled: 'isEnabled',
          assemblyCode: assemblyCode),
    );
    return assemblyList;
  }

  Future<String> getRoDetails() async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.getRoDetails();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded['response'];
      } else {
        ProgressDialogUtils.closeDialog();
        Get.back();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        return '';
      }
    }
    else{
      ProgressDialogUtils.closeDialog();
    }
    return '';
  }

  Future<void> getNomination() async {
    pending.clear();
    completed.clear();
    update();
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.getMembership(roId: roId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        var membershipList = responseDecoded["response"];
        Log.printILog(membershipList.length);
        for (var i in membershipList) {
          if (i['ro_status'] == 'CORRECT' || i['ro_status'] == 'INCORRECT') {
            completed.add(i);
          } else {
            pending.add(i);
          }
        }
        ProgressDialogUtils.closeDialog();
        Get.back();
        update();
      } else {
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    }
    else{
      ProgressDialogUtils.closeDialog();
    }
  }

  Future<void> updateNominationStatus(
      String roId, String memberId, String nominationStatus) async {
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse = await roRepo.updateMembershipStatus(
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

  ///!!!!!!!!!!!!!!!!!!!!!!!![Filter]!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  List<String> selectedFilter = [];

  bool checkFilter(String scrutinyCode){
    for(var i in scrutinyCode.split(';')){
      if(selectedFilter.contains(i)){
        return true;
      }
    }
    return false;
  }

  Map<String, int> reasonFilter = {
    "Invalid ID": 2,
    "Invalid Photo": 21,
    "Invalid Video": 20,
    "Invalid Name/Relative Name": 22,
    "DOB Mismatch": 18,
    "Mobile Duplicate": 5,
    "ID Duplicate": 7,
    "Record Duplicate": 4,
    "ID Rejected": 3,
    "DOB Invalid": 10,
    "Photo Duplicate": 14,
    "No Face in Photo": 13,
  };

  void addFilter(String value) {
    if (selectedFilter.contains(value)) {
      removeFilter(value);
    } else {
      selectedFilter.add(value);
    }
    update();
  }

  void removeFilter(String value) {
    selectedFilter.remove(value);
    update();
  }

  bool valueInSelectedFilter(String value) {
    return selectedFilter.contains(value);
  }

  void clearFilter() {
    selectedFilter.clear();
    update();
    Get.back();
  }
}
