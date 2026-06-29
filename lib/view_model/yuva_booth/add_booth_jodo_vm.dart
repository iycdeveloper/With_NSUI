import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/helper/api_config.dart';
import 'package:iyc/helper/upload_document.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di_container.dart';
import '../../model/api_model/base/api_response.dart';
import '../../model/api_model/yuva_user/yuva_user.dart';
import '../../model/offline_model/database/assembly.dart';
import '../../model/offline_model/database/districts.dart';
import '../../model/offline_model/database/states.dart';
import '../../provider/global/location_provider.dart';
import '../../screens/widgets/button/upload_button.dart';
import '../../screens/widgets/custom_snack_bar.dart';

class AddBoothJodoVM extends ChangeNotifier {
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController idCardNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController refererController = TextEditingController();

  TextEditingController verificationCodeController = TextEditingController();

  final FocusNode mobileFocus = FocusNode();
  final FocusNode refererFocus = FocusNode();
  final FocusNode otpCodeFocus = FocusNode();

  List<String> selectedBooths = [];
  List<MultiSelectItem<String>> boothList = [];

  bool digitalYouthStatus = false;
  bool blaStatus = false;

  DateTime eventDate = DateTime.now();
  String? selectedDate;

  bool otpSend = false;
  bool otpVerified = false;

  changeSelectedValues(values) {
    selectedBooths = values;
    notifyListeners();
  }

  bool isFirstTimeNomination = true;
  bool showError = false;

  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>? assemblyList;

