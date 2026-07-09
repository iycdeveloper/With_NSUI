import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:iyc/utils/dob_rules.dart';
// import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/db_provider/membership/batch_db_repo.dart';
import 'package:iyc/app/data/resources/db_provider/membership/membership_db_repo.dart';
import 'package:iyc/app/data/resources/repository/constant_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/app/modules/membership/controllers/membership_batch_controller.dart';
import 'package:iyc/app/modules/membership/controllers/membership_member_list_controller.dart';
import 'package:iyc/app/modules/membership/widgets/membership_success_bootom_sheet_nsui.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
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
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/face_detection_widget.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
// import 'package:m7_livelyness_detection/m7_livelyness_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import '../../../data/resources/repository/membership_repo.dart';

class MembershipMemberCreateController extends GetxController {
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

  @override
  void onInit() {
    apiConfig = sl();
    if (homeController.profileController.userDetail != null) {
      userState = homeController.profileController.userDetail!.stateCode;
    } else {
      CustomSnackBar.showErrorSnackBar('User Details Not found');
    }
    Log.printILog('Updating value in DB $isUpdateToDB');
    setCurrentMember(member, isLegalCell);
    pageController = PageController(initialPage: pageNumber);
    initCurrentStep();
    super.onInit();
  }

  Future<void> next(BuildContext context) async {
    if (await validateCurrentStep(context)) {
      pageController.nextPage(
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      pageNumber++;
      activeStep++;
      initCurrentStep();
      update();
    }
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

  Future<bool> validateCurrentStep(BuildContext context) async {
    switch (activeStep) {
      case 0:
        if (await validateBasicDetails(context)) {
          return true;
        } else {
          return false;
        }
      case 1:
        return validateConsistencyForm();

      case 2:
        return validateIDProof();

      case 3:
        return validatePage(Get.context!);
      default:
        return true;
    }
  }

  void initCurrentStep() {
    switch (activeStep) {
      case 0:
        Log.printILog('Initial basic detail form');
        // if (isUpdate) {
        //   checkPrefillForBasicDetail();
        // }
        break;
      case 1:
        Log.printILog('Initial basic Consistency detail form');
        initConstituencyForm(Get.context!);
        // if (isUpdate) {
        //   checkForPrefillDataForConsistencyDetails();
        // }

        break;
      case 2:
        Log.printILog('Initial ID Proof form');
        // if (isUpdate) {
        //   checkPreFillDataForIDProofForm(Get.context!);
        // }
        break;
      case 3:
        Log.printILog('Initial Candidate detail form');
        // if (isUpdate) {
        //   checkForPrefill(Get.context!);
        // }
        initialize(Get.context!);

        break;

      default:
        Log.printILog('Default case');
        break;
    }
  }

  void setCurrentMember(BatchMember membershipRequestModel,
      [bool? isLegalCellReg]) {
    currentMember = membershipRequestModel;
    if (isLegalCellReg != null) this.isLegalCellReg = isLegalCellReg;
    update();
  }

  Future<void> memberSaveToDB(BuildContext context, bool isUpdate) async {
    // Log.printILog('Updating value in DB $isUpdateToDB');
    // if (isUpdateToDB) {
    //   await membershipDbRepo.updateMembershipTable(currentMember!);
    // }
    //  else {
    // log(currentMember!.toJson().toString());

    //
    // await membershipDbRepo.insertData(currentMember!);
    // final list = await membershipDbRepo.getData(currentMember!.batchId!);
    // int count = list.length;
    // await BatchDBRepo(sl()).updateAMCount(
    //     BatchDataModel(batchId: currentMember!.batchId!, countAM: count));

    // MembershipMemberListController memberListController =
    //     Get.find<MembershipMemberListController>();
    // await memberListController.getMembershipList(
    //     Get.context!, memberListController.batchId);
    // MembershipBatchController membershipBatchController =
    //     Get.find<MembershipBatchController>();
    // await membershipBatchController.getMembershipBatchList(Get.context!);

//Sync below

    var aggrId = await LocalStorageServices().getAgrIDMembership();
    await s3uploadAllMemberImages();
    Map<String, dynamic> newMemberData = {
      'MEMBER_ID': currentMember!.memberId,
      "BATCH_NO": currentMember!.batchId,
      "FIRST_NAME": usernameController.text,
      "RELATIVE_NAME": fatherNameController.text,
      "MOBILE1": mobileController.text,
      "EMAIL": emailController.text,
      "DATE_OF_BIRTH": dobController.text,
      "SEX_CODE": selectedGender,
      "EDUCATION": courseController.text,
      "ADDRESS": addressController.text,
      "STATE_CODE": selectedState!.stateCode,
      "DISTRICT_CODE": selectedDistrict,
      "ASSEMBLY_CODE": selectedAssembly,
      "MANDALAM_CODE": selectedBooth,
      // "UNIVERSITY": selectedAssembly,
      // "COLLEGE": selectedBooth,
      "CSN_SP": selectedStatePresidentNominations ?? '0',
      "CSN_SG": selectedStateGSNominations ?? '0',
      "CSN_DP": selectedDistrictNominations ?? '0',
      "CSN_AP": selectedAssemblyNominations,
      "CSN_BL": selectedBoothNominations,
      "AGGR_ID": aggrId,
      "VERIFICATION_CODE": verificationCodeController.text,
      "ID_DOCUMENT": pickedIdProofPath,
      "AM_PHOTO": pickedAMFilePath,
      "DOCUMENT_BACK_PATH": pickedDocumentBackFilePath,
      "CHANNEL": "M",
      "RELATION_CODE": "F",
      "ORGANIZATION_CODE": "NSUI"
    };
    await syncMembership(context, currentMember, data: newMemberData);
    // }
  }

  syncMembership(BuildContext context, BatchMember? currentMember,
      {Map<String, dynamic>? data}) async {
    var aggrId = await LocalStorageServices().getAgrIDMembership();
//
    var memberData = [];

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
        await membershipDbRepo.insertData(currentMember);
        final list = await membershipDbRepo.getData(currentMember.batchId!);
        int count = list.length;
        await BatchDBRepo(sl()).updateAMCount(
            BatchDataModel(batchId: currentMember.batchId!, countAM: count));

        MembershipMemberListController memberListController =
            Get.find<MembershipMemberListController>();
        await memberListController.getMembershipList(
            Get.context!, memberListController.batchId);
        MembershipBatchController membershipBatchController =
            Get.find<MembershipBatchController>();
        await membershipBatchController.getMembershipBatchList(Get.context!);
//
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

        var result = await membershipNSUISuccessBottomSheet(context);
        if (result == null) {
          membershipListController
              .getMembershipList(context, currentMember.batchId!, reload: true);
          // MembershipBatchController membershipBatchController =
          //     Get.find<MembershipBatchController>();
          // membershipBatchController.downloadExistingBatch(context: context);
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
        filename: "${member.memberId}_D.${pickedIdProofPath?.split(".").last}");

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
            "${member.memberId}_D_BACK.${pickedDocumentBackFilePath?.split(".").last}");

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

  void populateModel() {
    BatchMember membershipRequestModel = currentMember!;
    membershipRequestModel
      ..firstName = usernameController.text
      ..lastName = lastNameController.text
      ..profession = professionController.text
      ..relativeName = fatherNameController.text
      ..relationCode = "F"

      ///Personal Detail
      ..dob = selectedDate
      ..category = selectedCategory
      ..gender = selectedGender
      ..education = courseController.text //selectedEducation

      /// Contact Detail
      ..address = addressController.text
      ..pin = pinController.text
      ..city = "City Name Something"
      ..mobile = mobileController.text
      ..email = emailController.text

      /// ID proof
      ..modifiedOn = DateTime.now().toString()
      ..isSync = "0"
      ..isEditedScrutiny = "0"
      ..idType = selectedIdProof
      ..amPhotoFilePath = pickedAMFilePath
      ..modifiedOn = DateTime.now().toString()
      ..isSync = "0"
      ..isEditedScrutiny = "0"
      ..idDocumentFilePath = pickedIdProofPath
      ..videoFilePath = pickedVideoFilePath
      ..documentBackPath = pickedDocumentBackFilePath
      ..idValue = idController.text
      ..referrerId = ""
      //
      ..districtCode = selectedDistrict ?? ''
      ..districtName = selectedDistrict ?? ''
      ..assemblyCode = selectedAssembly ?? ''
      ..boothCode = selectedBooth ?? ''
      ..modifiedOn = DateTime.now().toString()
      ..isEditedScrutiny = "0"
      ..assemblyName = selectedAssembly ?? ''
      ..mandalamCode = selectedBooth ?? ""
      ..statePresidentCandidate = selectedStatePresidentNominations
      ..stateGSCandidate = selectedStateGSNominations
      ..districtCandidate = selectedDistrictNominations
      ..districtGsCandidate = selectedDistrictGsNominations
      ..blockCandidate = selectedBlockNominations
      ..mandalamCandidate = selectedMandalamNominations
      ..assemblyCandidate = selectedAssemblyNominations ?? "999"
      ..boothCandidate = selectedBoothNominations;
    // if (membershipRequestModel.stateCode == "TS") {
    //   membershipRequestModel
    //     ..statePresidentCandidate = "0"
    //     ..stateGSCandidate = "0"
    //     ..districtCandidate = "999"
    //     ..assemblyCandidate = "999";
    // }
    setCurrentMember(membershipRequestModel);
  }

  void onSubmit(BuildContext context) async {
    // if (isUpdate) {
    //   Get.back();
    //   return;
    // }
    if (await validateCurrentStep(context)) {
      populateModel();
      try {
        await memberSaveToDB(context, isUpdate);
        // Navigator.of(context).pop();
      } catch (e) {
        Log.printELog(e);
        // CustomSnackBar.showErrorSnackBar(
        //     'Something went wrong. Please try again $e');
      }
      // MembershipMemberListController logic = Get.find<MembershipMemberListController>();
      // logic.getMembershipList(context, logic.batchId);
    }
  }

  /// Variable and function related to basic detail form
  ///
  ///
  ///
  ///    * 0:[_basicDetails]
  //    *
  //    */
  String? membershipId;
  bool disableFields = false;

  GlobalKey<FormState> basicDetailFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  Future<bool> validateBasicDetails(BuildContext context) async {
    bool isFieldsValid = false;
    if (basicDetailFormKey.currentState?.validate() ?? false) {
      basicDetailFormKey.currentState!.save();
      isFieldsValid = true;
      // return true;
    }
    selectedGender == null
        ? CustomSnackBar.showErrorSnackBar('Select Gender')
        : selectedDate == null
            ? CustomSnackBar.showErrorSnackBar(
                "Select a date",
              )
            : null;
    if (await validateOtpPage(context)) {
      isFieldsValid = true;
    } else {
      isFieldsValid = false;
    }
    bool isValid =
        (selectedGender != null && selectedDate != null && isFieldsValid);
    return isValid;
  }

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

  void saveBasicDetails() {
    if (currentMember != null) {
      currentMember!
        ..firstName = usernameController.text
        ..lastName = lastNameController.text
        ..profession = professionController.text
        ..relativeName = fatherNameController.text
        ..relationCode = "F";
      update();
    }
  }

  // void refresh() {
  //   try {
  //     membershipId = "";
  //     usernameController.clear();
  //     lastNameController.clear();
  //     professionController.clear();
  //     fatherNameController.clear();
  //     basicDetailFormKey.currentState!.reset();
  //   } catch (e) {
  //   } finally {
  //     update();
  //   }
  // }
  //
  // bool validateForm() {
  //   final isValid = basicDetailFormKey.currentState!.validate();
  //   if(isValid){
  //     basicDetailFormKey.currentState!.save();
  //   }
  //   return isValid;
  // }

  /// Personal detail form
  ///
  ///
  GlobalKey<FormState> personalDetailFormKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();
  String? selectedGender;
  String? selectedCategory;
  String? selectedEducation;
  String? selectedDate;

  DateTime eventDate = DateTime.now();

  List<DropdownItem> gender = [
    DropdownItem("Male", "Male"),
    DropdownItem("Female", "Female"),
    DropdownItem("Other", "Other"),
  ];
  List<DropdownItem> category = [
    DropdownItem("General", "General"),
    DropdownItem("MBC", "MBC"),
    DropdownItem("SC", "SC"),
    DropdownItem("ST", "ST"),
    DropdownItem("OBC", "OBC"),
    DropdownItem("Minority", "Minority"),
    DropdownItem("Specially abled", "PH"),
    DropdownItem("Transgender", "TG"),
    DropdownItem("Unknown", "Unknown"), //Minority
  ];
  List<DropdownItem> educationalDetailsList = [
    DropdownItem("Graduate", "Graduate"),
    DropdownItem("Non Graduate", "NonGraduate")
  ];

  String? dobError;

  void onChangeDate(DateTime timeData) {
    if (!DobRules.isValid(timeData)) {
      dobError = DobRules.errorText(timeData);
      CustomSnackBar.showErrorSnackBar(dobError!);
      update();
      return;
    }
    dobError = null;
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

  bool validatePersonalDetails() {
    Log.printILog('Validating personal detail');
    selectedGender == null
        ? CustomSnackBar.showErrorSnackBar('Select Gender')
        : selectedEducation == null
            ? CustomSnackBar.showErrorSnackBar("Select Education")
            : selectedCategory == null
                ? CustomSnackBar.showErrorSnackBar("Select Category")
                : selectedDate == null
                    ? CustomSnackBar.showErrorSnackBar(
                        "Select a date",
                      )
                    : null;
    bool isValid = (selectedGender != null &&
        selectedDate != null &&
        selectedCategory != null &&
        selectedEducation != null);
    return isValid;
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
  GlobalKey<FormState> contactDetailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobileFormKey = GlobalKey();

  TextEditingController verificationCodeController = TextEditingController();

  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  TextEditingController pinController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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

  String? selectedIdProof;
  List<DropdownItem> idProofList = [
    DropdownItem("Passport", "PP"),
    DropdownItem("Epic Voter ID", "EI"),
    DropdownItem("Aadhar Card", "AC"),
    DropdownItem("Driving Licence", "LD"),
  ];
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

  void onChangeIdProof(String val) {
    selectedIdProof = val;
    update();
  }

  Future<bool> checkPreFillDataForIDProofForm(BuildContext context) async {
    BatchMember membershipRequestModel = member;
    selectedIdProof = membershipRequestModel.idType ?? "EI";
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

  void clickLivePhoto() async {
    // M7LivelynessDetection.instance.configure(
    //   contourColor: Colors.white,
    //   thresholds: [
    //     M7SmileDetectionThreshold(
    //       probability: 0.8,
    //     ),
    //     M7BlinkDetectionThreshold(
    //       leftEyeProbability: 0.25,
    //       rightEyeProbability: 0.25,
    //     ),
    //   ],
    // );
    // final String? response =
    // await M7LivelynessDetection.instance.detectLivelyness(
    //   Get.context!,
    //   config: M7DetectionConfig(
    //     maxSecToDetect: 600,
    //     steps: [
    //       M7LivelynessStepItem(
    //         step: M7LivelynessStep.smile,
    //         title: "Smile",
    //         isCompleted: false,
    //       ),
    //       M7LivelynessStepItem(
    //         step: M7LivelynessStep.blink,
    //         title: "Blink",
    //         isCompleted: false,
    //       ),
    //     ],
    //     startWithInfoScreen: false,
    //     captureButtonColor: Colors.red,
    //   ),
    // );
    // Log.printDLog(response);
    // if(response == null){
    //   CustomSnackBar.showErrorSnackBar('No live person detected.');
    // }
    // else{
    //   pickedAMFile = File(response);
    //   pickedAMFilePath = pickedAMFile!.path;
    //   showAMImage = true;
    //   update();
    // }
  }

  Future<void> saveVideo(File result) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/${p.basename(result.path)}';

    // Guard against a self-copy (src == dest), which would truncate the file
    // to 0 bytes and corrupt the recording.
    final File _image = (result.path == filePath)
        ? result
        : await File(result.path).copy(filePath);

    pickedVideoFile = _image;
    pickedVideoFilePath = _image.path;
    showVideoFile = true;
    update();
  }

  Future<void> pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType, BuildContext context) async {
    //  FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    final result =
        await ImageServices().pickImage(imageSource, cropimage: false);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      File image;
      image = File(result.path);
      //  final myImagePath = '/storage/emulated/0/Download' ;
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      switch (documentType) {
        case DocumentType.amImage:
          pickedAMFile = _image;
          pickedAMFilePath = pickedAMFile!.path;
          showAMImage = true;
          break;
        case DocumentType.idFront:
          pickedIdFile = _image;
          pickedIdProofPath = pickedIdFile!.path;
          showIdImage = true;
          break;
        case DocumentType.idBack:
          pickedDocumentBack = _image;
          pickedDocumentBackFilePath = pickedDocumentBack!.path;
          showDocumentBack = true;
          break;
        case DocumentType.amVideo:
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
        case DocumentType.dob:
          // TODO: Handle this case.
          break;
        case DocumentType.barCouncilId:
          break;
      }
      update();
    } else {
      Log.printILog("File picked not");
      return null;
    }
  }

  void clickLivePhotoNew(BuildContext context) async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      XFile result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FaceDetectionPage(),
        ),
      );
      if (result == null) {
        CustomSnackBar.showErrorSnackBar('No live person detected.');
      } else {
        pickedAMFilePath = result.path;
        pickedAMFile = File(pickedAMFilePath!);
        showAMImage = true;
        update();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not active!')),
      );
    }
  }

  bool validateIDProof() {
    // if (idController.text.isEmpty) {
    //   CustomSnackBar.showErrorSnackBar('Enter ID document number');
    //   return false;
    // }//new
    // if (selectedIdProof == null) {
    //   CustomSnackBar.showErrorSnackBar("Select an Id Proof");
    //   return false;
    // }
    if (pickedIdProofPath == null ||
            pickedAMFilePath == null ||
            pickedDocumentBackFilePath == null
        // ||
        // pickedVideoFilePath == null//new
        ) {
      CustomSnackBar.showErrorSnackBar("Upload all documents");
      return false;
    }
    return
        //  selectedIdProof != null &&
        pickedAMFilePath != null &&
            pickedIdProofPath != null &&
            pickedDocumentBackFilePath != null
        // &&
        // pickedVideoFilePath != null//new
        ;
  }

  /// Constituency Details
  ///
  ///
  void initConstituencyForm(BuildContext context) {
    // if (["KL", "TL", "KA", "DL", "HP", "LA"]
    //     .contains(selectedState?.stateCode)) {
    //   mandalamEnabled = true;
    //   Log.printDLog("Mandalam Enabled for state ${selectedState?.stateCode}");
    // }
    getStatesList();
    // createBoothList();
  }

  bool mandalamEnabled = true;

  List<States>? stateList;
  List<DropdownItem> districtDropdownItems = [];
  List<DropdownItem> assemblyDropdownItems = [];
  List<DropdownItem> mandalamDropdownItems = [];
  List<DropdownItem> boothDropdownItems = [];

  States? selectedState;
  String? selectedDistrict;
  String? selectedAssembly;
  String? selectedMandalam;
  String? selectedBooth;

  void onChangedDistrict(String value) {
    selectedDistrict = value;
    selectedAssembly = null;
    selectedMandalam = null;
    update();
    getAssemblyList();
  }

  void onChangedAssembly(String value) {
    selectedAssembly = value;
    Log.printDLog(selectedAssembly);
    selectedMandalam = null;
    update();
    createBoothList();
    // getMandalamList();
  }

  void onChangedMandalam(String value) {
    selectedMandalam = value;
    update();
  }

  void onChangedBooth(String value) {
    selectedBooth = value;
    update();
  }

  Future<void> getStatesList() async {
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
    String stateCode = "${await LocalStorageServices().getSTCode()}";
    stateList!.forEach((element) {
      if (element.stateCode == stateCode) {
        selectedState = element;
      }
    });
    // selectedStateName = selectedState!.name;
    update();
    await getDistrictList();
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

  Future<dynamic> getDistrictBallots() async {
    ApiResponse apiResponse =
        await constantApiRepo.getDistrictBallotApi(selectedState!.stateCode);
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

  Future<dynamic> getUniversityBallots() async {
    ApiResponse apiResponse = await constantApiRepo.getUniversityBallotApi(
        selectedState!.stateCode, selectedDistrict);
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

  Future<dynamic> getCollegeBallots() async {
    ApiResponse apiResponse = await constantApiRepo.getCollegeBallotApi(
        selectedState!.stateCode, selectedDistrict, selectedAssembly);
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

  Future<void> getDistrictList() async {
    districtDropdownItems.clear();
    // var districtList =
    //     await DbServices.db.getAllDistrict(selectedState?.stateCode ?? '');
    List<Districts>? districtList = [];

    var result = await getDistrictBallots();
    if (result == null) {
      districtList = [];
    } else {
      districtList = [];
      for (var i in result) {
        districtList.add(Districts(
            id: 0,
            name: i['district'],
            stateCode: selectedState!.stateCode,
            isEnabled: '',
            districtCode: i['district_code']));
      }
    }

    // Log.printILog('${districtList.length}, ${selectedState!.stateCode}');
    if (districtList.isNotEmpty) {
      for (var i in districtList) {
        districtDropdownItems.add(DropdownItem(i.name, i.districtCode));
      }
    }
    districtDropdownItems.toSet().toList();
    update();
  }

  Future<void> getAssemblyList() async {
    assemblyDropdownItems.clear();
    // var assemblyList = await DbServices.db.getAllAssembly(
    //     Districts(
    //         id: 1,
    //         stateCode: selectedState!.stateCode,
    //         districtCode: selectedDistrict!,
    //         isEnabled: '0',
    //         name: ''),
    //     stateCode: selectedState?.stateCode);
    List<Assembly>? assemblyList = [];

    var result = await getUniversityBallots();
    if (result == null) {
      assemblyList = [];
    } else {
      assemblyList = [];
      for (var i in result) {
        assemblyList.add(Assembly(
            id: 0,
            districtCode: selectedDistrict,
            name: i['university'],
            stateCode: selectedState!.stateCode,
            isEnabled: '',
            assemblyCode: i['university_code']));
      }
    }
    Log.printILog('${assemblyList.length}, ${selectedDistrict}');
    if (assemblyList.isNotEmpty) {
      for (var i in assemblyList) {
        assemblyDropdownItems.add(DropdownItem(i.name, i.assemblyCode));
      }
    }

    update();
  }

  Future<void> getMandalamList() async {
    var mandalamList = await DbServices.db.getAllMandalams(
        Assembly(
            id: 0,
            districtCode: selectedDistrict ?? '',
            name: 'name',
            stateCode: selectedState!.stateCode,
            isEnabled: '0',
            assemblyCode: selectedAssembly!),
        stateCode: selectedState!.stateCode);
    if (mandalamList.isNotEmpty)
      mandalamDropdownItems = List.generate(
          mandalamList.length,
          (index) => DropdownItem(mandalamList[index].mandalamName,
              mandalamList[index].mandalamCode));
    update();
  }

  Future<void> createBoothList() async {
    List<Booth> _boothList = [];
    var result = await getCollegeBallots();
    if (result == null) {
      _boothList = [];
    } else {
      _boothList = [];
      for (var i in result) {
        _boothList.add(Booth(
            id: 0,
            districtCode: selectedDistrict!,
            stateCode: selectedState!.stateCode,
            assemblyCode: selectedAssembly!,
            blockCode: '',
            boothCode: i['college_code'],
            boothName: i['college']));
      }
    }
    if (_boothList.isNotEmpty) {
      for (var i in _boothList) {
        boothDropdownItems.add(DropdownItem(i.boothName, i.boothCode));
      }
    }

    update();
  }

  bool validateConsistencyForm() {
    if (selectedDistrict == null) {
      CustomSnackBar.showErrorSnackBar("select a District");
      return false;
    }
    if (selectedAssembly == null) {
      CustomSnackBar.showErrorSnackBar("Select a University/College");
      return false;
    }
    return true;
  }

  Future<void> checkForPrefillDataForConsistencyDetails() async {
    BatchMember membershipRequestModel = currentMember!;
    String stateCode = currentMember?.stateCode ??
        "${await LocalStorageServices().getSTCode()}";
    // stateList = await DbServices.db.getAllStates(true);
    await getStatesList();
    stateList!.forEach((element) {
      if (element.stateCode == stateCode) {
        selectedState = element;
      }
    });
    // await getDistrictList();
    membershipRequestModel.stateName = selectedState!.name;
    membershipRequestModel.stateCode = selectedState!.stateCode;
    if (membershipRequestModel.districtCode != null &&
        membershipRequestModel.districtCode != "null")
      selectedDistrict = membershipRequestModel.districtCode;

    // selectedDisName = selectedDistrict?.name;
    if (selectedDistrict != null) {
      await getAssemblyList();
      await createBoothList();
      selectedBooth = membershipRequestModel.boothCode;
    }
    if (membershipRequestModel.assemblyCode != null &&
        membershipRequestModel.assemblyCode !=
            "null") //null string may populated in db checking
      selectedAssembly = membershipRequestModel.assemblyCode;
    // await getMandalamList();//jp
    selectedMandalam = membershipRequestModel.mandalamCode;
    if (["KL", "TL", "KA", "DL", "HP", "LA"]
        .contains(membershipRequestModel.stateCode)) {
      await getMandalamList();
      selectedMandalam = membershipRequestModel.mandalamCode;
      update();
    }

    // if (membershipRequestModel.blockCode != null &&
    //     membershipRequestModel.blockCode != "")
    //   selectedBlock = blocksList!.firstWhere(
    //           (element) => element.blockCode == membershipRequestModel.blockCode);

    // if (selectedBlock != null) await getBoothList();

    if (membershipRequestModel.boothCode != null &&
        membershipRequestModel.boothCode!.isNotEmpty &&
        membershipRequestModel.boothCode != "null")
      selectedBooth = membershipRequestModel.boothCode;

    // selectedAssemblyName = selectedAssembly?.name;
    update();
  }

  bool otpSend = false;
  bool otpVerified = false;
  final FocusNode otpCodeFocus = FocusNode();
  changePhoneNumberStatus() {
    print("calledd");
    otpSend = false;
    otpVerified = false;
    update();
  }

  Future<bool> validateOtpPage(BuildContext context) async {
    // return true;
    /// bypass otp verification for test state
    var stateCode = Get.find<HomeNSUIController>()
            .profileController
            .userDetail
            ?.stateCode ??
        '';
    if (stateCode == 'TS') return true;

    if (!otpVerified) await verifyOtpForMember(context);
    return otpVerified;
  }

  getOtp(BuildContext context) async {
    showNetworkLoadingDialog(context);
    Map d = {
      "ST_CODE": "${await LocalStorageServices().getSTCode()}",
      "MOBILE": "${mobileController.text}",
      "CHANNEL": "${AppConstants.channel}",
      "V":
          "${isLegalCellReg ? AppConstants.legalCellVersion : AppConstants.membershipVersion}",
      "DEVICE_ID": "${await getDeviceIdentifier()}"
    };
    if (isLegalCellReg)
      d.addAll({
        "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
        "USER_ID": "${await LocalStorageServices().getUserId()}",
        "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}",
        "ORG": "LC"
      });
    var testJsonData = '''[${json.encode(d)}]''';
    ApiResponse apiResponse = await apiConfig!.postData(
        endpointUrl: isLegalCellReg ? Urls.getOtpLegalCell : Urls.checkAMMobile,
        jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        otpSend = true;
        update();
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      update();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  verifyOtpForMember(BuildContext context) async {
    if (!otpSend) {
      CustomSnackBar.showErrorSnackBar("kindly get OTP and then verify it");
      return false;
    }
    if (verificationCodeController.text.isEmpty) {
      CustomSnackBar.showErrorSnackBar(
          "kindly fill verification code send to your mobile");
      return false;
    }
    showNetworkLoadingDialog(context);
    Map d = {
      "ST_CODE": "${await LocalStorageServices().getSTCode()}",
      "MOBILE": "${mobileController.text}",
      "OTP": "${verificationCodeController.text}",
      "CHANNEL": "${AppConstants.channel}",
      "V":
          "${isLegalCellReg ? AppConstants.legalCellVersion : AppConstants.membershipVersion}",
      "DEVICE_ID": "${await getDeviceIdentifier()}"
    };
    if (isLegalCellReg)
      d.addAll({
        "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
        "USER_ID": "${await LocalStorageServices().getUserId()}",
        "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}",
        "ORG": "LC",
      });
    var testJsonData = '''[${json.encode(d)}]''';
    ApiResponse apiResponse = await apiConfig!.postData(
        endpointUrl:
            isLegalCellReg ? Urls.verifyLegalCellMobile : Urls.verifyAMMobile,
        jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        otpVerified = true;
        update();
      } else {
        otpVerified = false;
        Navigator.of(context).pop();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
      update();
    } else {
      otpVerified = false;
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
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
  // TODO: temporary dummy data for the University President dropdown
  // (searchForAssemblyNominations is disabled in Step 4 load; remove this
  // once the real "VS" ballot fetch is wired back in).
  List<Nomination> assemblyNominationsList = [
    Nomination(
        id: 1, name: "Rahul Sharma", csn: 1, firstName: "Rahul", lastName: "Sharma"),
    Nomination(
        id: 2, name: "Priya Verma", csn: 2, firstName: "Priya", lastName: "Verma"),
    Nomination(
        id: 3, name: "Amit Kumar", csn: 3, firstName: "Amit", lastName: "Kumar"),
    Nomination(
        id: 4, name: "Sneha Reddy", csn: 4, firstName: "Sneha", lastName: "Reddy"),
  ];
  List<Nomination> blockNominationsList = [];
  List<Nomination> boothNominationsList = [];

  Future searchForStatePresidentNominations(BuildContext context) async {
    statePresidentNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "SP",
        state: selectedState == null ? '' : selectedState!.stateCode,
        assembly: selectedAssembly ?? '',
        district: selectedDistrict ?? '',
        mandalam: selectedMandalam,
        blackCode: '',
        boothCode: selectedBooth == null ? '' : selectedBooth!);
    if (result != null) {
      int count = 1;

      statePresidentNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : count++,
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
    // notifyListeners();
  }

  Future searchForStateGeneralSecreNominations(BuildContext context) async {
    ///getting selected state/district/assembly code
    selectedState = selectedState!;
    selectedDistrict = selectedDistrict;
    selectedAssembly = selectedAssembly;

    ///get state data list from db
    stateGeneralSecretaryNominationsList = await DbServices.db
        .searchForStateNominations(
            stateCode: selectedState!.stateCode,
            contestingFor: "State General Secretary");

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
      stateGeneralSecretaryNominationsList.add(Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: ""));
    } else {
      stateGeneralSecretaryNominationsList.add(Nomination(
          id: 123456789,
          name: "NO Vote",
          csn: 0,
          firstName: "No Vote",
          lastName: ""));
    }

    //  update()();
  }

  Future searchForDistrictNominations(BuildContext context) async {
    // Log.printDLog('${selectedState!.stateCode}, ${selectedDistrict!}');
    // districtNominationsList = await DbServices.db.searchForDistrictNominations(
    //     stateCode: selectedState!.stateCode,
    //     districtCode: selectedDistrict!,
    //     contestingFor: "District President");
    districtNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "DP",
        state: selectedState == null ? '' : selectedState!.stateCode,
        // district: selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        assembly: selectedAssembly ?? '',
        district: selectedDistrict ?? '',
        mandalam: selectedMandalam,
        blackCode: '',
        boothCode: selectedBooth == null ? '' : selectedBooth!);
    if (result != null) {
      int count = 1;
      districtNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : count++,
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
    // if (districtNominationsList.any((element) =>
    //     element.csn.toString() ==
    //     (currentMember?.districtCandidate ??
    //         false))) {
    //   selectedDistrictNominations =
    //       currentMember?.districtCandidate;
    // } else {
    //   selectedDistrictNominations = null;
    // }
  }

  List<Nomination> districtGsNominationsList = [];
  String? selectedDistrictGsNominations;

  Future searchForDistrictGsNominations(BuildContext context) async {
    districtNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "DP",
        state: selectedState == null ? '' : selectedState!.stateCode,
        // district: selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        assembly: selectedAssembly ?? '',
        district: selectedDistrict ?? '',
        mandalam: selectedMandalam,
        blackCode: '',
        boothCode: selectedBooth ?? '');
    if (result != null) {
      int count = 1;
      districtNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : count++,
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
    update();
  }

  Future searchForAssemblyNominations(BuildContext context) async {
    assemblyNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
        ballot: "VS",
        state: selectedState == null ? '' : selectedState!.stateCode,
        assembly: selectedAssembly ?? '',
        district: selectedDistrict ?? '',
        //  assembly:
        //     selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        // district:
        //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        mandalam: selectedMandalam,
        blackCode: '',
        boothCode: selectedBooth ?? '');
    if (result != null) {
      int count = 1;
      assemblyNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : count++, //Random().nextInt(100),
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
    update();
  }

  Future searchForBlockNominations(BuildContext context) async {
    blockNominationsList = await DbServices.db.searchForBlockNominations(
        stateCode: selectedState!.stateCode,
        districtCode: selectedDistrict!,
        blockCode: "0",
        contestingFor: "Block");
    if (blockNominationsList.isEmpty) {
      blockNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    } else {
      blockNominationsList.add(Nomination(
          id: 123456789,
          name: "NO Vote",
          csn: 0,
          firstName: "No Vote",
          lastName: ""));
    }
    if (blockNominationsList.any((element) =>
        element.csn.toString() == (currentMember?.blockCandidate ?? false))) {
      //print("here....................");
      selectedBlockNominations = currentMember?.blockCandidate;
    } else {
      selectedBlockNominations = null;
      //update()();
    }
  }

  String? selectedMandalamNominations;
  List<Nomination> mandalamNominationsList = [];

  Future searchFormandalamNominations(BuildContext context) async {
    mandalamNominationsList = await DbServices.db.searchForMandalamNominations(
        stateCode: selectedState!.stateCode,
        districtCode: selectedDistrict!,
        blockCode: selectedMandalam ?? "",
        contestingFor: "Mandalam");
    if (mandalamNominationsList.isEmpty) {
      mandalamNominationsList = [
        Nomination(
            id: 123456789,
            name: "NO Nomination",
            csn: 999,
            firstName: "No Nomination",
            lastName: "")
      ];
    } else {
      mandalamNominationsList.add(Nomination(
          id: 123456789,
          name: "NO Vote",
          csn: 0,
          firstName: "No Vote",
          lastName: ""));
    }
    if (mandalamNominationsList.any((element) =>
        element.csn.toString() ==
        (currentMember?.mandalamCandidate ?? false))) {
      //print("here....................");
      selectedMandalamNominations = currentMember?.mandalamCandidate;
    } else {
      selectedMandalamNominations = null;
      //update()();
    }
  }

  Future searchForBoothNominations(BuildContext context) async {
    boothNominationsList = [];
    List<dynamic>? result = await getNominationBallotList(
      ballot: "MD",
      state: selectedState == null ? '' : selectedState!.stateCode,
      district: selectedDistrict ?? '',
      blackCode: '',
      boothCode: selectedBooth ?? '',
      assembly: selectedAssembly ?? '',
      // district:
      //     selectedDistrict == null ? '' : selectedDistrict!.districtCode,
      mandalam: selectedMandalam,
      // blackCode: selectedBlock == null ? '' : selectedBlock!.blockCode,
      // boothCode: selectedBooth == null ? '' : selectedBooth!.boothCode
    );
    if (result != null) {
      int count = 1;

      boothNominationsList = result
          .map((test) => Nomination(
              id: 0,
              name: test['FIRST_NAME'],
              csn: (test['CSN'] != null && test['CSN'] != "")
                  ? int.parse(test['CSN'].toString())
                  : count++,
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

    update();
  }

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

  changeStateNomination(String val) {
    selectedStatePresidentNominations = val;
    update();
  }

  changeStateGSNomination(String val) {
    selectedStateGSNominations = val;
    update();
  }

  changeDistrictNomination(String val) {
    selectedDistrictNominations = val;
    update();
  }

  changeDistrictGsNomination(String val) {
    selectedDistrictGsNominations = val;
    update();
  }

  changeAssemblyNomination(String val) {
    selectedAssemblyNominations = val;
    update();
  }

  changeMandalamNomination(String val) {
    selectedMandalamNominations = val;
    update();
  }

  changeBlockNomination(String val) {
    selectedBlockNominations = val;
    update();
  }

  changeBoothNomination(String val) {
    selectedBoothNominations = val;
    update();
  }

  bool declarationStatus = false;

  changeDeclarationStatus(bool value) {
    declarationStatus = value;
    update();
  }

  checkForPrefill(BuildContext context) async {
    /// for edit mode fetch data from table
    // selectedState =
    //     selectedState!;
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
    statePresidentNominationsList = [];
    districtGsNominationsList = [];
    assemblyNominationsList = [];
    boothNominationsList = [];
    BatchMember membershipRequestModel = currentMember!;
    selectedStatePresidentNominations =
        membershipRequestModel.statePresidentCandidate;
    selectedDistrictNominations = membershipRequestModel.districtCandidate;
    selectedAssemblyNominations = membershipRequestModel.assemblyCandidate;
    selectedBoothNominations = membershipRequestModel.boothCandidate;
    declarationStatus = true;
    update();
    // debugPrint(membershipRequestModel.statePresidentCandidate);
    // selectedStateGSNominations = membershipRequestModel.stateGSCandidate;
    // debugPrint(membershipRequestModel.stateGSCandidate);
    // return await initialize(context);
  }

  bool validatePage(BuildContext context) {
    // Step 4 now collects only the University/College President candidate.
    // State/District/College President candidates are hidden (candidate
    // selection happens at the University/College level only), so they are
    // not validated here.
    if (selectedAssemblyNominations == null) {
      CustomSnackBar.showErrorSnackBar(
          "Select University/College President Nomination");
      return false;
    }
    if (!declarationStatus) {
      CustomSnackBar.showErrorSnackBar("Kindly accept declaration to continue");
      return false;
    }
    return true;
  }

  // String? selectedMandalam;

  Future initialize(BuildContext context) async {
    isLoading = true;

    ///getting selected state/district/assembly code
    selectedState = selectedState!;
    selectedDistrict = selectedDistrict;
    selectedAssembly = selectedAssembly;
    selectedBooth = selectedBooth;
    selectedMandalam = selectedMandalam;

    final result = await Future.wait<dynamic>([
      searchForStatePresidentNominations(context),
      searchForStateGeneralSecreNominations(context),
      searchForDistrictNominations(context),
      // searchForDistrictGsNominations(context),
      // if (["KL", "TL", "KA", "DL", "HP", "LA"]
      //     .contains(selectedState!.stateCode))
      //   searchFormandalamNominations(context),
      // searchForAssemblyNominations(context),
      // searchForBoothNominations(context),
    ]);
    isLoading = false;
    update();
    return result;
  }
}
