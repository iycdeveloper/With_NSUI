import 'dart:convert';
import 'dart:io';
import 'package:iyc/app/data/resources/remote/dio/logging_interceptor.dart';
import 'package:iyc/app/data/resources/repository/constant_repo.dart';
import 'package:iyc/app/data/resources/repository/election_contest_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/nyay_guarantee/local_widget/form_success_bootom_sheet.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/upload_document.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/nusi/app/modules/home/screens/home_controller_nsui.dart';
import 'package:iyc/nusi/app/modules/profile/widgets/profile_success_bootom_sheet_nsui.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/auth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:dio/dio.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileNSUIController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController noOfVoteObtain = TextEditingController();
  TextEditingController subcasteController = TextEditingController();
  String? selectedDate;
  String? pickedVoterPath;
  File? pickedVoter;
  String? selectedElectionLevel;

  List<DropdownItem> electionLevel = [
    DropdownItem('Parliament', 'Parliament'),
    DropdownItem('Assembly', 'Assembly'),
    DropdownItem('Panchayat/Municipal', 'Panchayat/Municipal'),
  ];
  DateTime eventDate = DateTime.now();

  String? selectedResult;

  List<DropdownItem> result = [
    DropdownItem('Won', 'Won'),
    DropdownItem('Lost', 'Lost'),
  ];

  onchangebottombar() {
    // Get.find<HomeNSUIController>().dispose();
    // Get.find<HomeNSUIController>().motionTabBarController!.index = 0;
    Get.put(HomeNSUIController()).selectedTabIndex.value = 0;
    update();
  }

  String? selectedCategory;
  List<DropdownItem> categoryList = [
    DropdownItem("General", "G"),
    DropdownItem("MBC", "B"),
    DropdownItem("Minority", "M"),
    DropdownItem("NT/VJNT", "V"),
    DropdownItem("OBC", "O"),
    DropdownItem("SC", "S"), //
    DropdownItem("ST", "T"), //
    // DropdownItem("Physically Handicapped", "PH"),
    DropdownItem("Others", "OT"),
  ];

  changeCategory(String val) {
    selectedCategory = val;
    update();
  }

  void onChangeResult(String value) {
    selectedResult = value;
    update();
  }

  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    update();
  }

  String? mobileNumber;

  bool loadingData = true;
  List<dynamic> electionData = [];

  Future<void> viewElectionContData() async {
    loadingData = true;
    update();
    Map<String, String> viewPanchayatData = {
      "V": AppConstants.iycVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
      "LATITUDE":
          "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE":
          "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
      // "YOUTH_JODO_TYPE": "EM"
    };
    ApiResponse apiResponse =
        await ElectionContestRepo().viewElectionContestData(viewPanchayatData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        electionData = responseDecoded['response'];
        update();
      } else {
        // CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    } else {
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
    loadingData = false;
    update();
  }

  Future<void> getStatesList() async {
    // var tempStateList = await DbServices.db.getAllStates(true);
    stateList = [];
    // var tempStateList = [];
    var result = await getStateBallots();
    if (result == null) {
      stateList = [];
    } else {
      stateList = [];
      for (var i in result) {
        stateList.add(States(
            id: 0,
            name: i['state_name'],
            stateCode: i['state_code'],
            isEnabled: ''));
      }
    }
    // for (var i in tempStateList) {
    //   if (['TS', 'U1', 'U2', 'U3'].contains(i.stateCode)) {
    //   } else {
    // stateList.add(i);
    //   }
    // }
    update();
  }

  String? selectedYear;
  List<DropdownItem> year = [];

  void initYearDropDown() {
    for (int i = 1990; i <= 2030; i++) {
      year.add(DropdownItem('$i', '$i'));
    }
    update();
  }

  pickVoterDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType, BuildContext context) async {
    Log.printILog('Starting taking profile photo');
    //  FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await ImageServices().pickImage(imageSource);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      File image;
      image = File(result.path);
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      switch (documentType) {
        case DocumentType.amImage:
          pickedVoter = _image;
          pickedVoterPath = pickedVoter!.path;
          // uploadDocumentAmPhoto(pickedVoterPath!, userDetail!.mobile);
          update();
          break;
        case DocumentType.idFront:
          // TODO: Handle this case.
          break;
        case DocumentType.idBack:
          // TODO: Handle this case.
          break;
        case DocumentType.category:
          // TODO: Handle this case.
          break;
        case DocumentType.bpl:
          // TODO: Handle this case.
          break;
        case DocumentType.caseFile:
          // TODO: Handle this case.
          break;
        case DocumentType.amVideo:
          // TODO: Handle this case.
          break;
        case DocumentType.dob:
          // TODO: Handle this case.
          break;
        case DocumentType.barCouncilId:
          // TODO: Handle this case.
          break;
      }
      update();
    } else {
      print("file picked not");
      return null;
    }
  }

  void onChangeElectionLevel(String value) {
    selectedElectionLevel = value;
    update();
  }

  void onChangeYear(String value) {
    selectedYear = value;
    update();
  }

  bool validateForm(BuildContext context) {
    if (selectedElectionLevel == null) {
      // CustomSnackBar.showErrorSnackBar('Select level of election');
      Get.snackbar('Error', 'Select level of election',
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (noOfVoteObtain.text.isEmpty) {
      // CustomSnackBar.showErrorSnackBar('Enter no of vote obtained');
      Get.snackbar('Error', 'Enter no of vote obtained',
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (selectedYear == null) {
      // CustomSnackBar.showErrorSnackBar('Select year');
      Get.snackbar('Error', 'Select year',
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (selectedResult == null) {
      // CustomSnackBar.showErrorSnackBar('Select result');
      Get.snackbar('Error', 'Select result',
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (pickedVoterPath == null) {
      // CustomSnackBar.showErrorSnackBar('Select photo of the election resul');
      Get.snackbar('Error', 'Select photo of the election resul',
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.red,
          colorText: Colors.black,
          duration: Duration(seconds: 3),
          icon: Icon(Icons.error),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

  List<Map<String, String>> electionDetails = [];

  void onSubmit(BuildContext context) async {
    if (validateForm(context)) {
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      // String timeStamp2 = DateTime.now().mill.toString();

      Map<String, String> addPanchayatData = {
        "V": AppConstants.iycVersion,
        "ORG": AppConstants.orgName,
        "SESSION_ID": await LocalStorageServices().getSessionId(),
        "DEVICE_ID": await getDeviceIdentifier(),
        "USER_ID": await LocalStorageServices().getUserId(),
        //   "LATITUDE":
        //     "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
        // "LONGITUDE":
        //     "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
        "ELECTION_LEVEL": "$selectedElectionLevel",
        "VOTES": noOfVoteObtain.text,
        "YEAR": "$selectedYear",
        "RESULT": "$selectedResult",
        "PHOTO_LINK":
            "${mobileNumber!}_$timeStamp.${pickedVoterPath!.split('.').last}",
        // "YOUTH_JODO_TYPE": "EM"
      };
      Log.printELog(addPanchayatData);
      // ProgressDialogUtils.showProgressIndicator();
      ApiResponse apiResponse =
          await ElectionContestRepo().addElectioncontest(addPanchayatData);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
        if (responseDecoded['status'] == "SUCCESS") {
          await uploadDocument(pickedVoterPath, "PROFILE",
              '${mobileNumber!}_$timeStamp.${pickedVoterPath!.split('.').last}');

          // await uploadDocument(pickedVideoPathValue, "CHALOPANCHAYAT",
          //     '${mobileNumber!}_$timeStamp.${pickedVideoPathValue!.split('.').last}');
          ProgressDialogUtils.closeDialog();
          Get.back();
          // await viewElectionContData();
          campaignSuccessBottomSheet(message: 'Data added successfully');
          clearForm();
        } else {
          // Get.back();
          CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        }
      } else {
        // Get.back();
        CustomSnackBar.showErrorSnackBar(apiResponse.error);
      }
      // var data = {
      //   "level": "$selectedElectionLevel",
      //   "votes": "${noOfVoteObtain.text}",
      //   "year": "$selectedYear",
      //   "result": "$selectedResult",
      //   "photo": "$pickedVoterPath"
      // };

      // electionDetails.add(data);
      clearFields();

      update();
    }
  }

  clearForm() {
    selectedElectionLevel = null;
    noOfVoteObtain.clear();
    selectedYear = null;
    selectedResult = null;
    pickedVoterPath = null;
    update();
  }

  ///---------------------------------------------------------------------------
  late TextEditingController fullNameController = TextEditingController();
  late TextEditingController mobileNumberController = TextEditingController();
  late TextEditingController stateController = TextEditingController();
  late TextEditingController workStateController = TextEditingController();
  late TextEditingController districtController = TextEditingController();
  late TextEditingController assemblyController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController pincodeController = TextEditingController();
  late TextEditingController dobController = TextEditingController();
  late TextEditingController emailController = TextEditingController();

  bool isEditing = true;
  bool isLoading = true;

  String? pickedAMFilePath;
  File? pickedAMFile;

  UserDetail? userDetail;
  NOBaccessDetails? noBDetails;
  NOBaccessDetails? appCODdetails;

  OBaccessDetails? obDetails;
  String? workState;
  SharedPreferences? sharedPreferences;

  List<Districts> districtList = [];
  List<Assembly> assemblyList = [];
  List<States> stateList = [];
  List<Booth> boothList = [];

  Districts? userDistrict;
  Assembly? userAssembly;
  String? selectedAssembly;
  Districts? selectedDistrict;
  String? selectedCollege;
  List<DropdownItem> assemblyDropdownItems = [];

  List<DropdownItem> boothDropdownItems = [];

  String userPoint = "0";
  String authPoint = "0";

  late final AuthRepo? authRepo;
  String? selecteduniversity;
  List<DropdownItem> universityList = [
    DropdownItem("Bangalore University", "Bangalore University"),
  ];
  void onChangeAssembly(String value) async {
    selectedAssembly = value;
    selectedCollege = null;
    getCollegeList(selectedDistrict!.stateCode, selectedDistrict!.districtCode,
        selectedAssembly!);
    update();
  }

  void onchangecollege(String value) {
    selectedCollege = value;
    update();
  }

  void onChangeDistrict(Districts value) async {
    selectedDistrict = value;
    selectedAssembly = null;
    getAssemblyList(
        selectedDistrict!.districtCode, selectedDistrict!.stateCode);
    // assemblyList = await DbServices.db.getAssembly(districtList.firstWhere(
    //     (element) => element.districtCode == userDistrict!.districtCode));
    update();
  }

  @override
  void onInit() async {
    int tabIndexFromRoute = Get.arguments ?? 0;
    tabController =
        TabController(length: 2, vsync: this, initialIndex: tabIndexFromRoute);
    initYearDropDown();
    sharedPreferences = await SharedPreferences.getInstance();
    stateList = await DbServices.db.getAllStates(true);
    authRepo = AuthRepo(
        dioClient: DioClient(Urls.baseUrl, Dio(),
            loggingInterceptor: LoggingInterceptor(),
            sharedPreferences: sharedPreferences!));
    await getUserProfile();
    // await getProfilePic();
    // await getUserPoints();
    await getAuthPoint();
    mobileNumber =
        Get.find<HomeNSUIController>().profileController.userDetail!.mobile;

    // await viewElectionContData();
    update();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    fullNameController.dispose();
    mobileNumberController.dispose();
    stateController.dispose();
    districtController.dispose();
    assemblyController.dispose();
  }

  Future<void> getUserProfile() async {
    ApiResponse apiResponse = await authRepo!.getUserDetails();
    try {
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
        if (responseDecoded['status'] == "SUCCESS") {
          userDetail = UserDetail.fromJson(
              responseDecoded["response"]['BASIC_DETAILS'][0]);
          List<dynamic> noBdata = responseDecoded["response"]['NOB_DETAILS'];
          List<dynamic> oBdata = responseDecoded["response"]['OB_DETAILS'];
          List<dynamic> appCODdata = responseDecoded["response"]['OB_DETAILS'];

          if (noBdata.isNotEmpty) {
            noBDetails = NOBaccessDetails.fromJson(
                responseDecoded["response"]['NOB_DETAILS'][0]);
          }
          if (appCODdata.isNotEmpty) {
            noBDetails = NOBaccessDetails.fromJson(
                responseDecoded["response"]['APP_COD'][0]);
          }

          if (oBdata.isNotEmpty) {
            obDetails = OBaccessDetails.fromJson(
                responseDecoded["response"]['OB_DETAILS'][0]);
          }

          update();
          // stateList = await DbServices.db.getAllStates(true);
          await getStatesList();
          // districtList = await DbServices.db.getDistricts(stateList.firstWhere(
          //     (element) => element.stateCode == userDetail!.stateCode));
          await getDistrictList(userDetail!.stateCode);

          if (districtList.any(
              (element) => element.districtCode == userDetail!.districtCode)) {
            await getAssemblyList(
                userDetail!.districtCode, userDetail!.stateCode);
          }
          // assemblyList = await DbServices.db.getAssembly(
          //     districtList.firstWhere((element) =>
          //         element.districtCode == userDetail!.districtCode));
          isLoading = false;
          update();
        } else {
          isLoading = false;
          CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
        }
      }
      isLoading = false;

      userDetail!.stateName = stateList
          .firstWhere((element) => element.stateCode == userDetail!.stateCode)
          .name;
      // workState = stateList
      //     .firstWhere(
      //         (element) => element.stateCode == userDetail!.workingState)
      //     .name;

      userDetail!.districtName = districtList
          .firstWhere(
              (element) => element.districtCode == userDetail!.districtCode)
          .name;
      userDistrict = districtList.firstWhere(
          (element) => element.districtCode == userDetail!.districtCode);
      if (assemblyList.isNotEmpty) {
        userDetail!.assemblyName = assemblyList
            .firstWhere(
                (element) => element.assemblyCode == userDetail!.assemblyCode)
            .name;
        userAssembly = assemblyList.firstWhere(
            (element) => element.assemblyCode == userDetail!.assemblyCode);
      }

      if (userDetail!.category != null && userDetail!.category != '') {
        selectedCategory = categoryList
            .firstWhere((test) => test.value == userDetail!.category)
            .name;
      }
    } catch (e) {
      Log.printELog(e);
    }
    // workStateController = TextEditingController(text: workState);
    fullNameController = TextEditingController(text: userDetail!.name);
    mobileNumberController = TextEditingController(text: userDetail!.mobile);
    stateController = TextEditingController(text: userDetail!.stateName);
    districtController = TextEditingController(text: userDetail!.districtName);
    assemblyController = TextEditingController(text: userDetail!.assemblyName);
    addressController = TextEditingController(text: userDetail!.address);
    pincodeController = TextEditingController(text: userDetail!.pincode);
    subcasteController = TextEditingController(text: userDetail!.subCategory);
    dobController = TextEditingController(text: userDetail!.dateOfBirth);
    update();
  }

  Future<void> getAssemblyList(String district, String state) async {
    assemblyList = [];
    assemblyDropdownItems.clear();

    var result = await getUniversityBallots(state, district);
    if (result == null) {
      assemblyList = [];
    } else {
      assemblyList = [];
      for (var i in result) {
        assemblyList.add(Assembly(
            id: 0,
            districtCode: district,
            name: i['college_name'],
            stateCode: state,
            isEnabled: '',
            assemblyCode: i['college_code']));
      }
    }
    if (assemblyList.isNotEmpty) {
      for (var i in assemblyList) {
        assemblyDropdownItems.add(DropdownItem(i.name, i.assemblyCode));
      }
    }

    update();
  }

  Future<void> getDistrictList(String? selectedState) async {
    // var districtList =
    //     await DbServices.db.getAllDistrict(selectedState?.stateCode ?? '');
    districtList = [];

    var result = await getDistrictBallots(selectedState!);
    if (result == null) {
      districtList = [];
    } else {
      districtList = [];
      for (var i in result) {
        districtList.add(Districts(
            id: 0,
            name: i['district'],
            stateCode: selectedState,
            isEnabled: '',
            districtCode: i['district_code']));
      }
    }

    // Log.printILog('${districtList.length}, ${selectedState!.stateCode}');
    // if (districtList.isNotEmpty) {
    //   for (var i in districtList) {
    //     districtDropdownItems.add(DropdownItem(i.name, i.districtCode));
    //   }
    // }

    update();
  }

  ConstantApiRepo constantApiRepo = ConstantApiRepo(dioClient: sl());
  // States? selectedState;

  Future<dynamic> getStateBallots() async {
    ApiResponse apiResponse = await constantApiRepo.getStateBallotApi();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : State",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : State",
    );
    return null;
  }

  Future<dynamic> getDistrictBallots(String state) async {
    ApiResponse apiResponse = await constantApiRepo.getDistrictBallotApi(state);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : District",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : District",
    );
    return null;
  }

  Future<dynamic> getUniversityBallots(
      String stateCode, String selectedDistrict) async {
    ApiResponse apiResponse = await constantApiRepo.getUniversityBallotApi(
        stateCode, selectedDistrict);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : University",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : University",
    );
    return null;
  }

  Future<dynamic> getCollegeBallots(
      String state, String district, String universtiy) async {
    ApiResponse apiResponse =
        await constantApiRepo.getCollegeBallotApi(state, district, universtiy);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        CustomSnackBar.showErrorSnackBar(
          "No data Found : College",
        );
        return null;
      }
    }
    CustomSnackBar.showErrorSnackBar(
      "No data Found : College",
    );
    return null;
  }

  getCollegeList(String state, String district, String university) async {
    boothDropdownItems.clear();
    boothList = [];
    var result = await getCollegeBallots(state, district, university);
    if (result == null) {
      boothList = [];
    } else {
      boothList = [];
      for (var i in result) {
        boothList.add(Booth(
            id: 0,
            districtCode: district,
            stateCode: state,
            assemblyCode: university,
            blockCode: '',
            boothCode: i['college_code'],
            boothName: i['college']));
      }
    }
    if (boothList.isNotEmpty) {
      for (var i in boothList) {
        boothDropdownItems.add(DropdownItem(i.boothName, i.boothCode));
      }
    }
  }

  Future<void> getUserPoints() async {
    isLoading = true;
    ApiResponse apiResponse = await authRepo!.getUserPoints();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        userPoint = responseDecoded["response"][0]["POINTS"];
      } else {
        isLoading = false;
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    }
  }

  Future<void> getAuthPoint() async {
    isLoading = true;
    ApiResponse apiResponse = await authRepo!.getAuthPoints();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        authPoint = responseDecoded["response"];
        update();
      } else {
        isLoading = false;
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    }
  }

  clearFields() {
    selectedElectionLevel = null;
    noOfVoteObtain.clear();
    selectedYear = null;
    selectedResult = null;
    pickedVoterPath = null;
    update();
  }

  void onClickEdit() {
    isEditing = !isEditing;
    update();
  }

  void onClickUpdate() {
    userDetail!.name = fullNameController.text;
    userDetail!.mobile = mobileNumberController.text;
    userDetail!.stateCode = stateController.text;
    userDetail!.districtCode = districtController.text;
    userDetail!.assemblyCode = districtController.text;
  }

  Future<void> updateProfile() async {
    if (selectedDistrict == null ||
        selectedAssembly == null ||
        selectedCollege == null) {
      CustomSnackBar.showErrorSnackBar("Please selecte all values");
      return;
    }
    ProgressDialogUtils.showProgressIndicator();
    userDetail!.districtCode = selectedDistrict!.districtCode;
    userDetail!.assemblyCode = selectedAssembly!;
    userDetail!.name = fullNameController.text;
    userDetail!.address = addressController.text;
    userDetail!.pincode = pincodeController.text;
    userDetail!.subCategory = subcasteController.text;
    userDetail!.category = selectedCategory;
    userDetail!.dateOfBirth = dobController.text;
    userDetail!.wardCode = selectedCollege ?? '';
    ApiResponse apiResponse = await authRepo!.editProfile(userDetail!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        // CustomSnackBar.showSuccessSnackBar(responseDecoded['response']);
        profileNSUISuccessBottomSheet();
        selectedAssembly = null;
        selectedCollege = null;
        selectedDistrict = null;
        isEditing = true;
        update();
      } else {
        ProgressDialogUtils.closeDialog();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    }
  }

  Future<void> downloadIdCard() async {
    // final result = await toPage(
    //     context,
    //     IdCard(
    //       userDetail: userDetail!,
    //     ));
    // if (result != null && result) {
    //   CustomSnackBar.showErrorSnackBar("ID card saved to Download/IYC/ID folder");
    // }
  }

  pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType, BuildContext context) async {
    Log.printILog('Starting taking profile photo');
    //  FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await ImageServices().pickImage(imageSource);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      File image;
      image = File(result.path);
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      switch (documentType) {
        case DocumentType.amImage:
          pickedAMFile = _image;
          pickedAMFilePath = pickedAMFile!.path;
          Log.printILog('Profile photo path is $pickedAMFilePath');
          uploadDocumentAmPhoto(pickedAMFilePath!, userDetail!.mobile);
          update();
          break;
        case DocumentType.idFront:
          // TODO: Handle this case.
          break;
        case DocumentType.idBack:
          // TODO: Handle this case.
          break;
        case DocumentType.category:
          // TODO: Handle this case.
          break;
        case DocumentType.bpl:
          // TODO: Handle this case.
          break;
        case DocumentType.caseFile:
          // TODO: Handle this case.
          break;
        case DocumentType.amVideo:
          // TODO: Handle this case.
          break;
        case DocumentType.dob:
          // TODO: Handle this case.
          break;
        case DocumentType.barCouncilId:
          // TODO: Handle this case.
          break;
      }
      update();
    } else {
      print("file picked not");
      return null;
    }
  }

  Future<bool> uploadDocumentAmPhoto(
      String amPhotoFilePath, String mobile) async {
    Log.printILog('Uploading Profile Photo');
    ProgressDialogUtils.showProgressDialog();
    String? result = await AwsUploadServices().uploadFile(
        file: File(amPhotoFilePath),
        destDir: "PROFILE",
        filename: "${mobile}_P.${amPhotoFilePath.split(".").last}");
    if (result is String) {
      ProgressDialogUtils.hideProgressDialog();
      return true;
    } else {
      ProgressDialogUtils.hideProgressDialog();
      return false;
    }
  }
}