  String? selectedGender;
  List<DropdownItem> genders = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
  ];
  String? districtCode;
  Districts? selectedDistrict;
  States? selectedState;
  Assembly? selectedAssembly;
  String? selectedAssemblyName;

  File? pickedProfileFile;

  bool showProfileImage = false;

  String? pickedProfileFilePath;

  bool isCategoryNeedDocuments = false;
  bool isSelectedFeeWaiverCategory = false;
  List<Category>? categoryList;
  String? selectedCategory;

  String selectedIdType = "EI";
  bool declarationStatus = false;
  bool loading = false;
  bool loadingInitData = false;

  bool enableMediaEdit = false;
  bool disableFields = false;

  bool loadingPage = false;
  late YuvaUser currentYuvaUser;
  late List<YuvaUser> yuvaUsersList;

  String getAppbarName(String rolePriority) {
    switch (rolePriority) {
      case "1":
        return "Add Admin";
      case "2":
        return "Add Assembly in Charge";
      case "3":
        return "Add Zonal in Charge";
      case "4":
        return "Add Sector in Charge";
      case "5":
        return "Add Booth in Charge";

      default:
        return "";
    }
  }

  Future<List<MultiSelectItem<String>>> generateBoothList() async {
    final list = List.generate(
        500,
        (index) => MultiSelectItem<String>(
            (index + 1).toString(), (index + 1).toString()));
    return list;
  }

  initAddYuvaUser(YuvaUser yuvaUser, List<YuvaUser> yuvaUserList) async {
    loadingPage = true;
    currentYuvaUser = yuvaUser;
    yuvaUsersList = yuvaUserList;
    await Future.delayed(Duration.zero);
    categoryList = await DbServices.db.getAllCategory();
    await getAssemblyList();
    boothList = (currentYuvaUser.boothsAssigned?.isEmpty ??
            true) // let generate default 500 booths
        ? await generateBoothList()
        : List.generate(
            currentYuvaUser.boothsAssigned!.split(",").length,
            (index) => MultiSelectItem<String>(
                currentYuvaUser.boothsAssigned!.split(",")[index],
                currentYuvaUser.boothsAssigned!.split(",")[index]));
    loadingPage = false;
    notifyListeners();
  }

  changeCategory(String val) {
    selectedCategory = val;
    notifyListeners();
  }

  changeSelectedAssembly(Assembly assembly) {
    selectedAssembly = assembly;
    selectedAssemblyName = assembly.name;
    notifyListeners();
  }

  getAssemblyList() async {
    /// district null all assembly in states will return
    assemblyList = await DbServices.db
        .getAssemblyForBoothJodho(currentYuvaUser.stateCode);
    // print("Assembly list in booth jodo ${assemblyList}");
  }

  pickDocument(ImageSource imageSource, String? pickedFilePath, DocumentType documentType) async {
    final result = await ImageServices().pickImage(imageSource);
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
          throw UnimplementedError();
        case DocumentType.evoderidFront:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.evoderidBack:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.adhaaridFront:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.adhaaridBack:
          // TODO: Handle this case.
          throw UnimplementedError();
        case DocumentType.studentid:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      notifyListeners();
    } else {
      return null;
    }
  }

  submit(BuildContext context) {
//

    if (validateForm(context)) {
      addBoothJodo(context);
    }
  }

  changeGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    notifyListeners();
  }

  void changeBla(bool value) {
    blaStatus = value;
    notifyListeners();
  }

  void updateUserData(Voter voter) {
    firstNameController.text = voter.name;
    lastNameController.text = voter.fatherOrHusbandName;
    idCardNumberController.text = voter.voterId;
    selectedGender =
        (voter.gender == "Male" || voter.gender == "M") ? "M" : "F";
    notifyListeners();
  }

  bool validateForm(BuildContext context) {
    bool validatedSuccess = true;

    if (firstNameController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill First name", context);
      validatedSuccess = false;
    }
    if (lastNameController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill Last name", context);
      validatedSuccess = false;
    }
    if (idCardNumberController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill EPIC ID", context);
      validatedSuccess = false;
    }
    if (mobileController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill mobile number", context);
      validatedSuccess = false;
    }
    print(refererController.text.trim().length);
    if(refererController.text.trim().length >= 1){
      if (refererController.text.trim().length != 10) {
        showCustomSnackBar("Kindly fill correct referrer mobile number", context);
        validatedSuccess = false;
      }
    }
    if (selectedGender == null) {
      showCustomSnackBar("Select Gender", context);
      validatedSuccess = false;
    }
    if (selectedCategory == null) {
      showCustomSnackBar("Select Category", context);
      validatedSuccess = false;
    }
    if (selectedDate == null) {
      showCustomSnackBar("Select a date of birth", context);
      validatedSuccess = false;
    }

    return validatedSuccess;
  }

  getOtp(BuildContext context) async {
    showNetworkLoadingDialog(context);
    var testJsonData = '''[{
    "STATE_CODE":"${currentYuvaUser.stateCode}",
    "MOBILE":${mobileController.text},
    "CHANNEL":"${AppConstants.channel}",
    "V":"${AppConstants.iycVersion}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    ApiResponse apiResponse = await sl<ApiConfig>()
        .postData(endpointUrl: Urls.getOtpCommon, jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        otpSend = true;
        notifyListeners();
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
      }
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
    }
  }

  verifyOtpForMember(BuildContext context) async {
    if (!otpSend) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("kindly get OTP and then verify it")));
      return false;
    }
    if (verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("kindly fill verification code send to your mobile")));
      return false;
    }
    showNetworkLoadingDialog(context);
    var testJsonData = '''[{
    "STATE_CODE":"${currentYuvaUser.stateCode}",
    "MOBILE":"${mobileController.text}",
    "OTP":"${verificationCodeController.text}",
    "CHANNEL":"${AppConstants.channel}",
    "V":"${AppConstants.iycVersion}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    ApiResponse apiResponse = await sl<ApiConfig>()
        .postData(endpointUrl: Urls.validateOtpCommon, jsonData: testJsonData);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        otpVerified = true;
        return true;
      } else {
        otpVerified = false;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
        return false;
      }
    } else {
      otpVerified = false;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
      return false;
    }
  }

  void addBoothJodo(BuildContext context) async {
    if (!await verifyOtpForMember(context)) {
      return;
    }
    String fileName =
        "${mobileController.text}_${DateTime.now().toString().replaceAll(" ", "_")}_P.jpg";
    if (pickedProfileFile != null)
      await uploadDocument(
          pickedProfileFilePath,
          "${sl<SharedPreferences>().get("s3_bucket")}/yuvabooth/${currentYuvaUser.stateCode}",
          fileName);
    showNetworkLoadingDialog(context);
    ApiResponse apiResponse = await sl<YuvaBoothRepo>().addBoothJodo({
      "FIRST_NAME": "${firstNameController.text}",
      "LAST_NAME": "${lastNameController.text}",
      "MOBILE": "${mobileController.text}",
      "GENDER": "${selectedGender ?? ""}",
      "CASTE": "${selectedCategory}",
      "DOB": "${selectedDate}",
      "YUVA_USER_ID": "${currentYuvaUser.yuvaUserId}",
      "STATE_CODE": "${currentYuvaUser.stateCode}",
      "EPIC": "${idCardNumberController.text}",
      "REFERRED_BY": "${refererController.text}",
      "ASSEMBLY_CODE": "${selectedAssembly!.assemblyCode}",
      "PHOTO_PATH":
          "${"${sl<SharedPreferences>().get("s3_bucket")}/yuvabooth/${currentYuvaUser.stateCode}/$fileName)"}"
    });
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
        Navigator.of(context).pop(); // loading dialog
        Navigator.of(context).pop(); // page close

        notifyListeners();
      } else {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }
}
