import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:iyc/utils/dob_rules.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/constant_repo.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/model/api_model/auth/dob_range_model.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/data_model/nomination_member.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/blocks.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/mandalam.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/repository/nomination_repo.dart';
import 'package:iyc/app/data/resources/repository/payment_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/screens/ui/nominations_phase2/nomination_FailedPayment_bootom_sheet_nsui_phase2.dart';
import 'package:iyc/screens/ui/nominations_phase2/nomination_paymentConfirmation_bootom_sheet_nsui_phase2.dart';
import 'package:iyc/screens/ui/nominations_phase2/nomination_success_bootom_sheet_nsui_phase2.dart';
import 'package:iyc/screens/ui/payment/payment_screen.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/nomination_phase2/view_nomination_vm_phase2.dart';
import 'package:iyc/view_model/payment/payment_screen_vm.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di_container.dart';

enum NominationStatusPhase2 { UNPAID, PAID, NOT_NOMINATED }

/// Phase 2 already knows the member, so the form is cut down to just the
/// Level Of Candidate + State/District pickers and the declaration, and the
/// submit posts a 4-field payload to addNominationPhase2.php. The full Phase 1
/// form is still in the widget tree behind this flag — flip it to false to
/// bring everything back.
const bool kPhase2SimplifiedForm = true;

/// ⚠️ TEST ONLY — when true, sends ₹1 to the payment gateway instead of the
/// real nomination amount so the payment flow can be exercised without a large
/// charge. Keep this false outside of testing.
const bool kPhase2TestPaymentAmountOfOne = false;

class NominationsProviderPhase2 extends ChangeNotifier {
  final ApiConfig apiConfig;

  NominationsProviderPhase2({
    required this.apiConfig,
  }) {
    getInitData();
  }

  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController idCardNumberController = TextEditingController();
  TextEditingController studentidNumberController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController socialMediaController = TextEditingController();

  GlobalKey _dropdownButtonKey = GlobalKey();

  get dropdownButtonKey => _dropdownButtonKey;

  bool isFirstTimeNomination = true;
  bool showError = false;
  String? selectedDate;
  String? selectedEducation;
  String? selectedIdProof = "AC";
  String? selectedCandidateLevel;
  DateTime eventDate = DateTime.now();

  NominationStatusPhase2? nominationStatus;
  NominationMember? nominationData;

  String? selecteduniversity;

  List<DropdownItem> educationalDetailsList = [
    DropdownItem("Graduate", "Graduate"),
    DropdownItem("Undergraduate", "Undergraduate")
  ];

