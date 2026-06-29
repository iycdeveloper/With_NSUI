import 'dart:convert';
import 'dart:io';
// import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/repository/constant_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_list_controller.dart';
import 'package:iyc/app/modules/membership/widgets/membership_success_bootom_sheet_nsui.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/helper/location_helper.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/nominations.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/nusi/app/modules/home/screens/home_controller_nsui.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/screens/widgets/face_detection_widget.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
// import 'package:m7_livelyness_detection/m7_livelyness_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import '../../../data/resources/repository/membership_repo.dart';

class MembershipMemberViewController extends GetxController {
  HomeNSUIController homeController = Get.find<HomeNSUIController>();
  String? userState;
  ApiConfig? apiConfig;

  bool isUpdate = Get.arguments[0];
  bool isLegalCell = Get.arguments[1] ?? false;
  BatchMember member = Get.arguments[2];
  bool isUpdateToDB = Get.arguments[3] ?? false;

  late PageController pageController;
  int pageNumber = 0;
  pageNumberChange(int index) {
    pageNumber = index;
    update();
  }

  int activeStep = 0;
  Map<String, String> steps = {
    '1': 'Basic Details',
    '2': 'Constituency',
    '3': 'Upload Documents',
    '4': 'Candidate Selection',
  };
  // Map<String, String> steps = {
  //   '1': 'Basic Details',
  //   '2': 'Personal Details',
  //   '3': 'Contact Details',
  //   '4': 'ID Proof',
  //   '5': 'Constituency Details',
  //   '6': 'Candidate Details'
  // };

  bool isLegalCellReg = false;
  bool isLoading = false;
  BatchMember? currentMember;
  final MembershipMemberDB membershipDbRepo = MembershipMemberDB(sl());
  ConstantApiRepo constantApiRepo = ConstantApiRepo(dioClient: sl());
  // bool isloading = false;
  @override
  void onInit() {
    apiConfig = sl();
    if (homeController.profileController.userDetail != null) {
      userState = homeController.profileController.userDetail!.stateCode;
    } else {
      CustomSnackBar.showErrorSnackBar('User Details Not found');
    }
    Log.printILog('Updating value in DB $isUpdateToDB');
    setCurrentMember(member);
    pageController = PageController(initialPage: pageNumber);
    // initCurrentStep();
    super.onInit();
  }

