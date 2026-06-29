import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/blocks.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/screens/widgets/button/upload_button.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/offline_model/database/assembly.dart';

class RegisterProvider extends ChangeNotifier {
  TextEditingController mobileController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController epicController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController fbController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  bool isEditMode = false;
  UserDetail? userDetail;
  bool loadingScreen = false;

  initRegistrationScreen(UserDetail? userDetail) {
    if (userDetail != null) {
      this.userDetail = userDetail;

      isEditMode = true;
      mobileController.text = userDetail.mobile;
      // emailController.text = userDetail.email;
      //epicController.text = userDetail.epicId ?? "";
      nameController.text = userDetail.name;
      //  twitterController.text = userDetail.twitterId ?? "";
      //   fbController.text = userDetail.fbId ?? "";
      //  instagramController.text = userDetail.instagramId ?? "";
    }
  }

  String? pickedIdProofPath;
  File? pickedIdFile;

  String? pickedAMFilePath;
  File? pickedAMFile;

  bool showAMImage = false;
  bool showIdImage = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode mobileFocus = FocusNode();
  final FocusNode verificationCode = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode epicFocus = FocusNode();

  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>? assemblyList;

  GlobalKey _dropdownButtonKey = GlobalKey();
  get dropdownButtonKey => _dropdownButtonKey;

  Districts? selectedDistrict;
  Assembly? selectedAssembly;
  String? selectedBlockCode;
  States? selectedState;
  String? selectedGender;
  String? selectedDate;

  Booth? selectedBooth;
  Blocks? selectedBlock;
  List<Blocks>? blocksList;
  List<Booth>? boothsList;
  List<DropdownItem>? blockListDropDown;
  List<DropdownItem>? boothListDropDown;
  List<DropdownItem> genders = [
    DropdownItem("Male", "M"),
    DropdownItem("Female", "F"),
    DropdownItem("Others", "O")
  ];
  DateTime eventDate = DateTime.now();

  changeGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    notifyListeners();
  }

  getStatesList() async {
    stateList = await DbServices.db.getAllStates(true);
    if (isEditMode) {
      selectedState = stateList!
          .firstWhere((element) => element.stateCode == userDetail!.stateCode);
      print(selectedState!.stateCode);
      getDistrictList();
    }
    notifyListeners();
  }

  changeSelectedState(States state) {
    selectedState = state;
    selectedDistrict = null;
    clearBlocks();
    clearBooth();
    notifyListeners();
    getDistrictList();
  }

  getDistrictList() async {
    districtList = await DbServices.db.getDistricts(selectedState!);
    if (isEditMode) {
      selectedDistrict = districtList!.firstWhere(
          (element) => element.districtCode == userDetail!.districtCode);
      getAssemblyList();
    }
    notifyListeners();
  }

  getAssemblyList() async {
    assemblyList = await DbServices.db.getAssembly(selectedDistrict!);
    if (isEditMode) {
      {
        selectedAssembly = assemblyList!.firstWhere(
            (element) => element.assemblyCode == userDetail!.assemblyCode);
        getBoothList();
      }
    }
    notifyListeners();
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

  getBoothList() async {
    if (isEditMode) {
      boothListDropDown = List.generate(
          500, (index) => DropdownItem("Booth ${index + 1}", "${index + 1}"));
    } else {
      boothsList = await DbServices.db.getBooths(selectedBlock!);
      if (boothsList?.isNotEmpty ?? false) {
        boothListDropDown = List.generate(
            boothsList!.length,
            (index) => DropdownItem(
                "${boothsList![index].boothCode}:${boothsList![index].boothName}",
                boothsList![index].boothCode));
      }
    }
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
    selectedBooth = isEditMode
        ? Booth(
            id: 0,
            districtCode: "",
            stateCode: "",
            assemblyCode: "",
            blockCode: "",
            boothCode: val,
            boothName: val)
        : boothsList!.firstWhere((element) => element.boothCode == val);
    notifyListeners();
  }

  changeSelectedDistrict(Districts district) {
    selectedAssembly = null;

    selectedDistrict = district;
    clearBlocks();
    clearBooth();
    notifyListeners();
    getAssemblyList();
    getBlocksList();
  }

  changeSelectedAssembly(Assembly assembly) {
    selectedAssembly = assembly;
    notifyListeners();
  }

  clearBlocks() {
    selectedBlock = null;
    blocksList = null;
    blockListDropDown = null;
  }

  clearBooth() {
    selectedBooth = null;
    boothsList = null;
    boothListDropDown = null;
  }

  refresh() {
    selectedState = null;
    selectedDistrict = null;
    selectedAssembly = null;
    selectedBlockCode = null;
    notifyListeners();
  }

  bool validatePage(BuildContext context) {
    bool pageValidation = true;
    final formValidated = formKey.currentState?.validate();
    if (selectedDate == null) {
      showCustomSnackBar("Select DOB", context);
      pageValidation = false;
    }
    if (pickedAMFilePath == null) {
      showCustomSnackBar("Upload Your Photo", context);
      pageValidation = false;
    }
    if (selectedState == null) {
      showCustomSnackBar("Select Home State", context);
      pageValidation = false;
    }

    // if (selectedAssembly == null) {
    //   showCustomSnackBar("select Assembly", context);
    //   pageValidation = false;
    // }
    // if (selectedDistrict == null) {
    //   showCustomSnackBar("select District", context);
    //   pageValidation = false;
    // }
    if (selectedGender == null) {
      showCustomSnackBar("select gender", context);
      pageValidation = false;
    }
    return formValidated! && pageValidation;
  }

  bool validateEditPage(BuildContext context) {
    bool pageValidation = true;
    final formValidated = formKey.currentState?.validate();

    if (selectedAssembly == null) {
      showCustomSnackBar("select Assembly", context);
      pageValidation = false;
    }
    if (selectedDistrict == null) {
      showCustomSnackBar("select District", context);
      pageValidation = false;
    }

    return formValidated! && pageValidation;
  }

  pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType, BuildContext context) async {
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
      print("file picked not");
      return null;
    }
  }

  void openDropdown() {
    print("open dropdown");
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
}
