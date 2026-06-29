import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/service/auth_service.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/constant_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/data_model/login_model.dart';
import 'package:iyc/model/data_model/otp_model.dart';
import 'package:iyc/model/data_model/registrer_model.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

class RegisterNSUIController extends GetxController {
  final authService = Get.find<AuthService>();
  final mobile = Get.arguments;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController referralNumberController = TextEditingController();
  TextEditingController subcasteController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController dobvalueController = TextEditingController();
  TextEditingController voterController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  String? selectedGender;
  States? selectedState;
  Districts? selectedDistrict;
  Assembly? selectedAssembly;
  String? pickedAMFilePath;
  File? pickedAMFile;
  bool showAMImage = false;
  RegisterModel? registerModel;
  // Category? selectedCategory;

  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>? assemblyList;
  List<DropdownItem> genders = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
    DropdownItem("Others", "O")
  ];
  List<String> registrationFiled = [
    'Youth Congress',
    'NSUI',
    'Shakti SuperShe',
    'Indira Fellowship',
    'Volunteer/ Fellow'
  ];
  List<int> selectedRegistrationField = [];
  void onClickRegistrationFiledCheckedBox(int index) {
    if (selectedRegistrationField.contains(index)) {
      selectedRegistrationField.remove(index);
    } else {
      selectedRegistrationField.add(index);
    }
    update();
  }

  bool reSendOtp = false;
  int start = 60;
  Timer? timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) {
      if (start < 1) {
        timer.cancel();
        reSendOtp = true;
      } else {
        start = start - 1;
      }
      update();
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await getStatesList();
    phoneNumberController = TextEditingController(text: mobile ?? '');
    update();
  }

  @override
  void onClose() {
    super.onClose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    dobvalueController.dispose();
    voterController.dispose();
  }

  void onClickReSendOtp() async {
    if (reSendOtp) {
      await authService.getResendOtpLogin(
          loginModel: LoginModel(mobile: phoneNumberController.text));
      start = 60;
      reSendOtp = false;
      update();
      startTimer();
    } else {
      CustomSnackBar.showWarningSnackBar('Wait 60 sec to resend OTP');
    }
  }

  void verifyLoginOtp(String otp) async {
    if (otp.length == 6) {
      var otpModel = OTPModel(mobile: registerModel!.mobile, otp: otp);
      // await authService.register(registerData: registerModel!);
      await authService
          .verifyOtpLogin(otpModel: otpModel, userImagePath: pickedAMFilePath)
          .then((value) async {
        if (value) {
          RoutesManagement.goToHomeScreenNSUI();
        }
      });
    }
  }

  void onTapRegister() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    var temp = '';
    for (var i in selectedRegistrationField) {
      temp += '${registrationFiled[i]},';
    }
    if (pickedAMFilePath == null) {
      CustomSnackBar.showWarningSnackBar("Upload Profile Photo");
      return;
    }
    if (Platform.isAndroid) {
      if (selectedGender == null) {
        CustomSnackBar.showWarningSnackBar("Select Gender");
        return;
      }
    }

    if (selectedState == null) {
      CustomSnackBar.showWarningSnackBar("Choose State");
      return;
    }
    // if (selectedDistrict == null) {
    //   CustomSnackBar.showWarningSnackBar("Choose District");
    //   return;
    // }
    // if (selectedAssembly == null) {
    //   CustomSnackBar.showWarningSnackBar("Choose Assembly");
    //   return;
    // }
    registerModel = RegisterModel(
        name: fullNameController.text,
        mobile: phoneNumberController.text,
        email: emailController.text,
        dob: dobvalueController.text,
        stateCode: selectedState!.stateCode,
        amImagePath: pickedAMFilePath ?? '',
        districtCode:
            selectedDistrict == null ? '' : selectedDistrict!.districtCode,
        assemblyCode:
            selectedAssembly == null ? '' : selectedAssembly!.assemblyCode,
        caste: selectedCategory ?? '',
        subCaste: subcasteController.text);
    start = 60;
    reSendOtp = false;
    update();
    startTimer();
    await authService.register(
        registerData: registerModel!,
        address: addressController.text,
        pincode: pincodeController.text,
        tag: temp,
        referralMobileNo: referralNumberController.text);
    RoutesManagement.goToRegisterOtpScreenNSUI();
  }

  void onChangeDate(DateTime timeData) {
    var selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    dobvalueController.text = selectedDate;
    update();
  }

  void onChangeGender(String value) {
    selectedGender = value;
    update();
  }

  void onChangeState(States value) async {
    selectedState = value;
    selectedDistrict = null;

    selectedAssembly = null;
    await getDistrictList();
    update();
  }

  void onChangeAssembly(Assembly value) async {
    selectedAssembly = value;
    update();
  }

  void onChangeDistrict(Districts value) async {
    selectedDistrict = value;
    selectedAssembly = null;
    await getAssemblyList();
    update();
  }

  // List<Category>? categoryList;
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

  Future<dynamic> loadJsonData() async {
    final String jsonString =
        await rootBundle.loadString('assets/TBL_MASTER_STATE_IYC.json');
    final data = jsonDecode(jsonString);

    return data;
  }

  Future<void> getStatesList() async {
    stateList = [];
    List<dynamic> data = await loadJsonData();
    for (var i in data) {
      stateList!.add(States(
          id: i['ID'],
          name: i['STATE_NAME'],
          stateCode: i["MASTER_STATE_CODE"],
          isEnabled: i["IS_ENABLED"]));
    }
    stateList = await DbServices.db.getAllStates(true);
    // var result = await getStateBallots();
    // if (result == null) {
    //   stateList = [];
    // } else {
    //   stateList = [];
    //   for (var i in result) {
    //     stateList!.add(States(
    //         id: 0,
    //         name: i['state_name'],
    //         stateCode: i['state_code'],
    //         isEnabled: ''));
    //   }
    // }

    update();
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

  changeCategory(String val) {
    selectedCategory = val;
    update();
  }

  Future<void> getDistrictList() async {
    ProgressDialogUtils.showProgressDialog();
    districtList = await DbServices.db.getDistricts(selectedState!);
    ProgressDialogUtils.hideProgressDialog();
    update();
  }

  Future<void> getAssemblyList() async {
    ProgressDialogUtils.showProgressDialog();
    assemblyList = await DbServices.db.getAssembly(selectedDistrict!);
    ProgressDialogUtils.hideProgressDialog();
    update();
  }

  Future<void> pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType, BuildContext context) async {
    Log.printILog('Starting taking profile photo');
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
      print(p.basename(result.path));
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);

      File _image = newImage;

      switch (documentType) {
        case DocumentType.amImage:
          pickedAMFile = _image;
          pickedAMFilePath = pickedAMFile!.path;
          showAMImage = true;
          Log.printILog('Profile photo path is $pickedAMFilePath');
          update();
          break;
        case DocumentType.idFront:
          break;
        case DocumentType.idBack:
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
      print("file picked not");
      return null;
    }
  }
}