  Future<void> next(BuildContext context) async {
    pageController.nextPage(
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    pageNumber++;
    activeStep++;
    // initCurrentStep();
    update();
  }

  Future<void> previous() async {
    pageController.previousPage(
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    pageNumber--;
    activeStep--;
    update();
  }

  void updateStepperIndex(int index) {
    activeStep = index;
    update();
  }

  void setCurrentMember(
    BatchMember membershipRequestModel,
  ) async {
    isLoading = true;
    update();

    currentMember = membershipRequestModel;
    await getStatesList();
    await getDistrictList(currentMember!.stateCode ?? '');
    await getAssemblyList(
        currentMember!.stateCode ?? '', currentMember!.districtCode ?? '');
    await createBoothList(currentMember!.stateCode ?? '',
        currentMember!.districtCode ?? '', currentMember!.assemblyCode ?? '');

    usernameController.text = currentMember!.firstName ?? '';
    fatherNameController.text = currentMember!.relativeName ?? '';

    mobileController.text = currentMember!.mobile ?? '';
    emailController.text = currentMember!.email ?? '';
    dobController.text = currentMember!.dob ?? '';
    genderController.text = currentMember!.gender == null
        ? ''
        : (currentMember!.gender!.contains('M')
            ? 'Male'
            : currentMember!.gender!.contains('F')
                ? 'Female'
                : 'Others');
    courseController.text = currentMember!.education ?? '';
    addressController.text = currentMember!.address ?? '';

    List<States>? data1 = stateList!
        .where((test) => test.stateCode == currentMember!.stateCode)
        .toList();
    if (data1.isNotEmpty) {
      stateController.text = data1.first.name;
    }
    List<Districts>? data2 = districtList!
        .where((test) => test.districtCode == currentMember!.districtCode)
        .toList();
    if (data2.isNotEmpty) {
      districtController.text = data2.first.name;
    }

    List<Assembly>? data3 = assemblyList!
        .where((test) => test.assemblyCode == currentMember!.assemblyCode)
        .toList();
    if (data3.isNotEmpty) {
      universityController.text = data3.first.name;
    }

    List<Booth>? data4 = _boothList
        .where((test) => test.boothCode == currentMember!.mandalamCode)
        .toList();
    if (data4.isNotEmpty) {
      collegeController.text = data4.first.boothName;
    }

    statePresidentController.text =
        currentMember!.statePresidentCandidate ?? '';
    districtPresidentController.text = currentMember!.districtCandidate ?? '';
    universityPresidentController.text = currentMember!.assemblyCandidate ?? '';
    collegePresidentController.text = currentMember!.mandalamCandidate ?? '';

    pickedIdProofPath = currentMember!.idDocumentFilePath;
    pickedDocumentBackFilePath = currentMember!.documentBackPath;
    pickedAMFilePath = currentMember!.amPhotoFilePath;
    pickedVideoFilePath = currentMember!.videoFilePath;

    if (currentMember!.idDocumentFilePath != null) {
      pickedIdFile = File(currentMember!.idDocumentFilePath!);
      showIdImage = true;
    }
    if (currentMember!.amPhotoFilePath != null) {
      pickedAMFile = File(currentMember!.amPhotoFilePath!);
      showAMImage = true;
    }
    if (currentMember!.documentBackPath != null) {
      pickedDocumentBack = File(currentMember!.documentBackPath!);
      showDocumentBack = true;
    }
    isLoading = false;
    update();
  }

  syncMembership(BuildContext context, BatchMember? currentMember,
      {Map<String, dynamic>? data}) async {
    var aggrId = await LocalStorageServices().getAgrIDMembership();
//

//Old functionality below
    // if (aggrId.isEmpty) {
    //   CustomSnackBar.showErrorSnackBar('Something went wrong');
    //   aggrId = await getAggrId(context);
    // }
    var memberData = [];
    // for (var i in membershipRequestList) {
    //   memberData.add(jsonEncode(i));
    // }
    // for (var i in primaryMemberList) {
    //   var mapValue = i.toJson(i);
    //   mapValue.remove('MOBILE');
    //   mapValue.remove('ID');
    //   mapValue['MOBILE1'] = i.mobile;
    //   mapValue['ID_VALUE'] = i.idCardNumber;
    //   memberData.add(jsonEncode(mapValue));
    // }

    memberData.add(jsonEncode(data));
    print(memberData.length);
    for (var i in memberData) {
      print(i);
    }
    showNetworkLoadingDialog(context,
        willPopScope: false, msg: 'Fetching Location .....');
    Position? _locationData;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await LocationHelper().reqService();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      }
      if (serviceEnabled) {
        _locationData = await Geolocator.getCurrentPosition();
      } else {
        CustomSnackBar.showErrorSnackBar('Enable location permission');
        Navigator.of(context).pop();
        return;
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackBar('Enable location permission');
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pop();
    showNetworkLoadingDialog(context,
        willPopScope: false, msg: 'Syncing ......');
    String testJsonData = '''[{"V":"${AppConstants.membershipVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${_locationData.latitude}",
    "LONGITUDE":"${_locationData.longitude}",
    "BATCH_NO":"${currentMember!.batchId}",
    "AGGR_ID":"$aggrId",
    "MEMBER_DATA":${memberData}}]''';

    ApiResponse apiResponse = await apiConfig!
        .postData(endpointUrl: Urls.syncMembership, jsonData: testJsonData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        await sl<BatchDBRepo>().updateData(BatchDataModel(
            batchId: currentMember.batchId!,
            countAM: memberData.length,
            syncStatus: "1"));
        // currentMember.forEach((element) async {
        currentMember.isSync = '1';
        await membershipDbRepo.updateMembershipTable(currentMember);
        // });
        MembershipMemberListController membershipListController =
            Get.find<MembershipMemberListController>();

        membershipListController.isSyncMembers = true;
        membershipListController.showAddOption = false;
        update();
        Navigator.of(context).pop();

        /// close loading

        // await Alert(
        //   context: context,
        //   type: AlertType.success,
        //   style: const AlertStyle(backgroundColor: Colors.white),
        //   title: "SUCCESS",
        //   desc: "Sync complete",
        //   onWillPopActive: true,
        //   buttons: [
        //     DialogButton(
        //       color: Constants.themeGradients[0],
        //       child: const Text(
        //         "OKAY",
        //         style: TextStyle(color: Colors.black, fontSize: 20),
        //       ),
        //       onPressed: () async {
        //         Navigator.pop(context, true);
        //       },
        //       width: 120,
        //     )
        //   ],
        // ).show();

        var result = await membershipNSUISuccessBottomSheet(context);
        if (result == null) {
          MembershipBatchController membershipBatchController =
              Get.find<MembershipBatchController>();
          membershipBatchController.downloadExistingBatch(context: context);
        }

        print("test::" + result.toString());
        // membershipListController
        //     .getMembershipList(context, currentMember.batchId!, reload: true);
      } else {
        Navigator.of(context).pop();
        if ('${responseDecoded["response"]}'.contains('Aggregator')) {
          Get.find<AuthService>().forceLogout();
        }
        CustomSnackBar.showErrorSnackBar(
            responseDecoded["response"] ?? "Batch Sync Failed! Try Again");
      }
    } else {
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
  }

  s3uploadAllMemberImages() async {
    bool? returnValue;
    final uploadResult = await Future.wait(
      [
        if (pickedIdProofPath != null && pickedIdProofPath != '')
          uploadDocumentFrontImage(member),
        if (pickedDocumentBackFilePath != null &&
            pickedDocumentBackFilePath != '')
          uploadDocumentBackImage(member),
        if (pickedAMFilePath != null && pickedAMFilePath != '')
          uploadDocumentAmPhoto(member),
      ],
    );
    if (uploadResult.contains(false)) {
      returnValue = false;
      // ignore: unnecessary_null_comparison
    } else if (returnValue == null || returnValue) {
      returnValue = true;
    }

    return returnValue;
  }

  Future<bool> uploadDocumentFrontImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(pickedIdProofPath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_GOVT_P.${pickedIdProofPath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadDocumentBackImage(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(pickedDocumentBackFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename:
            "${member.memberId}_CL_P.${pickedDocumentBackFilePath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadDocumentAmPhoto(BatchMember member) async {
    String? result = await AwsUploadServices().uploadFile(
        file: File(pickedAMFilePath!),
        destDir: "MEMBERSHIP/${member.stateCode}/OM/${member.memberId}",
        filename: "${member.memberId}_P.${pickedAMFilePath?.split(".").last}");

    if (result is String) {
      return true;
    } else {
      return false;
    }
  }

  void onSubmit(BuildContext context) async {
    if (isUpdate) {
      Get.back();
      return;
    }
  }

  String? membershipId;
  bool disableFields = false;

  GlobalKey<FormState> basicDetailFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  TextEditingController collegeController = TextEditingController();

  TextEditingController statePresidentController = TextEditingController();
  TextEditingController districtPresidentController = TextEditingController();
  TextEditingController universityPresidentController = TextEditingController();
  TextEditingController collegePresidentController = TextEditingController();

  GlobalKey<FormState> contactDetailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileFormKey = GlobalKey();

  TextEditingController verificationCodeController = TextEditingController();

  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  TextEditingController pinController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void checkPrefillForBasicDetail() {
    final value = currentMember!;
    membershipId = value.memberId;
    usernameController.text = value.firstName ?? "";
    lastNameController.text = value.lastName ?? "";
    professionController.text = value.profession ?? "";
    fatherNameController.text = value.relativeName ?? "";
    mobileController.text = value.mobile ?? "";
    emailController.text = value.email ?? '';
    addressController.text = value.address ?? '';
    dobController.text = value.dob ?? '';
    selectedDate = value.dob ?? '';
    courseController.text = value.education ?? '';
    if (isLegalCellReg) professionController.text = "Lawyer";
    selectedGender = value.gender;
    update();
  }

  GlobalKey<FormState> personalDetailFormKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();
  String? selectedGender;
  String? selectedCategory;
  String? selectedEducation;
  String? selectedDate;

  DateTime eventDate = DateTime.now();

  List<DropdownItem> gender = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
    DropdownItem("Other", "O"),
  ];
  List<DropdownItem> category = [
    DropdownItem("General", "General"),
    DropdownItem("SC", "SC"),
    DropdownItem("ST", "ST"),
    DropdownItem("OBC", "OBC"),
    DropdownItem("Minority", "Minority"),
    DropdownItem("Unknown", "Unknown"), //Minority
  ];
  List<DropdownItem> educationalDetailsList = [
    DropdownItem("Graduate", "Graduate"),
    DropdownItem("Non Graduate", "NonGraduate")
  ];

  void onChangeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    dobController.text = selectedDate!;
    update();
  }

  void onChangeGender(String value) {
    selectedGender = value;
    update();
  }

  void onChangeCategory(String value) {
    selectedCategory = value;
    update();
  }

  void onChangeEducation(String value) {
    selectedEducation = value;
    update();
  }

  Future<void> checkForPrefillPersonalDetails() async {
    BatchMember membershipRequestModel = currentMember!;
    selectedEducation = membershipRequestModel.education;
    selectedGender = membershipRequestModel.gender;
    selectedCategory = membershipRequestModel.category;
    selectedDate = membershipRequestModel.dob;
    // dobController.text = membershipRequestModel.dob ?? 'Select DOB';
    update();
  }

  /// Contact Detail form
  ///
  ///

  bool validateContactDetails() {
    if (contactDetailFormKey.currentState?.validate() ?? false) {
      contactDetailFormKey.currentState!.save();
      return true;
    }
    return false;
  }

  void checkPrefillDataForContactDetails() {
    BatchMember membershipRequestModel = currentMember!;
    addressController.text = membershipRequestModel.address ?? "";
    pinController.text = membershipRequestModel.pin ?? "";
    mobileController.text = membershipRequestModel.mobile ?? "";
    emailController.text = membershipRequestModel.email ?? "";
  }

  /// ID Proof
  ///
  ///
  GlobalKey<FormState> identityDetailFormKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();

  String? pickedAMFilePath;
  String? pickedIdProofPath;
  String? pickedDocumentBackFilePath;
  String? pickedVideoFilePath;

  File? pickedAMFile;
  File? pickedIdFile;
  File? pickedDocumentBack;
  File? pickedVideoFile;

  bool showIdImage = false;
  bool showAMImage = false;
  bool showDocumentBack = false;
  List<String> scrutinyCodeList = [];

  bool showVideoFile = false;
  bool showVideoOptional = false;

  Future<bool> checkPreFillDataForIDProofForm(BuildContext context) async {
    BatchMember membershipRequestModel = member;
    idController.text = membershipRequestModel.idValue ?? "";
    pickedIdProofPath = membershipRequestModel.idDocumentFilePath;
    pickedDocumentBackFilePath = membershipRequestModel.documentBackPath;
    pickedAMFilePath = membershipRequestModel.amPhotoFilePath;
    pickedVideoFilePath = membershipRequestModel.videoFilePath;

    if (membershipRequestModel.idDocumentFilePath != null) {
      pickedIdFile = File(membershipRequestModel.idDocumentFilePath!);
      showIdImage = true;
    }
    if (membershipRequestModel.amPhotoFilePath != null) {
      pickedAMFile = File(membershipRequestModel.amPhotoFilePath!);
      showAMImage = true;
    }
    if (membershipRequestModel.documentBackPath != null) {
      pickedDocumentBack = File(membershipRequestModel.documentBackPath!);
      showDocumentBack = true;
    }
    if (membershipRequestModel.videoFilePath != null) {
      pickedVideoFile = File(membershipRequestModel.videoFilePath!);
      showVideoFile = true;
    }

    update();
    return true;
  }

  void initConstituencyForm(BuildContext context) {
    getStatesList();
    // createBoothList();
  }

  bool mandalamEnabled = true;

  List<States>? stateList;

  Future<void> getStatesList() async {
    stateList = [];
    // stateList = await DbServices.db.getAllStates(true);
    var result = await getStateBallots();
    if (result == null) {
      stateList = [];
    } else {
      stateList = [];
      for (var i in result) {
        stateList!.add(States(
            id: 0,
            name: i['state_name'],
            stateCode: i['state_code'],
            isEnabled: ''));
      }
    }

    // selectedStateName = selectedState!.name;
    update();
  }

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

  Future<dynamic> getDistrictBallots(String statecode) async {
    ApiResponse apiResponse =
        await constantApiRepo.getDistrictBallotApi(statecode);
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

  Future<dynamic> getUniversityBallots(String state, String district) async {
    ApiResponse apiResponse =
        await constantApiRepo.getUniversityBallotApi(state, district);
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
      String state, String district, String assembly) async {
    ApiResponse apiResponse =
        await constantApiRepo.getCollegeBallotApi(state, district, assembly);
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

  List<Districts>? districtList = [];

  Future<void> getDistrictList(String state) async {
    districtList = [];

    var result = await getDistrictBallots(state);
    if (result == null) {
      districtList = [];
    } else {
      districtList = [];
      for (var i in result) {
        districtList!.add(Districts(
            id: 0,
            name: i['district'],
            stateCode: state,
            isEnabled: '',
            districtCode: i['district_code']));
      }
    }

    update();
  }

  List<Assembly>? assemblyList = [];

  Future<void> getAssemblyList(String state, String district) async {
    assemblyList = [];
    var result = await getUniversityBallots(state, district);
    if (result == null) {
      assemblyList = [];
    } else {
      assemblyList = [];
      for (var i in result) {
        assemblyList!.add(Assembly(
            id: 0,
            districtCode: district,
            name: i['university'],
            stateCode: state,
            isEnabled: '',
            assemblyCode: i['university_code']));
      }
    }

    update();
  }

  List<Booth> _boothList = [];

  Future<void> createBoothList(
      String state, String district, String assembly) async {
    _boothList = [];
    var result = await getCollegeBallots(state, district, assembly);
    if (result == null) {
      _boothList = [];
    } else {
      _boothList = [];
      for (var i in result) {
        _boothList.add(Booth(
            id: 0,
            districtCode: district,
            stateCode: state,
            assemblyCode: assembly,
            blockCode: '',
            boothCode: i['college_code'],
            boothName: i['college']));
      }
    }

    update();
  }

  ///
  ///

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

  // Future searchForStatePresidentNominations(BuildContext context) async {
  //   statePresidentNominationsList = [];
  //   List<dynamic>? result = await getNominationBallotList(
  //       ballot: "SP",
  //       state: selectedState == null ? '' : selectedState!.stateCode,
  //       assembly: selectedAssembly ?? '',
  //       district: selectedDistrict ?? '',
  //       mandalam: selectedMandalam,
  //       blackCode: '',
  //       boothCode: selectedBooth == null ? '' : selectedBooth!);
  //   if (result != null) {
  //     int count = 1;

  //     statePresidentNominationsList = result
  //         .map((test) => Nomination(
  //             id: 0,
  //             name: test['FIRST_NAME'],
  //             csn: (test['CSN'] != null && test['CSN'] != "")
  //                 ? int.parse(test['CSN'].toString())
  //                 : count++,
  //             firstName: test['FIRST_NAME'],
  //             lastName: test['LAST_NAME'],
  //             masterLevelId: test['MASTER_LEVEL_ID'] == null
  //                 ? int.parse(test['MASTER_LEVEL_ID'].toString())
  //                 : 0))
  //         .toList();
  //     statePresidentNominationsList.add(Nomination(
  //         id: 123456789,
  //         name: "NOTA",
  //         csn: 0,
  //         firstName: "NOTA",
  //         lastName: ""));
  //   }

  //   if (statePresidentNominationsList.isEmpty) {
  //     statePresidentNominationsList = [
  //       Nomination(
  //           id: 123456789,
  //           name: "NO Nomination",
  //           csn: 999,
  //           firstName: "No Nomination",
  //           lastName: "")
  //     ];
  //   }
  //   // notifyListeners();
  // }

  // Future searchForStateGeneralSecreNominations(BuildContext context) async {
  //   ///getting selected state/district/assembly code
  //   selectedState = selectedState!;
  //   selectedDistrict = selectedDistrict;
  //   selectedAssembly = selectedAssembly;

  //   ///get state data list from db
  //   stateGeneralSecretaryNominationsList = await DbServices.db
  //       .searchForStateNominations(
  //           stateCode: selectedState!.stateCode,
  //           contestingFor: "State General Secretary");

  //   stateGeneralSecretaryNominationsList.add(Nomination(
  //       id: 123456789,
  //       name: "NO Vote",
  //       csn: 0,
  //       firstName: "No Vote",
  //       lastName: ""));
  //   //  update()();
  // }

  // Future searchForDistrictNominations(BuildContext context) async {

  //   districtNominationsList = [];
  //   List<dynamic>? result = await getNominationBallotList(
  //       ballot: "DP",
  //       state: selectedState == null ? '' : selectedState!.stateCode,
  //       // district: selectedDistrict == null ? '' : selectedDistrict!.districtCode,
  //       assembly: selectedAssembly ?? '',
  //       district: selectedDistrict ?? '',
  //       mandalam: selectedMandalam,
  //       blackCode: '',
  //       boothCode: selectedBooth == null ? '' : selectedBooth!);
  //   if (result != null) {
  //     int count = 1;
  //     districtNominationsList = result
  //         .map((test) => Nomination(
  //             id: 0,
  //             name: test['FIRST_NAME'],
  //             csn: (test['CSN'] != null && test['CSN'] != "")
  //                 ? int.parse(test['CSN'].toString())
  //                 : count++,
  //             firstName: test['FIRST_NAME'],
  //             lastName: test['LAST_NAME'],
  //             masterLevelId: test['MASTER_LEVEL_ID'] == null
  //                 ? int.parse(test['MASTER_LEVEL_ID'].toString())
  //                 : 0))
  //         .toList();
  //     districtNominationsList.add(Nomination(
  //         id: 123456789,
  //         name: "NOTA",
  //         csn: 0,
  //         firstName: "NOTA",
  //         lastName: ""));
  //   }

  //   //
  //   if (districtNominationsList.isEmpty) {
  //     districtNominationsList = [
  //       Nomination(
  //           id: 123456789,
  //           name: "NO Nomination",
  //           csn: 999,
  //           firstName: "No Nomination",
  //           lastName: "")
  //     ];
  //   }

  // }

  // List<Nomination> districtGsNominationsList = [];
  // String? selectedDistrictGsNominations;

  // Future searchForDistrictGsNominations(BuildContext context) async {
  //   districtNominationsList = [];
  //   List<dynamic>? result = await getNominationBallotList(
  //       ballot: "DP",
  //       state: selectedState == null ? '' : selectedState!.stateCode,
  //       // district: selectedDistrict == null ? '' : selectedDistrict!.districtCode,
  //       assembly: selectedAssembly ?? '',
  //       district: selectedDistrict ?? '',
  //       mandalam: selectedMandalam,
  //       blackCode: '',
  //       boothCode: selectedBooth ?? '');
  //   if (result != null) {
  //     int count = 1;
  //     districtNominationsList = result
  //         .map((test) => Nomination(
  //             id: 0,
  //             name: test['FIRST_NAME'],
  //             csn: (test['CSN'] != null && test['CSN'] != "")
  //                 ? int.parse(test['CSN'].toString())
  //                 : count++,
  //             firstName: test['FIRST_NAME'],
  //             lastName: test['LAST_NAME'],
  //             masterLevelId: test['MASTER_LEVEL_ID'] == null
  //                 ? int.parse(test['MASTER_LEVEL_ID'].toString())
  //                 : 0))
  //         .toList();
  //     districtNominationsList.add(Nomination(
  //         id: 123456789,
  //         name: "NOTA",
  //         csn: 0,
  //         firstName: "NOTA",
  //         lastName: ""));
  //   }

  //   //
  //   if (districtNominationsList.isEmpty) {
  //     districtNominationsList = [
  //       Nomination(
  //           id: 123456789,
  //           name: "NO Nomination",
  //           csn: 999,
  //           firstName: "No Nomination",
  //           lastName: "")
  //     ];
  //   }
  //   update();
  // }

  // Future searchForAssemblyNominations(BuildContext context) async {
  //   assemblyNominationsList = [];
  //   List<dynamic>? result = await getNominationBallotList(
  //       ballot: "VS",
  //       state: selectedState == null ? '' : selectedState!.stateCode,
  //       assembly: selectedAssembly ?? '',
  //       district: selectedDistrict ?? '',
  //       //  assembly:
  //       //     selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
  //       // district:
  //       //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
  //       mandalam: selectedMandalam,
  //       blackCode: '',
  //       boothCode: selectedBooth ?? '');
  //   if (result != null) {
  //     int count = 1;
  //     assemblyNominationsList = result
  //         .map((test) => Nomination(
  //             id: 0,
  //             name: test['FIRST_NAME'],
  //             csn: (test['CSN'] != null && test['CSN'] != "")
  //                 ? int.parse(test['CSN'].toString())
  //                 : count++, //Random().nextInt(100),
  //             firstName: test['FIRST_NAME'],
  //             lastName: test['LAST_NAME'],
  //             masterLevelId: test['MASTER_LEVEL_ID'] == null
  //                 ? int.parse(test['MASTER_LEVEL_ID'].toString())
  //                 : 0))
  //         .toList();
  //     assemblyNominationsList.add(Nomination(
  //         id: 123456789,
  //         name: "NOTA",
  //         csn: 0,
  //         firstName: "NOTA",
  //         lastName: ""));
  //   }
  //   //
  //   if (assemblyNominationsList.isEmpty) {
  //     assemblyNominationsList = [
  //       Nomination(
  //           id: 123456789,
  //           name: "NO Nomination",
  //           csn: 999,
  //           firstName: "No Nomination",
  //           lastName: "")
  //     ];
  //   }
  //   update();
  // }

  // Future searchForBlockNominations(BuildContext context) async {
  //   blockNominationsList = await DbServices.db.searchForBlockNominations(
  //       stateCode: selectedState!.stateCode,
  //       districtCode: selectedDistrict!,
  //       blockCode: "0",
  //       contestingFor: "Block");
  //   if (blockNominationsList.isEmpty) {
  //     blockNominationsList = [
  //       Nomination(
  //           id: 123456789,
  //           name: "NO Nomination",
  //           csn: 999,
  //           firstName: "No Nomination",
  //           lastName: "")
  //     ];
  //   } else {
  //     blockNominationsList.add(Nomination(
  //         id: 123456789,
  //         name: "NO Vote",
  //         csn: 0,
  //         firstName: "No Vote",
  //         lastName: ""));
  //   }
  //   if (blockNominationsList.any((element) =>
  //       element.csn.toString() == (currentMember?.blockCandidate ?? false))) {
  //     //print("here....................");
  //     selectedBlockNominations = currentMember?.blockCandidate;
  //   } else {
  //     selectedBlockNominations = null;
  //     //update()();
  //   }
  // }

  // String? selectedMandalamNominations;
  // List<Nomination> mandalamNominationsList = [];

  // Future searchFormandalamNominations(BuildContext context) async {
  //   mandalamNominationsList = await DbServices.db.searchForMandalamNominations(
  //       stateCode: selectedState!.stateCode,
  //       districtCode: selectedDistrict!,
  //       blockCode: selectedMandalam ?? "",
  //       contestingFor: "Mandalam");
  //   if (mandalamNominationsList.isEmpty) {
  //     mandalamNominationsList = [
  //       Nomination(
  //           id: 123456789,
  //           name: "NO Nomination",
  //           csn: 999,
  //           firstName: "No Nomination",
  //           lastName: "")
  //     ];
  //   } else {
  //     mandalamNominationsList.add(Nomination(
  //         id: 123456789,
  //         name: "NO Vote",
  //         csn: 0,
  //         firstName: "No Vote",
  //         lastName: ""));
  //   }
  //   if (mandalamNominationsList.any((element) =>
  //       element.csn.toString() ==
  //       (currentMember?.mandalamCandidate ?? false))) {
  //     //print("here....................");
  //     selectedMandalamNominations = currentMember?.mandalamCandidate;
  //   } else {
  //     selectedMandalamNominations = null;
  //     //update()();
  //   }
  // }

  // Future searchForBoothNominations(BuildContext context) async {
  //   boothNominationsList = [];
  //   List<dynamic>? result = await getNominationBallotList(
  //     ballot: "MD",
  //     state: selectedState == null ? '' : selectedState!.stateCode,
  //     district: selectedDistrict ?? '',
  //     blackCode: '',
  //     boothCode: selectedBooth ?? '',
  //     assembly: selectedAssembly ?? '',
  //     // district:
  //     //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
  //     mandalam: selectedMandalam,
  //     // blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
  //     // boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode
  //   );
  //   if (result != null) {
  //     int count = 1;

  //     boothNominationsList = result
  //         .map((test) => Nomination(
  //             id: 0,
  //             name: test['FIRST_NAME'],
  //             csn: (test['CSN'] != null && test['CSN'] != "")
  //                 ? int.parse(test['CSN'].toString())
  //                 : count++,
  //             firstName: test['FIRST_NAME'],
  //             lastName: test['LAST_NAME'],
  //             masterLevelId: test['MASTER_LEVEL_ID'] == null
  //                 ? int.parse(test['MASTER_LEVEL_ID'].toString())
  //                 : 0))
  //         .toList();
  //     boothNominationsList.add(Nomination(
  //         id: 123456789,
  //         name: "NOTA",
  //         csn: 0,
  //         firstName: "NOTA",
  //         lastName: ""));
  //   }
  //   //
  //   if (boothNominationsList.isEmpty) {
  //     boothNominationsList = [
  //       Nomination(
  //           id: 123456789,
  //           name: "NO Nomination",
  //           csn: 999,
  //           firstName: "No Nomination",
  //           lastName: "")
  //     ];
  //   }

  //   update();
  // }

  MembershipRepo membershipRepo = MembershipRepo(dioClient: sl());

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

  bool declarationStatus = true;
}
