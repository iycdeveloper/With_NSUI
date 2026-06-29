import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/helper/upload_document.dart';
import 'package:path/path.dart' as p;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/widgets/bottom_sheet/form_success_bootom_sheet.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/repository/voters_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCampaignHmVM extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController refererMobileController = TextEditingController();
  TextEditingController epicIdController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  File? pickedProfileFile;
  String? pickedProfileFilePath;
  bool showProfileImage = false;

  Future<void> pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType) async {
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
          pickedProfileFile = _image;
          pickedProfileFilePath = pickedProfileFile!.path;
          showProfileImage = true;
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
      notifyListeners();
    } else {
      return null;
    }
  }

  List<int> selectedYesOrNo = [];

  onClickCheckBox(int index) {
    if (selectedYesOrNo.contains(index)) {
      selectedYesOrNo.remove(index);
    } else {
      selectedYesOrNo.add(index);
    }

    notifyListeners();
  }

  bool isLoading = false;
  bool isLocationCaptured = false;

  String? selectedGender;
  String? selectedParty;
  String? selectedAge;
  late String campaignId;

  String? selectedAssemblyId;

  List<MultiSelectItem<String>> inclinationList = [];

  List<String> selectedInclinations = [];

  Map<String, bool?> inclinationMap = {};

  changeInclination(String selectedInclination, bool? value) {
    print(selectedInclination);

    inclinationMap[selectedInclination] = value;

    print(inclinationMap[selectedInclination]);
    notifyListeners();
  }

  String? selectedInclination;
  double rating = 2.5;

  bool otpSend = false;
  bool otpVerified = false;

  final FocusNode mobileFocus = FocusNode();
  final FocusNode campaignCodeFocus = FocusNode();
  final FocusNode otpCodeFocus = FocusNode();
  final FocusNode refererFocus = FocusNode();

  bool isEnglish = true;

  late List<DropdownItem> genders;

  late List<DropdownItem> ageList;

  List<DropdownItem>? partyList;

  changeGender(String val) {
    selectedGender = val;
    notifyListeners();
  }

  changeRating(double val) {
    rating = val;
    notifyListeners();
  }

  changeAge(String val) {
    selectedAge = val;
    notifyListeners();
  }

  bool isVoterFamilySearchable = false;

  void updateUserData(Voter voter) {
    nameController.text = voter.name;
    relativeNameController.text = voter.fatherOrHusbandName;

    isVoterFamilySearchable = true;
    selectedGender = voter.gender;
    selectedAge = voter.age;
    selectedAssemblyId = assemblyList
        ?.firstWhereOrNull((element) =>
            (element.assemblyCode == voter.assembly?.split("-").first.trim() ||
                element.assemblyNameLocalLang == voter.assembly))
        ?.assemblyCode;
    epicIdController.text = voter.voterId;
    notifyListeners();
    selectedAssemblyName = assemblyList
            ?.firstWhereOrNull(
                (element) => element.assemblyCode == selectedAssemblyId)
            ?.name ??
        "";
  }

  bool isShimlaCampaign = false;

  Future<void> initAddCampaign(
    BuildContext context,
    String campaignId,
  ) async {
    this.campaignId = campaignId;

    isLoading = true;

    genders = [
      DropdownItem("पुस्र्ष", "M"),
      DropdownItem("महिला", "F"),
      DropdownItem("अन्य", "O")
    ];
    partyList = [
      DropdownItem("कांग्रेस", "कांग्रेस"),
      DropdownItem("भाजपा", "भाजपा"),
      DropdownItem("निष्पक्ष", "निष्पक्ष")
    ];

    inclinationList = [
      MultiSelectItem("ओल्ड पेंशन स्कीम बहाल की जानकारी",
          "ओल्ड पेंशन स्कीम बहाल की जानकारी"),
      MultiSelectItem(
          "मुख्यमंत्री सुख आश्रय योजना के तहत 4000 अनाथ बच्चों को अपनाया गया",
          "मुख्यमंत्री सुख आश्रय योजना के तहत 4000 अनाथ बच्चों को अपनाया गया"),
      MultiSelectItem(
          "राजीव गांधी अंग्रेजी माध्यम स्कूल प्रति विधानसभा की शुरुआत",
          "राजीव गांधी अंग्रेजी माध्यम स्कूल प्रति विधानसभा की शुरुआत"),
      MultiSelectItem(
          "डॉक्टर यशवंत परमार योजना से विद्यार्थियों को 1% पर 20 लाख तक का लोन",
          "डॉक्टर यशवंत परमार योजना से विद्यार्थियों को 1% पर 20 लाख तक का लोन"),
      MultiSelectItem(
          "30/10/23 से प्रदेश में पहली बार इंतकाल राजस्व लोक अदालतों का आयोजन",
          "30/10/23 से प्रदेश में पहली बार इंतकाल राजस्व लोक अदालतों का आयोजन"),
      MultiSelectItem(
          "आपदा से निपटने के लिए अब पुनर्वास के लिए 4500 करोड़ और मुआवजा की राशि 25 गुना तक बढ़ाई",
          "आपदा से निपटने के लिए अब पुनर्वास के लिए 4500 करोड़ और मुआवजा की राशि 25 गुना तक बढ़ाई"),
      MultiSelectItem("सरकारी क्षेत्र में 21000 से अधिक रोजगार के अवसर",
          "सरकारी क्षेत्र में 21000 से अधिक रोजगार के अवसर"),
      MultiSelectItem(
          "680 करोड़ की राजीव गांधी स्वरोजगार स्टार्टप योजना की जानकारी",
          "680 करोड़ की राजीव गांधी स्वरोजगार स्टार्टप योजना की जानकारी"),
      MultiSelectItem("बिधवा पुर्नविवाह की राशि 65 हज़ार से बढ़ा कर 2 लाख हुई",
          "बिधवा पुर्नविवाह की राशि 65 हज़ार से बढ़ा कर 2 लाख हुई"),
      MultiSelectItem(
          "भ्रष्टाचार और पेपर लीक मामलों को रोकने के लिए राज्य चयनआयोग की स्थापना",
          "भ्रष्टाचार और पेपर लीक मामलों को रोकने के लिए राज्य चयनआयोग की स्थापना"),
      MultiSelectItem(
          "बेहतर स्वास्थ्य सुविधाओं के लिए हर विधान सभा छेत्र में एक  आदर्श स्वास्थ्य संस्थान",
          "बेहतर स्वास्थ्य सुविधाओं के लिए हर विधान सभा छेत्र में एक  आदर्श स्वास्थ्य संस्थान"),
      MultiSelectItem("पुलिस भर्ती में बेटियों को 30% आरक्षण",
          "पुलिस भर्ती में बेटियों को 30% आरक्षण"),
    ];

    inclinationMap.addEntries(inclinationList
        .map((e) => e.value)
        .toList()
        .map((e) => MapEntry(e, null)));
    ageList = List.generate(
        81, (index) => DropdownItem("${index + 18}", "${index + 18}"));

    isLoading = false;
    // notifyListeners();

    boothListDropDown = List.generate(
        500, (index) => DropdownItem("वार्ड ${index + 1}", "${index + 1}"));

    await getAssemblyList();
    notifyListeners();
  }

  List<DropdownItem>? boothListDropDown;

  getOtp(BuildContext context) async {
    showNetworkLoadingDialog(context);

    ApiResponse apiResponse =
        await YuvaBoothRepo().getOtp(mobileController.text);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
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
    if (otpCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("kindly fill verification code send to your mobile")));
      return false;
    }
    showNetworkLoadingDialog(context);

    ApiResponse apiResponse = await YuvaBoothRepo()
        .verifyOtp(mobileController.text, otpCodeController.text);

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

  bool validateForm(BuildContext context) {
    bool validatedSuccess = true;

    if (nameController.text.trim().isEmpty) {
      showCustomSnackBar("कृपया नाम भरें", context);
      validatedSuccess = false;
    }

    if (mobileController.text.trim().isEmpty) {
      showCustomSnackBar("कृपया मोबाइल नंबर भरें", context);
      validatedSuccess = false;
    }
    if (otpCodeController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill OTP code", context);
      validatedSuccess = false;
    }
    if (selectedAge == null) {
      showCustomSnackBar("एक आयु चुनें", context);
      validatedSuccess = false;
    }
    if (selectedAssemblyId == null) {
      showCustomSnackBar("एक असेंबली चुनें", context);
      validatedSuccess = false;
    }

    return validatedSuccess;
  }

  Address? address;

  Future captureLocation(BuildContext context) async {
    showNetworkLoadingDialog(context);
    final result = await sl<LocationProvider>().getCurrentAddress();

    Navigator.of(context).pop(); // close loading
    if (result is Address) {
      address = result;
      isLocationCaptured = true;
      notifyListeners();
      return true;
    } else {
      showCustomSnackBar(result, context);
      return false;
    }
  }

  bool shouldPickAssembly = false;
  String? selectedAssemblyName;
  List<Assembly>? assemblyList;
  List<DropdownItem>? assemblyDropDownList;

  getAssemblyList() async {
    var workStateCode = await LocalStorageServices().getWorkStateCode();
    if (workStateCode == "") {
      workStateCode = await LocalStorageServices().getSTCode();
      Log.printILog('Home state code $workStateCode');
      // showCustomSnackBar("Work state is not assigned to user", context);
      // return;
    }
    // state
    /// district null all assembly in states will return
    assemblyList = await DbServices.db
        .getAssemblyForVotersList(null, stateCode: await workStateCode);

    if (assemblyList != null && assemblyList!.isNotEmpty)
      assemblyDropDownList = List.generate(
          assemblyList!.length,
          (index) => DropdownItem(
              (assemblyList![index].assemblyNameLocalLang?.trim().isNotEmpty ??
                      false)
                  ? "${assemblyList![index].name} (${assemblyList![index].assemblyNameLocalLang})"
                  : assemblyList![index].name,
              assemblyList![index].assemblyCode,
              englishLangName: assemblyList![index].name,
              localLangName: assemblyList![index].assemblyNameLocalLang));
    //notifyListeners();
    return true;
  }

  changeAssembly(val) {
    selectedAssemblyId = val;

    notifyListeners();
  }

  checkAssembly(BuildContext context) async {
    showNetworkLoadingDialog(context);
    ApiResponse apiResponse = await CampaignRepo().checkAssembly(campaignId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop(); // loading close network dialog
        if (responseDecoded["response"] == 0) {
          shouldPickAssembly = true;
          await getAssemblyList();

          await Alert(
            context: context,
            type: AlertType.info,
            title: "Check Assembly",
            desc: "Pick Your Assembly",
            content: Builder(builder: (context1) {
              return ChangeNotifierProvider.value(
                value: context.read<AddCampaignHmVM>(),
                child: Consumer<AddCampaignHmVM>(
                    builder: (_, model, __) => DropDownPicker(
                        currentValue: model.selectedAssemblyId,
                        listValues: model.assemblyDropDownList,
                        onChanged: (val) {
                          changeAssembly(val);
                        },
                        labelText: "",
                        hintText: "")),
              );
            }),
            buttons: [
              DialogButton(
                child: Text(
                  "OKAY",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
          if (selectedAssemblyId != null) {
            return true; // assembly picked
          } else {
            return false; // failed to pick assembly
          }
        } else {
          selectedAssemblyName = responseDecoded['response'];
          return true; // no need to pick assembly
        }
      } else {
        Navigator.of(context).pop(); // loading cloase

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    } else {
      Navigator.of(context).pop(); // pop loading

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
  }

  void addCampaign(BuildContext context) async {
    if (!await captureLocation(context)) {
      showCustomSnackBar("Location Not Enabled ", context);
      return;
    }
    if (!await verifyOtpForMember(context)) {
      return;
    }
    String fileName = "${mobileController.text}_P.jpg";
    showNetworkLoadingDialog(context);
    if (pickedProfileFile != null)
      await uploadDocument(pickedProfileFilePath,
          "${sl<SharedPreferences>().get("s3_bucket")}/D2D", fileName);

    var schemeOptionsList =
        inclinationMap.entries.map((e) => "${e.key}-${e.value ?? ""}").toList();
    var familyVotersSelected = votersList
        .where((e) => e.selectedFamilyVoterOption != null)
        .toList()
        .map((e) => "${e.voterId}-${e.selectedFamilyVoterOption}")
        .toList();

    Map<String, String> data = {
      "NAME": "${nameController.text}",
      "MOBILE": "${mobileController.text}",
      "AGE": "${selectedAge ?? ""}",
      "GENDER": "$selectedGender",
      "RELATIVE_NAME": "${relativeNameController.text}",
      "SCHEME_OPTIONS":
          "${schemeOptionsList.reduce((value, element) => "$value,$element")}",
      "CAMPAIGN_ID": "${campaignId}",
      "VERIFICATION_CODE": "${otpCodeController.text}",
      "EPIC": "${epicIdController.text}",
      "RECEPTION": "$rating",
      "CITY": "${address?.locality ?? ""}",
      "STATE": "${address?.state ?? ""}",
      "ADDED_BY_ASSEMBLY": selectedAssemblyName ?? "",
      "WARD_NO": "${selectedWard ?? ""}",
      "LOCATION": "${address?.formattedAddress ?? ""}",
      "INCLINATION": "${selectedParty ?? ""}",
      "ASSEMBLY_CODE": "${selectedAssemblyId ?? ""}",
      "BOOTH_MEMBER": "${checkBoxTicked ? "YES" : "NO"}",
      "FAMILY_VOTERS":
          "${familyVotersSelected.isNotEmpty ? familyVotersSelected.reduce((value, element) => "$value,$element") : ""}",
      "VOTER_LIST_COUNT": "${selectedVoterListOption ?? ""}",
      "STATE_CODE": "${await LocalStorageServices().getWorkStateCode()}",
      "REFERRED_BY": "${refererMobileController.text}",
      "OCCUPATION": "${jobController.text}",
      "CATEGORY": "${selectedCategory ?? ""}",
      "LATITUDE": "${address?.latitude ?? ""}",
      "LONGITUDE": "${address?.longitude ?? ""}",
      "PARTY": "$selectedPartyName"
    };

    debugPrint(data.toString());
    ApiResponse apiResponse = await CampaignRepo().addCampaignData(data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
        campaignSuccessBottomSheet();
        // loading dialog

        // await Alert(
        //   context: context,
        //   type: AlertType.success,
        //   title: "Success",
        //   desc: responseDecoded['response'],
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "OKAY",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () async {
        //         Navigator.pop(context);
        //       },
        //       width: 120,
        //     )
        //   ],
        // ).show();
        // page close
        // await toPage(
        //     context,
        //     ChangeNotifierProvider(
        //       create: (context) => AddCampaignHmVM(),
        //       child: AddCampaignHr(
        //         campaignId: campaignId,
        //       ),
        //     ));
      } else {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    } else {
      Navigator.of(context).pop(); // pop loading
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
  }

  void changeLanguage(BuildContext context) {
    if (isEnglish) {
      isEnglish = false;
    } else {
      isEnglish = true;
    }

    genders = [
      DropdownItem("पुरुष", "M"),
      DropdownItem("महिला", "F"),
      DropdownItem("अन्य", "U"),
    ];

    notifyListeners();
  }

  String? selectedWard;

  void changeWard(value) {
    selectedWard = value;
    notifyListeners();
  }

  bool checkBoxTicked = false;

  void changeCheckBox(bool checkbox) {
    checkBoxTicked = checkbox;
    notifyListeners();
  }

  String selectedPartyName = '';
  void selectParty(String value) {
    selectedPartyName = value;
    notifyListeners();
  }

  void changeParty(value) {
    selectedParty = value;
    notifyListeners();
  }

  void changeCategory(value) {
    selectedCategory = value;
    notifyListeners();
  }

  String? selectedCategory;

  List<DropdownItem> categoryList = [
    DropdownItem("सामान्य", "General"),
    DropdownItem("अनुसूचित जाति", "SC"),
    DropdownItem("अनुसूचित जनजाति", "ST"),
    DropdownItem("पिछड़ा वर्ग", "OBC"),
    DropdownItem("अन्य", "Unknown"),
  ];

  List<DropdownItem> familyVoterList = [
    DropdownItem("सत्यापित: घर पे हैं", "सत्यापित: घर पे हैं"),
    DropdownItem("सत्यापित: बाहर रहते हैं", "सत्यापित: बाहर रहते हैं"),
    DropdownItem("मृत", "मृत"),
    DropdownItem("पफर्जी/असत्यापित", "फर्जी/असत्यापित"),
  ];

  List<DropdownItem> needToAddVoterList = [
    DropdownItem("0", "0"),
    DropdownItem("1", "1"),
    DropdownItem("2", "2"),
    DropdownItem("2 से ज्यादा", "2 से ज्यादा"),
  ];

  void changeVoterListOption(value) {
    selectedVoterListOption = value;
    notifyListeners();
  }

  void changeFamilyVoter(value) {
    selectedFamilyVoter = value;
    notifyListeners();
  }

  void changeNeedToAddVoter(value) {
    selectedNeedToAddVoter = value;
    notifyListeners();
  }

  String? selectedVoterListOption;
  String? selectedFamilyVoter;
  String? selectedNeedToAddVoter;

  List<DropdownItem> voterListOptionList = [
    DropdownItem("0", "0"),
    DropdownItem("1", "1"),
    DropdownItem("2", "2"),
    DropdownItem("2 से ज्यादा", "2 से ज्यादा")
  ];

  void changeDeclare(value) {
    selectedDeclarer = value;
    notifyListeners();
  }

  String? selectedDeclarer;

  List<DropdownItem> declarerList = [
    DropdownItem("सत्यापित: घर पे हैं", "सत्यापित: घर पे हैं"),
    DropdownItem("सत्यापित: बाहर रहते हैं", "सत्यापित: बाहर रहते हैं"),
    DropdownItem("मृत", "मृत"),
    DropdownItem("फर्जी/असत्यापित", "फर्जी/असत्यापित")
  ];

  String? selectedParliamentCode;
  TextEditingController familyVoterSearchController = TextEditingController();
  bool loadingFamilyVotersList = false;
  List<Voter> votersList = [];

  searchFamilyVoter(BuildContext context, String keyword) async {
    FocusScope.of(context).unfocus();

    loadingFamilyVotersList = true;
    notifyListeners();

    final apiResponse = await VotersRepo().getFamilyVotersList(
      searchKey: keyword,
      assembyCode: selectedAssemblyId,
      parliamentId: selectedParliamentCode,
      epicId: epicIdController.text,
    );
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        loadingFamilyVotersList = false;
        votersList = votersListFromJson(responseDecoded["response"]);

        notifyListeners();
      } else {
        loadingFamilyVotersList = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  void clearVoterList() {
    votersList.clear();
    notifyListeners();
  }

  changeVoterListFamilyOption(String option, int voterIndex) {
    votersList[voterIndex].selectedFamilyVoterOption = option;
    notifyListeners();
  }

  ///##########################################################################
  ///########################### search ########################################

  List<Voter> filteredVotersList = [];
  List<Voter> allVotersList = [];

  String? selectedParliamentCodeSearch;
  String? selectedAssemblyCodeSearch;

  String? selectedParliamentNameSearch;
  String? selectedAssemblyNameSearch;
  List<String> parliamentList = [];
  List<DropdownItem> parliamentDropdownItems = [];
  List<DropdownItem> assemblyDropdownItems = [];
  var votersListMap = [];

  List<Districts>? districtList;
  List<Assembly>? assemblyListSearch;

  TextEditingController idController = TextEditingController();

  String? langCode;

  initVotersList(BuildContext context, String? langCode) async {
    this.langCode = langCode;
    await LocalStorageServices()
        .getSelectedParliamentVoterSearch()
        .then((value) async {
      if (value.isNotEmpty) {
        selectedParliamentCodeSearch = value;
        selectedParliamentNameSearch = await LocalStorageServices()
            .getSelectedParliamentEnglishVoterSearch();
        selectedParliamentLocalNameSearch = await LocalStorageServices()
            .getSelectedParliamentLocalLangVoterSearch();
      }
    });
    await LocalStorageServices()
        .getSelectedAssemblyVoterSearch()
        .then((value) async {
      if (value.isNotEmpty) {
        selectedAssemblyCodeSearch = value;
        selectedAssemblyNameSearch = await LocalStorageServices()
            .getSelectedAssemblyEnglishVoterSearch();
        selectedAssemblyLocalNameSearch = await LocalStorageServices()
            .getSelectedAssemblyLocalLangVoterSearch();
      }
    });

    getAssemblyAndParliament(context);

    notifyListeners();
    // print(result);
  }

  getAssemblyAndParliament(BuildContext context) async {
    var workStateCode = await LocalStorageServices().getWorkStateCode();
    if (workStateCode == "") {
      workStateCode = await LocalStorageServices().getSTCode();
      Log.printILog('Home state code $workStateCode');
      // showCustomSnackBar("Work state is not assigned to user", context);
      // return;
    }

    parliamentDropdownItems =
        await DbServices.db.getLocalNamedParliaments(stateCode: workStateCode);
    Log.printDLog('parliament list count ${parliamentDropdownItems.length}');
    if (selectedParliamentCodeSearch != null)
      assemblyDropdownItems = await DbServices.db.getLocalNamedAssembly(
          stateCode: workStateCode, loksabhaCode: selectedParliamentCodeSearch);
    notifyListeners();
  }

  changeParliament(String parliament) async {
    selectedParliamentCodeSearch = parliament;
    selectedAssemblyCodeSearch = null;
    assemblyDropdownItems = await DbServices.db.getLocalNamedAssembly(
        stateCode: await LocalStorageServices().getWorkStateCode(),
        loksabhaCode: selectedParliamentCodeSearch);
    print('##################################################################');
    print(parliament);
    print(assemblyDropdownItems);
    notifyListeners();
  }

  String? selectedAssemblyLocalNameSearch;
  String? selectedParliamentLocalNameSearch;

  changeAssemblySearch(String assembly) {
    selectedAssemblyCodeSearch = assembly;
    notifyListeners();
    selectedAssemblyNameSearch = assemblyDropdownItems
        .firstWhere((element) => element.value == selectedAssemblyCodeSearch)
        .englishLangName;
    selectedAssemblyLocalNameSearch = assemblyDropdownItems
            .firstWhere(
                (element) => element.value == selectedAssemblyCodeSearch)
            .localLangName ??
        "";

    selectedParliamentNameSearch = parliamentDropdownItems
        .firstWhere((element) => element.value == selectedParliamentCodeSearch)
        .englishLangName;
    selectedParliamentLocalNameSearch = parliamentDropdownItems
            .firstWhere(
                (element) => element.value == selectedParliamentCodeSearch)
            .localLangName ??
        "";

    Future.wait([
      LocalStorageServices().setSelectedAssemblyVoterSearch(assembly),
      LocalStorageServices()
          .setSelectedParliamentVoterSearch(selectedParliamentCodeSearch!),
      LocalStorageServices()
          .setSelectedAssemblyEnglishVoterSearch(selectedAssemblyNameSearch!),
      LocalStorageServices().setSelectedParliamentEnglishVoterSearch(
          selectedParliamentNameSearch!),
      if (selectedParliamentLocalNameSearch?.isNotEmpty ?? false)
        LocalStorageServices().setSelectedParliamentLocalLangVoterSearch(
            selectedParliamentLocalNameSearch!),
      if (selectedAssemblyLocalNameSearch?.isNotEmpty ?? false)
        LocalStorageServices().setSelectedAssemblyLocalLangVoterSearch(
            selectedAssemblyLocalNameSearch!)
    ]);
  }

  Timer? _timer;
  String? previousKeyword;

  searchVoterByKeyword(String keyword, BuildContext context,
      {int? throttleTime}) {
    _timer?.cancel();
    if (keyword.isNotEmpty) {
      previousKeyword = keyword;
      _timer =
          Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
        searchVoter(context, keyword);
        _timer?.cancel();
      });
    }
  }

  void clearVoterListSearch() {
    allVotersList.clear();
    filteredVotersList.clear();
    notifyListeners();
  }

  bool showSearch = false;

  void idControllerListner(TextEditingController controller) {
    if (controller.text.length > 0) {
      showSearch = true;
    } else {
      showSearch = false;
    }
    notifyListeners();
  }

  int selectedVoterSearchType = 0;

  void changeVoterSearchType(int? index) {
    if (index != null) selectedVoterSearchType = index;
    notifyListeners();
  }

  searchVoter(BuildContext context, String keyword) async {
    FocusScope.of(context).unfocus();
    isLoading = true;
    notifyListeners();

    final apiResponse = await VotersRepo().getVotersList(
      keyword,
      selectedVoterSearchType == 0 ? "NAME" : "EPIC",
      selectedAssemblyCodeSearch,
      selectedParliamentCodeSearch,
      selectedAssemblyNameSearch ?? "",
      selectedParliamentNameSearch ?? "",
      selectedAssemblyLocalNameSearch,
      selectedParliamentLocalNameSearch,
      langCode,
    );
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));

      if (responseDecoded['status'] == "SUCCESS") {
        isLoading = false;
        filteredVotersList = votersListFromJson(responseDecoded["response"]);
        isLoading = false;
        notifyListeners();
        print(
            "###############################################################");
        return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Users'),
            content: filteredVotersList.isEmpty
                ? Container(
                    child: Text('No data Found'),
                  )
                : Container(
                    width: double.minPositive,
                    child: ListView.builder(
                      itemCount: filteredVotersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            filteredVotersList[index].name,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredVotersList[index].voterId),
                              Text(filteredVotersList[index]
                                      .fatherOrHusbandName ??
                                  ""),
                            ],
                          ),
                          onTap: () async {
                            await Alert(
                              context: context,
                              onWillPopActive: true,
                              content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VoterListInfoLabel(
                                      label: "Name",
                                      value: filteredVotersList[index].name,
                                    ),
                                    VoterListInfoLabel(
                                      label: "Father Name",
                                      value: filteredVotersList[index]
                                          .fatherOrHusbandName,
                                    ),
                                    VoterListInfoLabel(
                                      label: "Voter ID",
                                      value: filteredVotersList[index].voterId,
                                    ),
                                    VoterListInfoLabel(
                                      label: "Gender",
                                      value: filteredVotersList[index].gender,
                                    ),
                                    VoterListInfoLabel(
                                      label: "Parliament",
                                      value: filteredVotersList[index]
                                              .parliament ??
                                          "",
                                    ),
                                    VoterListInfoLabel(
                                      label: "Assembly",
                                      value:
                                          filteredVotersList[index].assembly ??
                                              "",
                                    ),
                                  ]),
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "CANCEL",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  width: 120,
                                ),
                                DialogButton(
                                  child: Text(
                                    "CONFIRM",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    idController.clear();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    updateUserData(filteredVotersList[index]);
                                  },
                                  width: 120,
                                )
                              ],
                            ).show();
                            //   Navigator.of(context).pop(model.voterList[index]);
                          },
                          trailing: Text(filteredVotersList[index].gender),
                        );
                        //   ListTile(
                        //   onTap: (){
                        //     Navigator.of(context).pop();
                        //     updateUserData(filteredVotersList[index]);
                        //   },
                        //   title: Text(filteredVotersList[index].name),
                        //   // You can add onTap functionality for each item here if needed
                        // );
                      },
                    ),
                  ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      } else {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
