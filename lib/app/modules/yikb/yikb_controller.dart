import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/services/aws_upload_services.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/screens/ui/payment/payment_screen.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/payment/payment_screen_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../model/offline_model/database/states.dart';
import 'dart:convert';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/model/api_model/base/api_response.dart';

class YIKBController extends GetxController {
  bool isEnglish = true;

  HomeController homeController = Get.find<HomeController>();
  ProfileController profile = Get.find<ProfileController>();

  void onChangeLanguage() {
    isEnglish = !isEnglish;
    initDropDown();
    update();
  }

  @override
  void onInit() async {
    initDropDown();
    initPreFilledData();
    // await getStatesList();
    super.onInit();
  }

  void initDropDown() {

    knowAboutYIKB = [
      DropdownItem(isEnglish ? "Social Media" : "Social Media", "Social Media"),
      DropdownItem(isEnglish ? "IYC Cadre" : "IYC Cadre ", "IYC Cadre "),
      DropdownItem(isEnglish ? "IYC Website" : "IYC Website", "IYC Website"),
      DropdownItem(isEnglish ? "Friends/ Networks" : "Friends/ Networks", "Friends/ Networks"),

    ];
    gender = [
      DropdownItem(isEnglish ? "Male" : "पुरुष", "Male"),
      DropdownItem(isEnglish ? "Female" : "महिला", "Female"),
      DropdownItem(isEnglish ? "Other" : "अन्य", "Other"),
    ];
    categories = [
      DropdownItem(isEnglish ? "General" : "सामान्य", "General"),
      DropdownItem(isEnglish ? "OBC" : "OBC", "OBC"),
      DropdownItem(isEnglish ? "SC" : "SC", "SC"),
      DropdownItem(isEnglish ? "ST" : "ST", "ST"),
      DropdownItem(isEnglish ? "Minority" : "अल्पसंख्यक", "Minority"),
      DropdownItem(isEnglish ? "Others" : "Others", "Others"),
    ];
    highestQualifications = [
      DropdownItem(isEnglish ? "High School" : "हाई स्कूल", "High School"),
      DropdownItem(isEnglish ? "Graduate" : "स्नातक", "Graduate"),
      DropdownItem(isEnglish ? "Postgraduate" : "स्नातकोत्तर", "Postgraduate"),
      DropdownItem(
          isEnglish ? "Others (Please specify)" : "अन्य (कृपया विशिष्ट करें)",
          "Others"),
    ];
    professions = [
      DropdownItem(isEnglish ? "Student" : "छात्र", "Student"),
      DropdownItem(isEnglish ? "Working Professional" : "कामकाजी पेशेवर",
          "Working Professional"),
      DropdownItem(isEnglish ? "Entrepreneur" : "उद्यमी", "Entrepreneur"),
      DropdownItem(
          isEnglish ? "Other (Please specify)" : "अन्य (कृपया विशिष्ट करें)",
          "Others"),
    ];
    congressAffiliations = [
      DropdownItem(isEnglish ? "Indian Youth Congress" : "भारतीय युवा कांग्रेस",
          "Indian Youth Congress"),
      DropdownItem(isEnglish ? "NSUI" : "एनएसयूआई", "NSUI"),
      DropdownItem(
          isEnglish ? "Mahila Congress" : "महिला कांग्रेस", "Mahila Congress"),
      DropdownItem(isEnglish ? "Sevadal" : "सेवा दल", "Sevadal"),
      DropdownItem(isEnglish ? "Others (Please specify)" : "अन्य", "Others"),
    ];
    preferredLanguages = [
      DropdownItem(isEnglish ? "Hindi" : "हिंदी", "Hindi"),
      DropdownItem(isEnglish ? "English" : "अंग्रेजी", "English"),
      DropdownItem(
          isEnglish
              ? "Regional (Please specify)"
              : "क्षेत्रीय (कृपया विशिष्ट करें)",
          "Regional"),
    ];
  }

