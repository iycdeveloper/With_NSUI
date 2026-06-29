import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/home/campaign/add_campaign_mp.dart';
import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddCampaignMpVM extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController refererMobileController = TextEditingController();

  TextEditingController epicIdController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  bool isLoading = false;
  bool isLocationCaptured = false;

  // Voter? voter;

  String? selectedGender;
  String? selectedParty;
  String? selectedAge;
  late String campaignId;

  String? selectedAssemblyId;

  //1. ಗೃಹ ಜ್ಯೋತಿ - Gruha Jyoti
  //
  // 2. ಗೃಹ ಲಕ್ಷ್ಮಿ - GruhaLakshmi
  //
  // 3. ಅನ್ನ ಭಾಗ್ಯ - Anna Bhagya
  //
  // 4. ಯುವ ನಿಧಿ - Yuva Nidhi
  List<MultiSelectItem<String>> inclinationList = [];

  List<String> selectedInclinations = [];
  String? selectedInclination;
  double rating = 2.5;

  bool otpSend = false;
  bool otpVerified = false;

  final FocusNode mobileFocus = FocusNode();
  final FocusNode refererFocus = FocusNode();
  final FocusNode campaignCodeFocus = FocusNode();
  final FocusNode otpCodeFocus = FocusNode();

  bool isEnglish = true;

  late List<DropdownItem> genders;

  late List<DropdownItem> inclinations;

  late List<DropdownItem> ageList;

  List<DropdownItem>? partyList;

  // updateVoter(Voter v){
  //   voter = v;
  //   notifyListeners();
  // }

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

  changeInclination(val) {
    selectedInclinations = val;

    notifyListeners();
  }

  void updateUserData(Voter voter) {
    nameController.text = voter.name;
    relativeNameController.text = voter.fatherOrHusbandName;
    isVoterFamilySearchable = true;
    selectedGender = voter.gender;
    selectedAge = voter.age;
    selectedAssemblyId = assemblyList
        ?.firstWhere((element) =>
            (element.name.toUpperCase() == voter.name.toUpperCase() ||
                element.assemblyNameLocalLang == voter.assembly))
        .assemblyCode;
    epicIdController.text = voter.voterId;
    notifyListeners();
    selectedAssemblyName = assemblyList
        ?.firstWhere((element) => element.assemblyCode == selectedAssemblyId)
        .name;
  }

  bool validateVoterIdAndShowPopUp(BuildContext context) {
    if (epicIdController.text.isEmpty) {
      showCustomSnackBar(
          'कृपया बूथ सदस्य का वोटर आईडी सर्च ऑप्शन में जाकर जोड़े।', context);
      return false;
    } else {
      return true;
    }
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
    // partyList = [
    //   DropdownItem("कांग्रेस", "कांग्रेस"),
    //   DropdownItem("भाजपा", "भाजपा"),
    //   DropdownItem("अन्य", "अन्य")
    // ];

    inclinationList = [
      MultiSelectItem("महिलाओं को 1500 रुपए प्रति माह दिए जाएंगे.","महिलाओं को 1500 रुपए प्रति माह दिए जाएंगे."),
      MultiSelectItem("500 रुपए में गैस सिलेंडर दिया जाएगा.", "500 रुपए में गैस सिलेंडर दिया जाएगा."),
      MultiSelectItem("100 यूनिट बिजली बिल माफ होगा. 200 यूनिट तक बिजली बिल हाफ होगा.", "100 यूनिट बिजली बिल माफ होगा. 200 यूनिट तक बिजली बिल हाफ होगा."),
      MultiSelectItem("किसानों का फसल कर्ज माफ होगा.","किसानों का फसल कर्ज माफ होगा."),
      MultiSelectItem("कर्मचारियों को पुरानी पेंशन योजना का लाभ दिया जाएगा.","कर्मचारियों को पुरानी पेंशन योजना का लाभ दिया जाएगा."),
      MultiSelectItem("किसानों को 5 हॉर्स पावर बिजली बिल माफ रहेगा.","किसानों को 5 हॉर्स पावर बिजली बिल माफ रहेगा."),
      MultiSelectItem("सिंचाई के पुराने बिजली माफ होंगे.","सिंचाई के पुराने बिजली माफ होंगे."),
      MultiSelectItem("27 प्रतिशत ओबीसी आरक्षण का लाभ दिया जाएगा.","27 प्रतिशत ओबीसी आरक्षण का लाभ दिया जाएगा."),
      MultiSelectItem("12 घंटे सिंचाई बिजली की उपलब्धता सुनिश्चित की जाएगी.","12 घंटे सिंचाई बिजली की उपलब्धता सुनिश्चित की जाएगी."),
      MultiSelectItem("जातिगत जनगणना का लाभ मिलेगा.","जातिगत जनगणना का लाभ मिलेगा."),
      MultiSelectItem("किसान आंदोलन के मुकदमे हटाए जाएंगे.","किसान आंदोलन के मुकदमे हटाए जाएंगे."),
      MultiSelectItem("पढ़ो-पढ़ाओ योजना' के तहत छात्रों को प्रतिमाह छात्रवृत","पढ़ो-पढ़ाओ योजना' के तहत छात्रों को प्रतिमाह छात्रवृत"),
    ];

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
      showCustomSnackBar("Kindly fill  Name", context);
      validatedSuccess = false;
    }
    // if (relativeNameController.text.trim().isEmpty) {
    //   showCustomSnackBar("Kindly fill Father or Husband Name", context);
    //   validatedSuccess = false;
    // }

    if (mobileController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill mobile number", context);
      validatedSuccess = false;
    }
    if (otpCodeController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill OTP code", context);
      validatedSuccess = false;
    }

    if (selectedGender == null) {
      showCustomSnackBar("Select Gender", context);
      validatedSuccess = false;
    }
    if (selectedInclinations.isEmpty) {
      showCustomSnackBar("Select a Promises", context);
      validatedSuccess = false;
    }
    if (selectedAge == null) {
      showCustomSnackBar("Select an Age", context);
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
    /// district null all assembly in states will return
    assemblyList = await DbServices.db.getAssemblyForVotersList(null,
        stateCode: await LocalStorageServices().getWorkStateCode());

    if (assemblyList != null && assemblyList!.isNotEmpty)
      assemblyDropDownList = List.generate(
          assemblyList!.length,
          (index) => DropdownItem(
              (assemblyList![index]?.assemblyNameLocalLang?.trim().isNotEmpty ??
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
                value: context.read<AddCampaignMpVM>(),
                child: Consumer<AddCampaignMpVM>(
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
    // if (!isShimlaCampaign) {
    //   final result = await checkAssembly(context);
    //   if (result == null || result == false) return;
    // }
    if (!await captureLocation(context)) {
      showCustomSnackBar("Location Not Enabled ", context);
      return;
    }
    if (!await verifyOtpForMember(context)) {
      return;
    }

    showNetworkLoadingDialog(context);
    var familyVotersSelected = votersList
        .where((e) => e.selectedFamilyVoterOption != null)
        .toList()
        .map((e) => "${e.voterId}-${e.selectedFamilyVoterOption}")
        .toList();

    Map<String, String> data = {
      "NAME": "${nameController.text}",
      "MOBILE": "${mobileController.text}",
      "AGE": "${selectedAge}",
      "GENDER": "$selectedGender",
      "RELATIVE_NAME": "${relativeNameController.text}",
      "SCHEME_OPTIONS":
          "${selectedInclinations.reduce((value, element) => "$value,$element")}",
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
      "OCCUPATION": "${jobController.text}",
      "CATEGORY": "${selectedCategory ?? ""}",
      "REFERRED_BY": "${refererMobileController.text}",
      "LATITUDE": "${address?.latitude ?? ""}",
      "LONGITUDE": "${address?.longitude ?? ""}"
    };

    ApiResponse apiResponse = await CampaignRepo().addCampaignData(data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      print(responseDecoded);
      if (responseDecoded['status'] == "SUCCESS") {
        Navigator.of(context).pop(); // loading dialog

        await Alert(
          context: context,
          type: AlertType.success,
          title: "Success",
          desc: responseDecoded['response'],
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
        Navigator.of(context).pop(true); // page close
        await toPage(
            context,
            ChangeNotifierProvider(
              create: (context) => AddCampaignMpVM(),
              child: AddCampaignMp(
                campaignId: campaignId,
              ),
            ));
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
      DropdownItem(isEnglish ? "Male" : "ಪುರುಷ", "M"),
      DropdownItem(isEnglish ? "Female" : "ಸ್ತ್ರೀ", "F"),
      DropdownItem(isEnglish ? "Other" : "ಇತರೆ", "O"),
    ];
    inclinationList = [
      MultiSelectItem(
          "Gruha Jyoti", isEnglish ? "Gruha Jyoti" : " ಗೃಹ ಜ್ಯೋತಿ "),
      MultiSelectItem(
          "GruhaLakshmi", isEnglish ? "GruhaLakshmi" : " ಗೃಹ ಲಕ್ಷ್ಮಿ "),
      MultiSelectItem("Anna Bhagya", isEnglish ? "Anna Bhagya" : " ಅನ್ನ ಭಾಗ್ಯ"),
      MultiSelectItem("Yuva Nidhi", isEnglish ? "Yuva Nidhi" : " ಯುವ ನಿಧಿ "),
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

  void changeParty(value) {
    selectedParty = value;
    notifyListeners();
  }

  void VoterListOption(value) {
    selectedVoterListOption = value;
    notifyListeners();
  }

  String? selectedVoterListOption;

  // List<DropdownItem> voterListOptionList = [
  //   DropdownItem("0", "0"),
  //   DropdownItem("1", "1"),
  //   DropdownItem("2", "2"),
  //   DropdownItem("2 से ज्यादा", "2 से ज्यादा")
  // ];

  void changeCategory(value) {
    selectedCategory = value;
    notifyListeners();
  }

  String? selectedCategory;

  List<DropdownItem> categoryList = [
    DropdownItem("सामान्य", "General"),
    DropdownItem("अनुसूचित जाति", "SC"),
    DropdownItem("अनुसूचित जनजाति", "ST"),
    DropdownItem("अल्पसंख्यक", "Minority"),
    DropdownItem("अन्य पिछड़ा वर्ग", "OBC"),
    DropdownItem("अज्ञात", "Unknown"),
    DropdownItem("सबसे पिछड़ा वर्ग", "MBC"),
    DropdownItem("ख़ानाबदोश जनजाति/विमुक्त जाति और खानाबदोश जनजाति",
        "Nomadic tribe/VJNT")
  ];
  bool isVoterFamilySearchable = false;
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
        showCustomSnackBar(responseDecoded['response'], context);
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

  ///!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ///!!!!!!!!!!!!!!!!!!!!! Search voter list !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
      showCustomSnackBar("Work state is not assigned to user", context);
      return;
    }

    parliamentDropdownItems =
        await DbServices.db.getLocalNamedParliaments(stateCode: workStateCode);
    if (selectedParliamentCodeSearch != null)
      assemblyDropdownItems = await DbServices.db.getLocalNamedAssembly(
          stateCode: await LocalStorageServices().getWorkStateCode(),
          loksabhaCode: selectedParliamentCodeSearch);
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
    if (controller.length > 0) {
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
