import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/helper/upload_document.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di_container.dart';
import '../../model/api_model/base/api_response.dart';
import '../../model/api_model/yuva_user/yuva_user.dart';
import '../../model/offline_model/database/assembly.dart';
import '../../model/offline_model/database/districts.dart';
import '../../model/offline_model/database/states.dart';
import '../../screens/widgets/button/upload_button.dart';
import '../../screens/widgets/custom_snack_bar.dart';

class AddYuvaUserVM extends ChangeNotifier {
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController idCardNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController fbController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  final FocusNode mobileFocus = FocusNode();

  List<String> selectedBooths = [];
  List<MultiSelectItem<String>> boothList = [];
  List<MultiSelectItem<String>> multiSelectAssemblyList = [];

  String? selectedRoleId;

  bool digitalYouthStatus = false;
  bool blaStatus = false;

  List<Districts> selectedDistrictList = [];

  changeSelectedValues(values) {
    selectedBooths = values;
    print(selectedBooths);
    notifyListeners();
  }

  bool isFirstTimeNomination = true;
  bool showError = false;

  List<States>? stateList;
  List<Assembly>? assemblyList;

  String? selectedGender;
  String? selectedDistrictName;
  String? selectedDistrictCode;
  States? selectedState;
  String selectedStateName = "Select State";

  Assembly? selectedAssembly;
  String? selectedAssemblyName;

  File? pickedProfileFile;

  bool showProfileImage = false;

  String? pickedProfileFilePath;

  bool isCategoryNeedDocuments = false;
  bool isSelectedFeeWaiverCategory = false;

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

  Future<List<MultiSelectItem<String>>> generateBoothList() async {
    final list = List.generate(
        500,
        (index) => MultiSelectItem<String>(
            (index + 1).toString(), (index + 1).toString()));
    return list;
  }

  Future<List<MultiSelectItem<String>>> generateAssemblyMultiList(
      List<Assembly> assemblyList) async {
    final list = List.generate(
        assemblyList.length,
        (index) => MultiSelectItem<String>(
            assemblyList[index].assemblyCode, assemblyList[index].name));
    return list;
  }

  bool lockStatePicker = false;

  initAddYuvaUser(YuvaUser yuvaUser, List<YuvaUser> yuvaUserList,
      {String? roleId}) async {
    /// role id will be available in case of sector in charge adding booth in charge  rest cases it it will be null
    selectedRoleId = roleId;
    print("selected rolded isd $roleId");
    loadingPage = true;
    currentYuvaUser = yuvaUser;

    yuvaUsersList = yuvaUserList;
    await Future.delayed(Duration.zero);
    await getStatesList();
    if (currentYuvaUser.roleId != "1") {
      selectedState = stateList?.firstWhereOrNull(
          (element) => element.stateCode == currentYuvaUser.stateCode);
      if (selectedState != null) {
        selectedStateName = selectedState!.name;
        lockStatePicker = true;
        getDistrictList();
        //getAssemblyList();
      }
    }

    boothList = (currentYuvaUser.boothsAssigned?.isEmpty ??
            true) // let generate default 500 booths
        ? await generateBoothList()
        : List.generate(
            currentYuvaUser.boothsAssigned!.split(",").length,
            (index) => MultiSelectItem<String>(
                currentYuvaUser.boothsAssigned!.split(",")[index],
                currentYuvaUser.boothsAssigned!.split(",")[index]));

    if (currentYuvaUser.assembliesAssigned.isNotEmpty) {
      await getAssemblyList(currentYuvaUser.assembliesAssigned);
    }
    loadingPage = false;
    notifyListeners();
  }

  changeSelectedAssembly(Assembly? assembly) {
    if (assembly == null) return;
    selectedAssembly = assembly;
    selectedAssemblyName = assembly.name;
    notifyListeners();
  }

  List<Assembly> selectedAssemblyList = [];

  changeSelectedAssemblyList(List<Assembly>? assemblyList) {
    if (assemblyList == null) return;
    selectedAssemblyList = assemblyList;
    // selectedAssemblyName = assembly.name;
    notifyListeners();
  }

  getStatesList() async {
    stateList =
        await DbServices.db.getAllStates(true); //fetch all state code condition
    notifyListeners();
  }

  List<Districts>? districtList;
  Districts? selectedDistrict;
  String? selectedDisName;

  changeSelectedState(States? state) {
    if (state == null) return;
    selectedState = state;
    selectedStateName = selectedState!.name;
    selectedAssembly = null;
    selectedAssemblyName = null;
    districtList = null;
    assemblyList = null;
    selectedDistrictList = [];
    selectedAssemblyList = [];
    selectedDistrict = null;
    getDistrictList();
    getAssemblyList();
    notifyListeners();
  }

  Future<List<Districts>> getDistrictList() async {
    districtList = await DbServices.db.getDistricts(selectedState!);
    if ((districtList?.isNotEmpty ?? false) &&
        currentYuvaUser.districtsAssigned != null &&
        currentYuvaUser.districtsAssigned!.isNotEmpty) {
      var assignedDistrictList = currentYuvaUser.districtsAssigned!.split(",");
      districtList = districtList!
          .where(
              (element) => assignedDistrictList.contains(element.districtCode))
          .toList();
    }
    notifyListeners();
    return districtList!;
  }

  changeSelectedDistrict(Districts? district) async {
    if (district == null) return;
    selectedDistrict = district;
    selectedDisName = district.name;

    clearAssembly();
    notifyListeners();
    await getAssemblyList();
  }