  void initPreFilledData() async {
    var userData = profile.userDetail!;
    fullNameController.text = userData.name;
    selectedDate = userData.name;
    dobController.text = userData.dateOfBirth;
    await getStatesList();
    selectedState = stateList
        .firstWhere((element) => element.stateCode == userData.stateCode);
    getAssemblyList();
    Log.printELog(userData.assemblyCode);
    phoneController.text = userData.mobile;
    update();
  }

  bool otpSend = false;
  bool otpVerified = false;
  bool declaration = false;
  List<DropdownItem> knowAboutYIKB = [];
  List<DropdownItem> gender = [];
  List<DropdownItem> categories = [];
  List<DropdownItem> highestQualifications = [];
  List<DropdownItem> professions = [];
  List<DropdownItem> congressAffiliations = [];
  List<DropdownItem> preferredLanguages = [];
  List<States> stateList = [];
  List<DropdownItem> assemblyDropdownItems = [];

  GlobalKey<FormState> personalDetailFormKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  String? selectedDate;
  String? selectedGender;
  String? selectedCategory;
  States? selectedState;
  String? selectedAssembly;
  String? selectedQualification;
  String? selectedProfession;
  String? selectedCongressAffiliations;
  String? selectedLanguage;
  String? selectedKnowAboutYIKB;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController referNameController = TextEditingController();
  TextEditingController referPhoneController = TextEditingController();

  TextEditingController educationController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController affiliationController = TextEditingController();
  TextEditingController preferredLanguageController = TextEditingController();

  Future<void> getStatesList() async {
    stateList = await DbServices.db.getAllStates(true);
    update();
  }

  Future<void> getAssemblyList() async {
    assemblyDropdownItems.clear();
    var assemblyList =
        await DbServices.db.getAllAssemblyByState(selectedState?.stateCode);
    for (var i in assemblyList) {
      assemblyDropdownItems.add(DropdownItem(i.name, i.assemblyCode));
    }
    update();
  }

  void onChangeDeclaration() {
    declaration = !declaration;
    update();
  }

  void onChangeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
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

  void onChangeState(States value) {
    selectedState = value;
    update();
    getAssemblyList();
  }

  void onChangeAssembly(String value) {
    selectedAssembly = value;
    update();
  }

  void onChangeQualification(String value) {
    selectedQualification = value;
    update();
  }

  void onChangeProfession(String value) {
    selectedProfession = value;
    update();
  }

  void onChangeAffiliations(String value) {
    selectedCongressAffiliations = value;
    update();
  }

  void onChangeSelectedLanguage(String value) {
    selectedLanguage = value;
    update();
  }

  void onChangeKnowAboutYIKB(String value) {
    selectedKnowAboutYIKB = value;
    update();
  }

  // Maximum allowed video size (33 MB)
  static const int _maxVideoSizeBytes = 300 * 1024 * 1024;