  List<DropdownItem> universityList = [
    DropdownItem("Bangalore University", "Bangalore University"),
  ];
  List<DropdownItem> idProofList = [
    DropdownItem("Aadhaar Card", "AC"),
  ];
  List<DropdownItem> genders = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
    DropdownItem("Transgender", "TG")
  ];
  List<DropdownItem> bloodGroups = [
    DropdownItem("A+", "A+"),
    DropdownItem("A-", "A-"),
    DropdownItem("B+", "B+"),
    DropdownItem("B-", "B-"),
    DropdownItem("O+", "O+"),
    DropdownItem("O-", "O-"),
    DropdownItem("AB+", "AB+"),
    DropdownItem("AB-", "AB-")
  ];
  List<DropdownItem> bPLsubsidyYesorNo = [
    DropdownItem("Yes", "Y"),
    DropdownItem("No", "N"),
  ];
  List<DropdownItem> criminalcaseYseorNo = [
    DropdownItem("Yes", "Y"),
    DropdownItem("No", "N"),
  ];
  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>? assemblyList;
  String? selectedGender;
  String? selectedBloodGroup;
  Districts? selectedDistrict;
  Assembly? selectedAssembly;
  String? selectedMandalam;

  States? selectedState;
  Booth? selectedBooth;
  Blocks? selectedBlock;

  List<Blocks>? blocksList;
  List<Booth>? boothsList;
  List<DropdownItem>? blockListDropDown;
  List<DropdownItem>? boothListDropDown;

  List<Mandalam>? mandalamList;
  bool mandalamEnabled = false; //
  List<DropdownItem>? mandalamListDropDown;

  final String defaultState = "Select State";
  final String defaultConstituency = "Select Parliamentary Constituency";
  final String defaultAssembly = "Select University";
  String selectedStateName = "Select State";
  String? selectedDisName;
  String? selectedAssemblyName;

  File? pickedIdFile;
  File? pickedStudentIdFile;
  File? pickedStudentIdBackFile;

  File? pickedIdBackFile;
  File? pickedCaseFile;
  File? pickedProfileFile;
  File? pickedVideoFile;
  File? pickedBPLFile;
  File? pickedCategoryFile;
  File? pickedDobFile;

  bool showIdImage = false;
  bool showProfileImage = false;
  bool showStudentIdImage = false;
  bool showStudentIdBackImage = false;

  bool showVideoFile = false;
  bool showBplImage = false;
  bool showPickedCaseFile = false;
  bool showPickedCategoryFile = false;
  bool showDobProof = false;

  String? pickedVideoFilePath;
  String? pickedIDBackFilePath;
  String? pickedStudentIDFilePath;
  String? pickedStudentIDBackFilePath;

  String? pickedCaseFilePath;
  String? pickedBPLFilePath;
  String? pickedIdProofPath;
  String? pickedProfileFilePath;
  String? pickedCategoryFilePath;
  String? pickedDobFilePath;

  bool isCategoryNeedDocuments = false;
  bool isSelectedFeeWaiverCategory = false;

  String? selectedCategory;
  List<DropdownItem> categoryList = [
    DropdownItem("General", "G"),
    // DropdownItem("MBC", "B"),
    DropdownItem("Minority", "M"),
    DropdownItem("OBC", "O"),
    DropdownItem("SC", "S"), //
    DropdownItem("ST", "T"), //
    DropdownItem("Specially abled", "PH"),
    // DropdownItem("Transgender", "TG"),
    DropdownItem("Unknown", "U"),
  ];
  /// Phase 2 nominates at State or District level only — the member's details
  /// are already known, so the level is the single thing they choose.
  List<DropdownItem> candidateLevelList = kPhase2SimplifiedForm
      ? [
          DropdownItem("State President", "10"),
          DropdownItem("District President", "20"),
        ]
      : [
          // First level of nomination happens only at University and College
          // DropdownItem("State President", "10"),
          // DropdownItem("District President", "20"),
          //DropdownItem("University President", "40"),
          DropdownItem("College/University President", "30"),
        ];

  // - PYC President
  // - PYC GS
  // - DYC President
  // - DYC GS
  // - Zonal President
  // - Block President
  //
  //
  // Meghalaya & Manipur Ballot:
  // - PYC President
  // - ⁠PYC GS
  // - ⁠DYC President
  // - ⁠DYC GS
  // - ⁠Assembly President
  int bplStatusVal = 0;
  String selectedIdType = "EI";
  String selectedDobProof = "10C";
  bool pendingCaseValue = false;
  bool declarationStatus = false;
  bool pendingCaseAttachStatus = false;
  bool loading = false;
  bool loadingInitData = false;
  String selectedCandidateLevelName = "";

  String nominationBatchNumber = "";

  bool showIdDocumentBack = false;
  bool enableMediaEdit = false;
  bool disableFields = false;
  List<String> scrutinyCodeList = [];

  String? amountTobePayed;
  String? orderId;
  String? nominationId;

  /// NOMINATION_ID / MEMBER_ID as returned by getNominationStatusPhase2.php.
  /// Phase 2 never generates its own member id — everything downstream
  /// (submit, payment, payment-status) reuses these two values.
  String? phase2NominationId;
  String? phase2MemberId;

  /// PAYMENT_STATUS from the status API (only meaningful for an
  /// EXISTING_NOMINATION).
  String phase2PaymentStatus = "";

  /// True once the server says a nomination already exists — the post is then
  /// fixed and the user can only pay, not re-apply.
  bool get isExistingNomination =>
      nominationStatus == NominationStatusPhase2.UNPAID ||
      nominationStatus == NominationStatusPhase2.PAID;

  /// Message shown when the status API returns a shape we don't recognise.
  String statusErrorMessage = "";
  bool isBlockModel = false;

  ///=======
  @override
  void dispose() {
    sl.popScopesTill("nomination_scope");
    super.dispose();
  }

  initNominations(BuildContext context) async {
    // isBlockModel = AppConstants.blockStatesList
    //     .contains(await LocalStorageServices().getSTCode());
    // if ([
    //   "KL",
    //   "TL",
    //   "KA",
    //   "DL",
    //   "HP",
    //   "LA",
    //   "LN",
    //   "TN",
    //   "HR",
    //   "TN",
    //   "MB",
    //   "GJ",
    //   "MP",
    //   "JH"
    // ].contains(await LocalStorageServices().getSTCode())) {
    //   mandalamEnabled = true;
    //   candidateLevelList.add(DropdownItem("Block/Ward", "50"));
    // }
    await getNominationStatus(context);
    mobileController.text = await LocalStorageServices().getMobile();
  }

  void openDropdown() {
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

  agrCreateBatch(BuildContext context) async {
    /// Phase 2 does NOT create an aggregator batch — the MEMBER_ID and
    /// NOMINATION_ID both come from getNominationStatusPhase2.php, so
    /// AggrCreateBatch.php is not part of this flow. Apply just moves the
    /// user on to the form.
    if (kPhase2SimplifiedForm) {
      isFirstTimeNomination = false;
      notifyListeners();
      return;
    }

    showNetworkLoadingDialog(context);
    // if (!mandalamEnabled) getBoothList();
    if (true) {
      var testJsonData = '''[{
    "AGGR_ID":"9999",
    "ST_CODE":"${await LocalStorageServices().getSTCode()}",
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"${AppConstants.channel}",
    "DEVICE_ID":"${await getDeviceIdentifier()}"

    }]''';
      print(testJsonData);
      ApiResponse value = await apiConfig.postData(
          endpointUrl: Urls.agrCreateBatch, jsonData: testJsonData);

      print(value);
      if (value.response != null && value.response!.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(value.response!.data)));
        print("-----------");
        if (responseDecoded['status'] == "SUCCESS") {
          nominationBatchNumber = responseDecoded['response']["BATCH_NO"];
          Navigator.of(context).pop();
          isFirstTimeNomination = false;
          notifyListeners();

          ///add batch new batch data to db

          // await nominationBatchDBProvider.addBatchDataToSql(
          //     data: BatchDataModel(
          //         countAM: 0,
          //         batchId: responseDecoded['response']['BATCH_NO'],
          //         paymentStatus: "PENDING",
          //         syncStatus: "0"),
          //     context: context);

          ///refresh batch list
          // await getNominationBatchList(context);
        } else {
          CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
        }
        notifyListeners();
      } else {
        CustomSnackBar.showErrorSnackBar(value.error.toString());
      }
    }
    // if (_nominationBatchList.isNotEmpty) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => MultiProvider(
    //           providers: [
    //             ChangeNotifierProvider(
    //               create: (context) => sl<NominationsProviderPhase2>(),
    //             ),
    //           ],
    //           child: NominationsMainPhase2(
    //             // memberId: _nominationBatchList.first.batchId,
    //             // mobile: mobileController.text,
    //           ))));
    // }
  }

  Future<bool> dobRange({required BuildContext context}) async {
    bool dobRangeDone = false;

    var testJsonData = '''[{
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}","STATE":"${await LocalStorageServices().getSTCode()}"}]''';

    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.DOBRange, jsonData: testJsonData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        DobRangeModel dobRangeModel = DobRangeModel.fromJson(responseDecoded);
        sl<SharedPreferences>()
            .setString("s3_access_token", dobRangeModel.response.s3Code!);
        sl<SharedPreferences>()
            .setString("s3_secret_key", dobRangeModel.response.s3Secret!);

        await LocalStorageServices()
            .setDobStartRange(dobRangeModel.response.dobstartrange!);
        await LocalStorageServices()
            .setDobEndRange(dobRangeModel.response.dobendrange!);
        dobRangeDone = true;
      } else {
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
    } else {
      CustomSnackBar.showErrorSnackBar(apiResponse.error.toString());
    }
    return dobRangeDone;
  }

  pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType) async {
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
      print("path=========");
      print(p.basename(result.path));
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      switch (documentType) {
        case DocumentType.amImage:
          pickedProfileFile = _image;
          pickedProfileFilePath = pickedProfileFile!.path;
          showProfileImage = true;
          break;
        case DocumentType.idFront:
          pickedIdFile = _image;
          pickedIdProofPath = pickedIdFile!.path;
          showIdImage = true;
          break;
        case DocumentType.idBack:
          pickedIdBackFile = _image;
          pickedIDBackFilePath = pickedIdBackFile!.path;
          showIdDocumentBack = true;
          break;
        case DocumentType.bpl:
          pickedBPLFile = _image;
          pickedBPLFilePath = pickedBPLFile!.path;
          showBplImage = true;
          break;
        case DocumentType.category:
          pickedCategoryFile = _image;
          pickedCategoryFilePath = pickedCategoryFile!.path;
          showPickedCategoryFile = true;
          break;
        case DocumentType.caseFile:
          pickedCaseFile = _image;
          pickedCaseFilePath = pickedCaseFile!.path;
          showPickedCaseFile = true;
          break;
        case DocumentType.amVideo:
          // TODO: Handle this case.
          break;
        case DocumentType.dob:
          pickedDobFile = _image;
          pickedDobFilePath = pickedDobFile!.path;
          showDobProof = true;
        case DocumentType.studentid:
          pickedStudentIdFile = _image;
          pickedStudentIDFilePath = pickedStudentIdFile!.path;
          showStudentIdImage = true;
        case DocumentType.evoderidFront:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.evoderidBack:
          pickedStudentIdBackFile = _image;
          pickedStudentIDBackFilePath = pickedStudentIdBackFile!.path;
          showStudentIdBackImage = true;
        // TODO: Handle this case.
        // throw UnimplementedError();
        case DocumentType.adhaaridFront:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.adhaaridBack:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.barCouncilId:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      notifyListeners();
    } else {
      print("file picked not");
      return null;
    }
  }

  changeCandidateLevel(String value) {
    selectedCandidateLevel = value;
    candidateLevelList.forEach((element) {
      if (element.value == value) {
        selectedCandidateLevelName = element.name;
      }
    });
    notifyListeners();
  }

  changePendingCaseAttachStatus(bool value) {
    pendingCaseAttachStatus = value;
    notifyListeners();
  }

  changeIdTypeStatus(String value) {
    selectedIdType = value;
    notifyListeners();
  }

  changeBplSubsidyStatus(int value) {
    bplStatusVal = value;
    notifyListeners();
  }

  changePendingCaseStatus(bool value) {
    pendingCaseValue = value;
    notifyListeners();
  }

  changeDeclarationStatus(bool value) {
    declarationStatus = value;
    notifyListeners();
  }

  getInitData() async {
   await getStatesList();
    loadingInitData = false;
    notifyListeners();
  }

  // Categories that require a supporting document / qualify for fee waiver:
  // SC ("S"), ST ("T"), Specially abled ("PH"). Exact-match so multi-char
  // codes like Transgender ("TG") don't accidentally collide via substring.
  static const List<String> _docRequiredCategories = ["S", "T", "PH"];

  changeCategory(String val) {
    selectedCategory = val;
    isCategoryNeedDocuments = _docRequiredCategories.contains(selectedCategory);
    notifyListeners();
  }

  changeGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  changeBloodGroup(String val) {
    selectedBloodGroup = val;
    notifyListeners();
  }

  String? dobError;

  changeDate(DateTime timeData) {
    if (!DobRules.isValid(timeData)) {
      dobError = DobRules.errorText(timeData);
      CustomSnackBar.showErrorSnackBar(dobError!);
      notifyListeners();
      return;
    }
    dobError = null;
    selectedDate = "${timeData.day}/${timeData.month}/${timeData.year}";
    eventDate = timeData;
    notifyListeners();
  }

  changeEducation(String val, [BuildContext? passedContext]) {
    if (passedContext != null) {}
    selectedEducation = val;
    notifyListeners();
  }

  getStatesList() async {
    // stateList = await DbServices.db.getAllStates(true); // true pick all states
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

    ///set selected state on login
    String stateCode = await LocalStorageServices().getSTCode();
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

  ConstantApiRepo constantApiRepo = ConstantApiRepo(dioClient: sl());

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
        selectedState!.stateCode, selectedDistrict!.districtCode);
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
        selectedState!.stateCode,
        selectedDistrict!.districtCode,
        selectedAssembly!.assemblyCode);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      } else {
        // CustomSnackBar.showErrorSnackBar(
        //   "No data Found : College",
        // );
        return null;
      }
    }
    // CustomSnackBar.showErrorSnackBar(
    //   "No data Found : College",
    // );
    return null;
  }

  getDistrictList() async {
    // districtList = await DbServices.db.getAllDistrict(selectedState!.stateCode);
    var result = await getDistrictBallots();
    if (result == null) {
      districtList = [];
    } else {
      districtList = [];
      for (var i in result) {
        districtList!.add(Districts(
            id: 0,
            name: i['district'],
            stateCode: selectedState!.stateCode,
            isEnabled: '',
            districtCode: i['district_code']));
      }
    }

    Log.printILog(selectedState!.stateCode);
    Log.printILog(districtList!.length);
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

  getMandalamList() async {
    Log.printDLog(
        '${selectedAssembly!.assemblyCode},stateCode: ${selectedState!.stateCode}');
    // mandalamList = await DbServices.db.getMandalams(selectedAssembly!);
    mandalamList = await DbServices.db.getAllMandalams(selectedAssembly!,
        stateCode: selectedState!.stateCode);
    if (mandalamList?.isNotEmpty ?? false)
      mandalamListDropDown = List.generate(
          mandalamList!.length,
          (index) => DropdownItem(mandalamList![index].mandalamName,
              mandalamList![index].mandalamCode));
    notifyListeners();
  }

  createBoothList() async {
    List<Booth> _boothList = [];
    var result = await getCollegeBallots();
    if (result == null) {
      _boothList = [];
    } else {
      _boothList = [];
      for (var i in result) {
        _boothList.add(Booth(
            id: 0,
            districtCode: selectedDistrict!.districtCode,
            stateCode: selectedState!.stateCode,
            assemblyCode: selectedAssembly!.assemblyCode,
            blockCode: '',
            boothCode: i['college_code'],
            boothName: i['college']));
      }
    }

    // List<Booth> _boothList = List.generate(
    //     500,
    //     (index) => Booth(
    //         id: int.parse((index + 1).toString().padLeft(3, '0')),
    //         districtCode: "",
    //         stateCode: "",
    //         assemblyCode: "",
    //         blockCode: '',
    //         boothCode: (index + 1).toString().padLeft(3, '0'),
    //         boothName: 'Booth No: ${(index + 1).toString().padLeft(3, '0')}'));
    return _boothList;
  }

  creteBoothListDropDown() async {
    List<DropdownItem> _boothListDropDown = List.generate(
        boothsList!.length,
        (index) => DropdownItem(
            boothsList![index].boothName, boothsList![index].boothCode));
    return _boothListDropDown;
  }

  getBoothList() async {
    boothsList = await createBoothList();
    boothListDropDown = await creteBoothListDropDown();
    return;

    boothsList = await DbServices.db.getBooths(selectedBlock!);
    if (boothsList?.isNotEmpty ?? false)
      boothListDropDown = List.generate(
          boothsList!.length,
          (index) => DropdownItem(
              "${boothsList![index].boothCode}:${boothsList![index].boothName}",
              boothsList![index].boothCode));
    notifyListeners();
  }

  void changeBlock(value) {
    selectedBlock =
        blocksList!.firstWhere((element) => element.blockCode == value);
    clearBooth();

    notifyListeners();
    getBoothList();
  }

  void changeBooth(String val) {
    selectedBooth =
        boothsList!.firstWhere((element) => element.boothCode == val);
    notifyListeners();
  }

  /// Phase 2 lets the user pick the State (Phase 1 leaves it fixed to the
  /// logged-in state and wires no onChanged). Changing it reloads districts.
  changeSelectedState(States state) {
    selectedState = state;
    selectedStateName = state.name;
    clearDistrict();
    notifyListeners();
    getDistrictList();
  }

  changeSelectedDistrict(Districts district) {
    selectedDistrict = district;
    selectedDisName = district.name;

    clearAssembly();
    // clearMandalams();
    // clearBlocks();
    notifyListeners();
    // isBlockModel ? getBlocksList() :
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
    // assemblyList = await DbServices.db
    //     .getAllAssembly(selectedDistrict!, stateCode: selectedState!.stateCode);

    var result = await getUniversityBallots();
    if (result == null) {
      assemblyList = [];
    } else {
      assemblyList = [];
      for (var i in result) {
        assemblyList!.add(Assembly(
            id: 0,
            districtCode: selectedDistrict!.districtCode,
            name: i['college_name'],
            stateCode: selectedState!.stateCode,
            isEnabled: '',
            assemblyCode: i['college_code']));
      }
    }
    notifyListeners();
    return true;
  }

  changeSelectedAssembly(Assembly assembly) {
    selectedAssembly = assembly;
    selectedAssemblyName = assembly.name;
    // clearMandalams();
    // getMandalamList();
    clearBooth();
    getBoothList();
    notifyListeners();
  }

  clearAssembly() {
    selectedAssemblyName = defaultAssembly;
    selectedAssembly = null;
    notifyListeners();
  }

  clearBlocks() {
    selectedBlock = null;
    blocksList = null;
    blockListDropDown = null;
    notifyListeners();
  }

  clearMandalams() {
    selectedMandalam = null;
    mandalamList = null;
    mandalamListDropDown = null;
    notifyListeners();
  }

  clearBooth() {
    selectedBooth = null;
    boothsList = null;
    boothListDropDown = null;
  }

  changeIdProof(String val) {
    selectedIdProof = val;
    notifyListeners();
  }

  saveVideo(File result) async {
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
    print("-------------");
    print(pickedVideoFile!.path);
    print(pickedVideoFilePath);
    showVideoFile = true;
    notifyListeners();
  }

  getNominationAmount(
    BuildContext context,
  ) async {
    if (!validateForm(context)) {
      return false;
    }
    showNetworkLoadingDialog(context, willPopScope: false);
    var testJsonData = '''[{
       "V":"${AppConstants.nominationVersion}",
       "ORG":"${AppConstants.orgName}",
       "CHANNEL":"${AppConstants.channel}", 
       "DEVICE_ID":"${await getDeviceIdentifier()}",
       "LEVEL":"$selectedCandidateLevel",
       "GENDER":"${selectedGender ?? ''}",
       "CATEGORY":"${selectedCategory ?? ''}",
       "BPL":"${bplStatusVal == 1 ? "Y" : "N"}"
      }]''';
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.nominationAmount, jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();

        /// loading pop
        amountTobePayed = responseDecoded['response']['AMOUNT'].toString();
        orderId = responseDecoded['response']['ORDER_ID'].toString();
        print("amount...............................");
        print(amountTobePayed);
        print(orderId);

        final result = await nominationNSUIPaymentConfirmationBottomSheetPhase2(
            selectedCandidateLevelName,
            responseDecoded['response']['AMOUNT'].toString(),
            context);
        if (result != null && result) {
          showNetworkLoadingDialog(context, willPopScope: false);

          /// Phase 2 collects no documents, so there is nothing to upload —
          /// running the Phase 1 uploader here would post null file paths.
          if (!kPhase2SimplifiedForm && !await s3uploadAllMemberImages()) {
            Navigator.of(context).pop();
            return;
          }
          Navigator.of(context).pop();
          syncNomination(context);
        }
      } else {
        Navigator.of(context).pop();

        /// pop loading
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
  }

  checkIsFirstTime() async {
    final result = await LocalStorageServices().getInitNominationStatus();
    if (result == "1") {
      isFirstTimeNomination = false;
      notifyListeners();
    }
  }

  toggleIsFirstTime() async {
    isFirstTimeNomination = false;
    notifyListeners();
    await LocalStorageServices().setInitNominationStatus("1");
  }

  getNominationStatus(BuildContext context) async {
    loadingInitData = true;

    /// Phase 2 has its own status endpoint (getNominationStatusPhase2.php).
    ApiResponse apiResponse =
        await NominationRepo(dioClient: sl()).getNominationStatusPhase2();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      Log.printILog('getNominationStatusPhase2 -> $responseDecoded');
      final responseBody = responseDecoded["response"];

      /// Three recognised shapes:
      ///   NEW_NOMINATION                        -> fresh application, show form
      ///   EXISTING_NOMINATION + UNPAID          -> post locked, Pay Now
      ///   EXISTING_NOMINATION + PAID            -> details only
      /// Anything else stops here and shows whatever the server said.
      if (responseDecoded['status'] == "SUCCESS" && responseBody is Map) {
        final nomStatus = "${responseBody["NOMINATION_STATUS"] ?? ''}";

        /// Take NOMINATION_ID / MEMBER_ID straight from this response and
        /// reuse them for the submit and the payment — Phase 2 must never
        /// mint its own member id.
        final data = (responseBody["DATA"] is List &&
                (responseBody["DATA"] as List).isNotEmpty)
            ? responseBody["DATA"][0]
            : null;
        /// PAYMENT_STATUS is read from the OUTER response object (sibling of
        /// NOMINATION_STATUS) — the copy inside DATA[0] can disagree with it
        /// and is not authoritative.
        phase2PaymentStatus = "${responseBody["PAYMENT_STATUS"] ?? ''}";

        if (data != null) {
          phase2NominationId = "${data["NOMINATION_ID"] ?? ''}";
          phase2MemberId = "${data["MEMBER_ID"] ?? ''}";
          nominationData = NominationMember.fromJson(data).copyWith(
              id: phase2NominationId,
              memberId: phase2MemberId,
              paymentStatus: phase2PaymentStatus);
          context
              .read<ViewNominationVmPhase2>()
              .setNominationData(nominationData);
        }

        if (nomStatus == "NEW_NOMINATION") {
          nominationStatus = NominationStatusPhase2.NOT_NOMINATED;
          statusErrorMessage = "";
          loadingInitData = false;
          showError = false;
          notifyListeners();
          return true;
        }

        if (nomStatus == "EXISTING_NOMINATION") {
          /// The post is already fixed server-side — lock the dropdown to it.
          selectedCandidateLevel = "${data?["LEVEL"] ?? ''}";
          selectedCandidateLevelName = "${data?["CONTESTING_FOR"] ?? ''}";
          /// Trimmed exact match: an unrecognised value falls through to
          /// UNPAID and would offer Pay Now on an already-paid nomination, so
          /// don't let stray whitespace decide that.
          nominationStatus = phase2PaymentStatus.trim().toUpperCase() == "PAID"
              ? NominationStatusPhase2.PAID
              : NominationStatusPhase2.UNPAID;
          statusErrorMessage = "";
          loadingInitData = false;
          showError = false;
          notifyListeners();
          return true;
        }
      }

      /// Not eligible — surface the server's own wording.
      statusErrorMessage = responseBody is Map
          ? '${responseBody["MESSAGE"] ?? responseBody["NOMINATION_STATUS"] ?? "You are not eligible to file a nomination."}'
          : '${responseBody ?? "You are not eligible to file a nomination."}';
      loadingInitData = false;
      showError = true;
      notifyListeners();
      CustomSnackBar.showErrorDialog(statusErrorMessage,
          title: 'Nomination not available');
      return false;
    } else {
      statusErrorMessage = apiResponse.error?.message?.toString() ??
          'Could not fetch nomination status. Please try again.';
      loadingInitData = false;
      showError = true;
      notifyListeners();
      CustomSnackBar.showErrorDialog(statusErrorMessage,
          title: 'Nomination not available');
      return false;
    }
  }

  s3uploadAllMemberImages() async {
    bool? returnValue;
    print("start uploading the document");
    final uploadResult = await Future.wait(
      [
        if ((isSelectedFeeWaiverCategory || selectedCategory == 'O') &&
            pickedCategoryFilePath != null)
          uploadDocument(
              pickedCategoryFilePath,
              "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                  nominationBatchNumber +
                  "01",
              "${nominationBatchNumber + "01"}_CATEGORY_DOC.jpg"),
        uploadDocument(
            pickedProfileFilePath,
            "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                nominationBatchNumber +
                "01",
            "${nominationBatchNumber + "01"}_P.jpg"),
        uploadDocument(
            pickedIdProofPath,
            "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                nominationBatchNumber +
                "01",
            "${nominationBatchNumber + "01"}_ID_FRONT_DOC.jpg"),
        uploadDocument(
            pickedIDBackFilePath,
            "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                nominationBatchNumber +
                "01",
            "${nominationBatchNumber + "01"}_ID_BACK_DOC.jpg"),
        uploadDocument(
            pickedStudentIDFilePath,
            "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                nominationBatchNumber +
                "01",
            "${nominationBatchNumber + "01"}_STUDENT_ID_DOC.jpg"),
        uploadDocument(
            pickedStudentIDBackFilePath,
            "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                nominationBatchNumber +
                "01",
            "${nominationBatchNumber + "01"}_STUDENT_ID_BACK_DOC.jpg"),
        if (pendingCaseValue)
          uploadDocument(
              pickedCaseFilePath,
              "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                  nominationBatchNumber +
                  "01",
              "${nominationBatchNumber + "01"}_CASE_FILE_DOC.jpg"),
        if (bplStatusVal == 1)
          uploadDocument(
              pickedBPLFilePath,
              "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                  nominationBatchNumber +
                  "01",
              "${nominationBatchNumber + "01"}_BPL_CARD_DOC.jpg"),
        uploadDocument(
            pickedVideoFilePath,
            "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                nominationBatchNumber +
                "01",
            "${nominationBatchNumber + "01"}.mp4"),
        uploadDocument(
            pickedDobFilePath,
            "NSUI/MEMBERSHIP/${await LocalStorageServices().getSTCode()}/OM/" +
                nominationBatchNumber +
                "01",
            "${nominationBatchNumber + "01"}_DOB.jpg"),
      ],
    );

    if (uploadResult.contains(false)) {
      returnValue = false;
    } else if (returnValue == null || returnValue) {
      returnValue = true;
    }

    return returnValue;
  }

  Future<bool> uploadDocument(
      String? filePath, String destinationDirectory, String fileName) async {
    if (filePath == null) {
      return false;
    }
    String? result = await AwsUploadServices().uploadFile(
        file: File(filePath),
        destDir: destinationDirectory,
        filename: fileName);

    if (result is String)
      return true;
    else
      return false;
  }

  checkS3Upload(
    BuildContext context,
  ) async {
    var testJsonData = '''[{
    "V":"${AppConstants.membershipVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
    "MEMBER_ID":"${nominationBatchNumber + "01"}",
    "ST_CODE":"${await LocalStorageServices().getSTCode()}",
    "CHANNEL":"M"
    }]''';
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: Urls.checkS3Upload, jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();

        /// pop loading
        ///
        Navigator.of(context).pop();
        await syncNomination(context);
      } else {
        Navigator.of(context).pop();

        /// pop loading
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
    }
  }

  String getPOSTvalue() {
    String val = candidateLevelList
        .firstWhere((element) => element.value == selectedCandidateLevel)
        .name
        .split('/')
        .first;

    /// Phase 2 sends the level name verbatim as POST — "State President" /
    /// "District President".
    if (kPhase2SimplifiedForm) return val;
    if (val.toLowerCase().contains('university')) {
      return 'UNIVERSITY';
    } else if (val.toLowerCase().contains('college')) {
      return 'COLLEGE';
    } else {
      return val;
    }
  }

  syncNomination(
    BuildContext context,
  ) async {
    var nominationMap = kPhase2SimplifiedForm
        ? {
            "V": AppConstants.nominationVersion,
            "ORG": AppConstants.orgName,
            "CHANNEL": "M",
            "SESSION_ID": await LocalStorageServices().getSessionId(),
            "DEVICE_ID": await getDeviceIdentifier(),
            "USER_ID": await LocalStorageServices().getUserId(),
            "LATITUDE":
                "${sl<LocationProvider>().currentLocation?.latitude ?? ''}",
            "LONGITUDE":
                "${sl<LocationProvider>().currentLocation?.longitude ?? ''}",

            /// Level Of Candidate is the only thing the user picks; the state
            /// comes from their profile and MEMBER_ID from the status API.
            "MEMBER_ID": phase2MemberId ?? '',
            "NOMINATION_ID": phase2NominationId ?? '',
            "POST": getPOSTvalue(),
            "STATE_CODE": await LocalStorageServices().getSTCode(),
            "LEVEL": "$selectedCandidateLevel",
          }
        : {
      "V": AppConstants.nominationVersion,
      "ORG": "NSUI",
      "DEVICE_ID": await getDeviceIdentifier(),
      "FIRST_NAME": usernameController.text,
      "LAST_NAME": lastNameController.text,
      "MOBILE": mobileController.text,
      "EMAIL": emailController.text,
      "SOCIAL": socialMediaController.text,
      "STATE_CODE": await LocalStorageServices().getSTCode(),
      "DISTRICT_CODE": selectedDistrict!.districtCode,
      "ASSEMBLY_CODE": selectedAssembly?.assemblyCode ?? "",
      "MANDALAM_CODE": selectedBooth?.boothCode ?? "", //selectedMandalam ?? "",
      "UNIVERSITY": selectedAssembly?.assemblyCode ?? "",
      "COLLEGE": selectedBooth?.boothName ?? "",
      "MEMBER_ID": nominationBatchNumber + "01",
      "LEVEL": "$selectedCandidateLevel",
      "ASSEMBLY_NAME": selectedAssembly?.name ?? "",
      "DISTRICT_NAME": selectedDistrict!.name,
      "DATE_OF_BIRTH": "$selectedDate",
      "CATEGORY_CODE": "$selectedCategory",
      "SEX_CODE": "$selectedGender",
      // "MANDALAM_NAME": mandalamList
      //         ?.firstWhere(
      //             (element) => element.mandalamCode == selectedMandalam)
      //         .mandalamName ??
      //     "",
      "BLOOD_GROUP": selectedBloodGroup ?? "",
      "BLOCK_CODE": selectedBlock?.blockCode ?? "",
      "BLOCK_NAME": selectedBlock?.blockName ?? "",
      "BOOTH_CODE": selectedBooth?.boothCode ?? "",
      "CATEGORY": "$selectedCategory",
      "POST": getPOSTvalue(),
      "BPL_CARD": bplStatusVal == 0 ? "No" : "Yes",
      "BPL_CARD_DOC":
          bplStatusVal == 1 ? "${nominationBatchNumber}_BPL_CARD_DOC.jpg" : "",
      "CONVICT": pendingCaseValue ? "Yes" : "NO",
      "CASE_PENDING": pendingCaseValue ? "Yes" : "NO",
      "CASE_DOC":
          pendingCaseValue ? "${nominationBatchNumber}_CASE_DOC.jpg" : "",
      "PREVIOUS_OB": "No",
      "PYC_PRESIDENT": "No",
      "OLD_BARCODE": "",
      "DECLARATION_STATUS": "${declarationStatus ? 1 : 0}",
      "ID_TYPE": selectedIdType,
      "STUDENT_ID_DOC": "${nominationBatchNumber}_STUDENT_D.jpg",
      "STUDENT_ID_DOC_BACK": "${nominationBatchNumber}_STUDENT_D_BACK.jpg",

      "ID_DOC": "${nominationBatchNumber}_D.jpg",
      "ID_DOC_BACK": "${nominationBatchNumber}_D_BACK.jpg",
      "CATEGORY_DOC": isCategoryNeedDocuments
          ? "${nominationBatchNumber}_CATEGORY_DOC.jpg"
          : "",
      "CHANNEL": "M",
      "ID_VALUE": idCardNumberController.text,
      "STUDENT_ID_VALUE": studentidNumberController.text,
      "EDUCATION": "$selectedEducation",
      "COURSE": courseController.text,
      "AMOUNT": "$amountTobePayed"
    };
    showNetworkLoadingDialog(context, willPopScope: false);
    String testJsonData = '''[${jsonEncode(nominationMap)}]''';
    String data = base64.encode(utf8.encode(testJsonData));
    log(data);
    log(nominationMap.toString());

    // return;
    ApiResponse apiResponse = await apiConfig.postData(
        endpointUrl: kPhase2SimplifiedForm
            ? Urls.syncNominationPhase2
            : Urls.syncNomination,
        jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        /// Phase 1 returns response as a map carrying NOMINATION_ID; Phase 2
        /// returns a plain string ("Nomination added successfully"), so
        /// indexing it threw before we ever reached the payment page. Phase 2
        /// carries the ids from the status API instead.
        final responseBody = responseDecoded["response"];
        Navigator.of(context).pop();

        /// pop loading
        if (kPhase2SimplifiedForm) {
          /// The submit response carries no ids, and on a NEW_NOMINATION the
          /// status API had none to give us yet. Re-read it now that the
          /// nomination exists so the payment goes out with the server's real
          /// NOMINATION_ID / MEMBER_ID rather than blanks.
          await getNominationStatus(context);
          nominationId = phase2NominationId;
        } else {
          nominationId =
              responseBody is Map ? "${responseBody["NOMINATION_ID"]}" : null;
        }
        nominationData = NominationMember(
            id: nominationId,
            memberId: kPhase2SimplifiedForm
                ? phase2MemberId
                : nominationBatchNumber + "01",
            amount: amountTobePayed);

        /// Same payment path as Pay Now — validates on return and stays on
        /// this page whatever the outcome.
        makeNominationPayment(
            context, orderId!, amountTobePayed!, nominationData!);
      } else {
        Navigator.of(context).pop();

        /// pop loading
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();

      /// pop loading net work erros
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
    }
  }

  makeNominationPayment(BuildContext context, String orderId, String amount,
      NominationMember member) async {
    showNetworkLoadingDialog(context, willPopScope: false);
    if (!await addNominationPayment(context, orderId, amount, member)) {
      return false;
    }

    final result = await toPage(
        context,
        ChangeNotifierProvider(
          create: (context) => PaymentScreenVM(),
          child: PaymentScreen(
            transactionId: orderId,
            source: "N",
            amount: kPhase2TestPaymentAmountOfOne ? "1" : amount,
          ),
        ));

    /// Always verify with the server, even when the user quit the gateway
    /// without a TransactionStatus — otherwise the loading dialog was left
    /// open and the payment was never checked at all.
    ApiResponse apiResponse =
        await sl<PaymentRepo>().checkPaymentStatusNomination(member, orderId);

    Navigator.of(context).pop();

    /// close network loading dialog

    String paymentState = '';
    String? transportError;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      Log.printILog('checkNominationPayment -> $responseDecoded');

      /// `status` is only the API envelope — the real payment state is the
      /// `response` value ("PAID" / "UNPAID"). Treating SUCCESS as "paid" was
      /// showing the success sheet for an unpaid nomination.
      paymentState = responseDecoded['status'] == "SUCCESS"
          ? "${responseDecoded['response']}".toUpperCase()
          : '';
      if (responseDecoded['status'] != "SUCCESS") {
        transportError = "${responseDecoded['response'] ?? ''}";
      }
    } else {
      transportError = apiResponse.error?.message?.toString() ??
          'Could not reach the server to confirm your payment.';
    }

    /// Stay on the Phase 2 page either way and refresh from the status API so
    /// the screen reflects reality (PAID -> read-only, UNPAID -> Pay Now).
    if (paymentState == "PAID") {
      await nominationNSUISuccessBottomSheetPhase2();
      await getNominationStatus(context);
    } else {
      await getNominationStatus(context);
      CustomSnackBar.showErrorDialog(
          transportError != null && transportError.isNotEmpty
              ? transportError
              : 'Your payment was not completed${paymentState.isEmpty ? '' : ' (status: $paymentState)'}. You can tap Pay Now to try again.',
          title: 'Payment incomplete');
    }
  }

  addNominationPayment(BuildContext context, String orderId, String amount,
      NominationMember member) async {
    ApiResponse apiResponse =
        await sl<PaymentRepo>().addPaymentNomination(member, orderId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        return true;
      } else {
        /// payment failed status display
        Navigator.of(context).pop();
        CustomSnackBar.showErrorDialog(
            '${responseDecoded["response"] ?? "Payment could not be initiated."}',
            title: 'Payment not initiated');
        return false;
      }
    }

    /// Non-200 / transport failure — without this the method returned null and
    /// `!await addNominationPayment(...)` threw instead of reporting the error.
    Navigator.of(context).pop();
    CustomSnackBar.showErrorDialog(
        apiResponse.error?.message?.toString() ??
            'Could not reach the payment service. Please try again.',
        title: 'Payment not initiated');
    return false;
  }

  /// Phase 2 collects only Level Of Candidate, one of State/District, and the
  /// declaration — every other field is already known server-side, so none of
  /// the Phase 1 checks below apply.
  bool validatePhase2Form(BuildContext context) {
    bool validatedSuccess = true;
    if (selectedCandidateLevel == null) {
      showCustomSnackBar("Kindly select the Level Of Candidate", context);
      validatedSuccess = false;
    }
    if (!declarationStatus) {
      showCustomSnackBar("Kindly accept the declaration", context);
      validatedSuccess = false;
    }
    return validatedSuccess;
  }

  bool validateForm(BuildContext context) {
    if (kPhase2SimplifiedForm) return validatePhase2Form(context);
    bool validatedSuccess = true;

    if (selectedCategory == null) {
      showCustomSnackBar("Kindly a select a category", context);
      validatedSuccess = false;
    } else {
      if (_docRequiredCategories.contains(selectedCategory)) {
        isSelectedFeeWaiverCategory = true;
        if (pickedCategoryFilePath == null) {
          showCustomSnackBar("Upload Category document", context);
          validatedSuccess = false;
        }
      }
    }
    // if (selectedEducation == null) {
    //   showCustomSnackBar("Kindly a select Educational Qualification", context);
    //   validatedSuccess = false;
    // }
    if (courseController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill Course", context);
      validatedSuccess = false;
    }
    if (usernameController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill First name", context);
      validatedSuccess = false;
    }

    if (emailController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill email", context);
      validatedSuccess = false;
    }

    if (socialMediaController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill social media handles", context);
      validatedSuccess = false;
    }
    // if (lastNameController.text.trim().isEmpty) {
    //   showCustomSnackBar("Kindly fill Last name", context);
    //   validatedSuccess = false;
    // }
    // if (fatherNameController.text.trim().isEmpty) {
    //   showCustomSnackBar("Kindly fill Relative name", context);
    //   validatedSuccess = false;
    // }
    if (idCardNumberController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill Id Number", context);
      validatedSuccess = false;
    }
    if (studentidNumberController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill  Student Id Number", context);
      validatedSuccess = false;
    }

    if (selectedDistrict == null) {
      showCustomSnackBar("Kindly choose a district", context);
      validatedSuccess = false;
    }
    if (selectedAssembly == null) {
      showCustomSnackBar("Kindly choose a University/College", context);
      validatedSuccess = false;
    }

    // College selection is hidden (merged into University/College) — no longer
    // a required field.
    // if (selectedBooth == null) {
    //   showCustomSnackBar("Kindly choose a College", context);
    //   validatedSuccess = false;
    // }
    // if ((isBlockModel) && (selectedBlock == null)) {
    //   showCustomSnackBar("Kindly choose a Block", context);
    //   validatedSuccess = false;
    // }
    // if ((mandalamEnabled) && (selectedMandalam == null)) {
    //   showCustomSnackBar("Kindly choose a Mandalam", context);
    //   validatedSuccess = false;
    // }
    if (selectedDate == null) {
      showCustomSnackBar("Kindly select Date of Birth", context);
      validatedSuccess = false;
    } else if (!DobRules.isValid(eventDate)) {
      showCustomSnackBar(DobRules.errorText(eventDate)!, context);
      validatedSuccess = false;
    }
    if (selectedGender == null) {
      showCustomSnackBar("Kindly choose a Gender", context);
      validatedSuccess = false;
    }
    if (selectedBloodGroup == null) {
      showCustomSnackBar("Kindly choose a Blood Group", context);
      validatedSuccess = false;
    }
    // if (selectedBooth == null) {
    //   showCustomSnackBar("Kindly choose a Booth", context);
    //   validatedSuccess = false;
    // }

    (pickedProfileFilePath == null ||
            pickedIdProofPath == null ||
            pickedIDBackFilePath == null ||
            pickedVideoFilePath == null ||
            pickedDobFilePath == null ||
            pickedStudentIDFilePath == null ||
            pickedStudentIDBackFilePath == null)
        ? showCustomSnackBar("Upload all documents", context)
        : null;
    if (!(pickedProfileFilePath != null &&
        pickedIdProofPath != null &&
        pickedIDBackFilePath != null &&
        pickedVideoFilePath != null &&
        pickedDobFilePath != null &&
        pickedStudentIdFile != null &&
        pickedStudentIdBackFile != null)) {
      validatedSuccess = false;
    }

    if (bplStatusVal == 1 && pickedBPLFilePath == null) {
      validatedSuccess = false;
      showCustomSnackBar("Upload BPL document", context);
    }
    if (pendingCaseValue && pickedCaseFilePath == null) {
      validatedSuccess = false;
      showCustomSnackBar("Upload pending case document", context);
    }

    if (!declarationStatus) {
      validatedSuccess = false;
      showCustomSnackBar("Kindly mark declaration as true", context);
    }

    return validatedSuccess;
  }

  changeDobProofType(String value) {
    selectedDobProof = value;
    notifyListeners();
  }

  void changeMandalam(value) {
    selectedMandalam = value;
    notifyListeners();
  }
}