  clearAssembly() {
    // selectedAssemblyName = defaultAssembly;
    selectedAssembly = null;
    selectedAssemblyList = [];
    notifyListeners();
  }

  clearDistrict() {
    // selectedDisName = defaultConstituency;
    // selectedAssemblyName = defaultAssembly;
    selectedDistrictList = [];
    selectedDistrict = null;
    selectedAssembly = null;

    notifyListeners();
  }

  getAssemblyList([String? assignedAssemblies]) async {
    /// district null all assembly in states will return
    assemblyList = await DbServices.db.getAssembly(selectedDistrict,
        stateCode:
            assignedAssemblies != null ? currentYuvaUser.stateCode : null);
    if (assemblyList != null && assemblyList!.isEmpty) return;

    if (assignedAssemblies != null) {
      debugPrint("Assemblies assigne dnot null");
      assemblyList = assemblyList!
          .where((element) => (assignedAssemblies
              .split(",")
              .toList()
              .contains(element.assemblyCode)))
          .toList();
      debugPrint(assemblyList?.length.toString());
      multiSelectAssemblyList = await generateAssemblyMultiList(assemblyList!);
    } else {
      multiSelectAssemblyList = await generateAssemblyMultiList(assemblyList!);
    }
    notifyListeners();
    return true;
  }

  pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType) async {
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
          break;
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
      addYuvaUser(context);
    }
  }

  void changeDigitalYouth(bool value) {
    digitalYouthStatus = value;
    notifyListeners();
  }

  void changeBla(bool value) {
    blaStatus = value;
    notifyListeners();
  }

  bool validateForm(BuildContext context) {
    bool validatedSuccess = true;

    // if (usernameController.text.trim().isEmpty) {
    //   showCustomSnackBar("Kindly fill First name", context);
    //   validatedSuccess = false;
    // }
    // if (lastNameController.text.trim().isEmpty) {
    //   showCustomSnackBar("Kindly fill Last name", context);
    //   validatedSuccess = false;
    // }
    if (mobileController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill mobile number", context);
      validatedSuccess = false;
    }

    if (selectedRoleId == "3" && selectedDistrictList.isEmpty) {
      showCustomSnackBar("Kindly Select Districts", context);
      validatedSuccess = false;
    }
    if (selectedRoleId == "2" && selectedState == null) {
      showCustomSnackBar("Kindly Select State", context);
      validatedSuccess = false;
    }

    return validatedSuccess;
  }

  checkMobileExist(String mobile) async {
    ApiResponse apiResponse =
        await sl<YuvaBoothRepo>().checkMobileExist(mobile);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        return responseDecoded["response"];
      }
      return null;
    }
    return null;
  }

  void addYuvaUser(BuildContext context) async {
    showNetworkLoadingDialog(context);

    final mobileExist = await checkMobileExist(mobileController.text);
    if (mobileExist == null || (mobileExist == "1")) {
      final alertResult = await Alert(
        context: context,
        type: AlertType.warning,
        onWillPopActive: true,
        title: "Mobile Number Exist",
        desc: "Do you need to proceed",
        buttons: [
          DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            width: 120,
          ),
          DialogButton(
            child: Text(
              "OKAY",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            width: 120,
          ),
        ],
      ).show();
      if (alertResult == null || !alertResult) {
        Navigator.of(context).pop();

        return;
      }
    }
    ApiResponse apiResponse = await sl<YuvaBoothRepo>().addYuvaUserNew({
      "FIRST_NAME": "${usernameController.text}",
      "LAST_NAME": "${lastNameController.text}",
      "MOBILE": "${mobileController.text}",
      "EMAIL": "${emailController.text}",
      "BOOTHS_ASSIGNED":
          "${selectedBooths.isNotEmpty ? selectedBooths.reduce((value, element) => "$value,$element") : ""}",
      "STATE_CODE": "${selectedState!.stateCode}",
      "ASSEMBLY_CODE": "${selectedAssembly?.assemblyCode ?? ""}",
      "ASSEMBLY_ASSIGNED":
          "${selectedAssemblyList.isNotEmpty ? selectedAssemblyList.map((e) => e.assemblyCode).reduce((value, element) => "$value,$element") : ""}",
      "ZONE_CODE": "0",
      "SECTOR_CODE": "0",
      "BOOTH_CODE": "0",
      "DIGITAL_YOUTH": digitalYouthStatus ? "Y" : "N",
      "ROLE_ID": "$selectedRoleId",
      "EPIC": "${idCardNumberController.text}",
      "FACEBOOK": "${fbController.text}",
      "TWITTER": "${twitterController.text}",
      "INSTAGRAM": "${instagramController.text}",
      "BLA": blaStatus ? "Y" : "N",
      "DISTRICT_ASSIGNED":
          "${selectedDistrict != null ? selectedDistrict!.districtCode : selectedDistrictList.isNotEmpty ? selectedDistrictList.map((e) => e.districtCode).reduce((value, element) => "$value,$element") : ""}"
    });
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
        if (pickedProfileFile != null)
          await uploadDocument(
              pickedProfileFilePath,
              "${sl<SharedPreferences>().get("s3_bucket")}/yuvabooth/${selectedState!.stateCode}",
              "${mobileController.text}_P.jpg");
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

  changeSelectedDistrictList(List<Districts> districts) {
    selectedDistrictList = districts;

    getAssemblyList();
    notifyListeners();
  }
}