  Future<bool> _checkVideoSize(File videoFile) async {
    try {
      int fileSize = await videoFile.length();
      Log.printILog(fileSize);
      if (fileSize > _maxVideoSizeBytes) {
        _showSizeLimitDialog(fileSize);
        return false;
      }

      return true;
    } catch (e) {
      // Handle any errors in checking file size
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error checking video size: $e')),
      );
      return false;
    }
  }

  void _showSizeLimitDialog(int actualSize) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Video Size Limit Exceeded'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Maximum allowed video size: 33 MB'),
              Text(
                  'Your video size: ${(actualSize / (1024 * 1024)).toStringAsFixed(2)} MB'),
              const SizedBox(height: 10),
              const Text(
                'Please select a smaller video.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? pickedFilePathValue;
  File? pickedFile;

  Future<void> pickVideo(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType) async {
    final result = await ImageServices().pickVideo(imageSource);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      // ProgressDialogUtils.showProgressIndicator();
      File image;
      image = File(result.path);
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);
      File _image = newImage;
      Log.printELog('filePath');
      switch (documentType) {
        case DocumentType.amImage:
          pickedFile = _image;
          pickedFilePathValue = pickedFile!.path;
          update();
          // showProfileImage = true;
          break;
        case DocumentType.idFront:
          break;
        case DocumentType.idBack:
          break;
        case DocumentType.category:
          break;
        case DocumentType.bpl:
          break;
        case DocumentType.caseFile:
          break;
        case DocumentType.amVideo:
          break;
        case DocumentType.dob:
          break;
        case DocumentType.barCouncilId:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      update();
    } else {
      return null;
    }
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

  Future getOtp(BuildContext context) async {
    otpSend = false;
    otpVerified = false;
    otpCodeController.clear();
    update();
    ProgressDialogUtils.showProgressIndicator();
    ApiResponse apiResponse =
        await YuvaBoothRepo().getOtp(phoneController.text);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
    }
  }

  Future verifyOtpForMember() async {
    if (!otpSend) {
      CustomSnackBar.showErrorSnackBar('kindly get OTP and then verify it');
      return false;
    }
    if (otpCodeController.text.isEmpty) {
      CustomSnackBar.showErrorSnackBar(
          'kindly fill verification code send to your mobile');
      return false;
    }
    ProgressDialogUtils.showProgressIndicator();

    ApiResponse apiResponse = await YuvaBoothRepo()
        .verifyOtp(phoneController.text, otpCodeController.text);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        Get.back();
        otpVerified = true;
        return true;
      } else {
        otpVerified = false;
        otpSend = false;
        update();
        Get.back();
        CustomSnackBar.showErrorSnackBar(responseDecoded["response"]);
        return false;
      }
    } else {
      otpVerified = false;
      otpSend = false;
      update();
      Get.back();
      CustomSnackBar.showErrorSnackBar(apiResponse.error.message.toString());
      return false;
    }
  }

  Future<bool> validatePersonalForm() async {
    if (!personalDetailFormKey.currentState!.validate()) {
      return false;
    }
    if (selectedDate == null) {
      CustomSnackBar.showErrorSnackBar('Select date of birth');
      return false;
    }
    if (selectedGender == null) {
      CustomSnackBar.showErrorSnackBar('Select gender');
      return false;
    }
    if (selectedCategory == null) {
      CustomSnackBar.showErrorSnackBar('Select category');
      return false;
    }
    if (selectedState == null) {
      CustomSnackBar.showErrorSnackBar('Select state');
      return false;
    }
    if (selectedAssembly == null) {
      CustomSnackBar.showErrorSnackBar('Select assembly');
      return false;
    }
    if (selectedQualification == null) {
      CustomSnackBar.showErrorSnackBar('Select Qualification');
      return false;
    }
    if (selectedProfession == null) {
      CustomSnackBar.showErrorSnackBar('Select Profession');
      return false;
    }
    if (selectedCongressAffiliations == null) {
      CustomSnackBar.showErrorSnackBar('Select Congress Affiliation');
      return false;
    }
    if (selectedLanguage == null) {
      CustomSnackBar.showErrorSnackBar('Select Preferred Language');
      return false;
    }
    if (otpCodeController.text.length != 6) {
      CustomSnackBar.showErrorSnackBar('Enter six digit OTP');
      return false;
    }
    if (pickedFilePathValue == null) {
      CustomSnackBar.showErrorSnackBar('Upload video');
      return false;
    }

    if (!declaration) {
      CustomSnackBar.showErrorSnackBar('Select declaration');
      return false;
    }
    bool sizeCheck = await _checkVideoSize(File(pickedFilePathValue!));
    if (!sizeCheck) {
      return false;
    }
    personalDetailFormKey.currentState!.save();
    return true;
  }

  void addYIKBForm() async {
    if (!await verifyOtpForMember()) {
      return;
    }
    ProgressDialogUtils.showProgressIndicator();
    Map<String, String> addPanchayatData = {
      "V": "1.1",
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE":
          "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE":
          "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
      "NAME": "${fullNameController.text}",
      "MOBILE": "${phoneController.text}",
      "STATE_CODE": "${selectedState!.stateCode}",
      "ASSEMBLY_CODE": "${selectedAssembly}",
      "GENDER": "${selectedGender}",
      "DOB": "${dobController.text}",
      "CATEGORY": "${selectedCategory}",
      "EMAIL": "${emailController.text}",
      "EDUCATION":
          "${selectedQualification == 'Others' ? educationController.text : selectedQualification}",
      "PROFESSION":
          "${selectedProfession == 'Others' ? professionController.text : selectedProfession}",
      "LANGUAGES":
          "${selectedLanguage == 'Regional' ? preferredLanguageController.text : selectedLanguage}",
      "AFFILIATION":
          "${selectedCongressAffiliations == 'Others' ? affiliationController.text : selectedCongressAffiliations}",
      "REFERRER_NAME": "${referNameController.text}",
      "HANDLE": "${selectedKnowAboutYIKB}",
      "REFERRER_MOBILE": "${referPhoneController.text}"
    };
    ApiResponse apiResponse =
        await CampaignRepo().addYIKBForM(addPanchayatData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        await uploadDocument(pickedFilePathValue, "YIKB",
            '${phoneController.text}.${pickedFilePathValue!.split('.').last}');
        ProgressDialogUtils.closeDialog();
        initYIKBPayment(responseDecoded['response']['YIKB_ID']);
      } else {
        Get.back();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    } else {
      Get.back();
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
  }

  void initYIKBPayment(String paymentId) async {
    ProgressDialogUtils.showProgressIndicator();
    Map<String, String> addPanchayatData = {
      "V": "1.1",
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE":
          "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE":
          "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
      "YIKB_ID": "${paymentId}"
    };
    ApiResponse apiResponse =
        await CampaignRepo().addYIKBPayment(addPanchayatData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        final result = await toPage(
            Get.context!,
            ChangeNotifierProvider(
              create: (context) => PaymentScreenVM(),
              child: PaymentScreen(
                transactionId: responseDecoded['response']['TRANSACTION_ID'],
                source: "Y",
                isYIKBPayment: false,
                amount: '${responseDecoded['response']['AMOUNT']}',
              ),
            ));
        if (result is TransactionStatus) {
          ApiResponse apiResponse =
              await CampaignRepo().addYIKBCheckPaymentStatus(addPanchayatData);
          if (apiResponse.response != null &&
              apiResponse.response!.statusCode == 200) {
            final responseDecoded = jsonDecode(
                utf8.decode(base64Decode(apiResponse.response!.data)));
            if (responseDecoded['status'] == "SUCCESS") {
              Get.back();
              await Alert(
                context: Get.context!,
                type: AlertType.success,
                onWillPopActive: true,
                title: "SUCCESS",
                desc: "Thank you. Your payment is successful",
                buttons: [
                  DialogButton(
                    child: Text(
                      "OKAY",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      Get.back();
                    },
                    width: 120,
                  )
                ],
              ).show();
            } else {
              await Alert(
                context: Get.context!,
                type: AlertType.error,
                title: "Payment Failed",
                onWillPopActive: true,
                desc:
                    " Thank you. Your request has been submitted. Payment is not Complete.",
                buttons: [
                  DialogButton(
                    child: Text(
                      "OKAY",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      Get.back();
                    },
                    width: 120,
                  )
                ],
              ).show();
            }
          }
        }
      } else {
        Get.back();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    } else {
      Get.back();
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
  }

  Future<void> checkYIKBPaymentStatus(String id) async {
    ProgressDialogUtils.showProgressIndicator();
    Map<String, String> addPanchayatData = {
      "V": "1.1",
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE":
          "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE":
          "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
      "YIKB_ID": "${id}"
    };
    ApiResponse apiResponse =
        await CampaignRepo().addYIKBCheckPaymentStatus(addPanchayatData);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        initYIKBPayment(responseDecoded['response']['YIKB_ID']);
      } else {
        Get.back();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    } else {
      Get.back();
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
  }

  void onSubmit() async {
    if (await validatePersonalForm()) {
      addYIKBForm();
    }
  }
}
