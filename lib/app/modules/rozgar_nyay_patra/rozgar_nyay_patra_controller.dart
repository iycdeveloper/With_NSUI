import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/app/widgets/bottom_sheet/form_success_bootom_sheet.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RozgarNyayPatraController extends GetxController {
  String title_ = Get.arguments;

  @override
  void onInit() async {
    super.onInit();
    await getStatesList();
    await getStateAssemblyConsDetailInLocalStorage();
    var userDetail = Get.find<ProfileController>().userDetail;
    try {
      if ([userDetail!.stateCode, userDetail.workingState].contains('TL') ||
          [userDetail.stateCode, userDetail.workingState].contains('AP')) {
        selectedLanguage = 'tl';
      }
    } catch (e) {
      Log.printELog('Error $e');
    }
    update();
  }

  Map<dynamic, dynamic> title = {
    'en': {
      'title': 'Rozgaar Nyay Patra',
      'llb_name': 'Name',
      'llb_age': 'Age',
      'llb_gender': 'Gender',
      'llb_category': 'Category',
      'llb_state': 'State',
      'llb_parliament': 'Parliament Constituency',
      'llb_assembly': 'Assembly Constituency',
      'llb_higher_education': 'Higher Educational Qualification',
      'llb_aspiring_job': 'Aspiring Job',
      'llb_mobile': 'Mobile No.',
      'llb_rozgaar_nyay_code': 'Rozgaar Nyay Code',
      'llb_voter': 'Enter Voter Id No.(Optional)',
      'msg_become_booth_member':
          'I want to become a booth member and take the message of NYAY forward',
    },
    'hi': {
      'title': 'Rozgaar Nyay Patra',
      'llb_name': 'नाम',
      'llb_age': 'उम्र',
      'llb_gender': 'लिंग',
      'llb_category': 'जाति',
      'llb_state': 'राज्य',
      'llb_parliament': 'लोक सभा',
      'llb_assembly': 'विधान सभा',
      'llb_higher_education': 'उच्चतम शैक्षणिक योग्यता',
      'llb_aspiring_job': 'अपने रोज़गार का चयन करें',
      'llb_mobile': 'Mobile No.',
      'llb_rozgaar_nyay_code': 'रोज़गार न्याय कोड',
      'llb_voter': 'वोटर आईडी नं.(Optional)',
      'msg_become_booth_member':
          'मैं बूथ सदस्य बनना चाहता हूँ और न्याय के संदेश को आगे ले जाना चाहता हूँ।',
    },
    'tl': {
      'title': 'Rozgaar Nyay Patra',
      'llb_name': 'పేరు',
      'llb_age': 'వయసు',
      'llb_gender': 'లింగము',
      'llb_category': 'సామాజికవర్గం',
      'llb_state': 'రాష్ట్రం',
      'llb_parliament': 'పార్లమెంట్ నియోజకవర్గం',
      'llb_assembly': 'అసెంబ్లీ నియోజకవర్గం',
      'llb_higher_education': 'అత్యధిక విద్యాఅర్హత',
      'llb_aspiring_job': 'కోరుకునే ఉద్యోగాన్ని ఎంచుకోండి',
      'llb_mobile': 'మొబైల్ నంబర్',
      'llb_rozgaar_nyay_code': 'రోస్గార్ న్యాయ్ కోడ్',
      'llb_voter': 'ఓటరు ఐడిని నమోదు చేయండి (Optional)',
      'msg_become_booth_member':
          'నేను బూత్ మెంబర్‌గా మారాలనుకుంటున్నాను మరియు న్యాయ్ సందేశాన్ని ముందుకు తీసుకెళ్లాలనుకుంటున్నాను',
    }
  };
  Map<dynamic, dynamic> category = {
    'hi': [
      DropdownItem("सामान्य", "General"),
      DropdownItem("अनुसूचित जाति", "SC"),
      DropdownItem("अनुसूचित जनजाति", "ST"),
      DropdownItem("पिछड़ा वर्ग", "OBC"),
      DropdownItem("अल्पसंख्यक", "Minority"),
      DropdownItem("अन्य", "Unknown"),
    ],
    'en': [
      DropdownItem("General", "General"),
      DropdownItem("SC", "SC"),
      DropdownItem("ST", "ST"),
      DropdownItem("OBC", "OBC"),
      DropdownItem("Minority", "Minority"),
      DropdownItem("Unknown", "Unknown"), //Minority
    ],
    'tl': [
      DropdownItem("జనరల్", "General"),
      DropdownItem("ఎస్సీ", "SC"),
      DropdownItem("ఎస్టీ", "ST"),
      DropdownItem("ఓబీసి", "OBC"),
      DropdownItem("మైనారిటీ", "Minority"),
      DropdownItem("తెలియదు", "Unknown"),
    ]
  };
  Map<dynamic, dynamic> gender = {
    'hi': [
      DropdownItem("पुरुष", "Male"),
      DropdownItem("महिला", "Female"),
      DropdownItem("अन्य", "Other"),
    ],
    'en': [
      DropdownItem("Male", "Male"),
      DropdownItem("Female", "Female"),
      DropdownItem("Other", "Other"),
    ],
    'tl': [
      DropdownItem("పురుషుడు", "Male"),
      DropdownItem("స్త్రీ", "Female"),
      DropdownItem("ఇతరులు", "Other"),
    ]
  };
  Map<dynamic, dynamic> job = {
    'hi': [
      DropdownItem("सेना", "Armed Services"),
      DropdownItem("सिविल सेवा", "Civil Services"),
      DropdownItem("शिक्षण", "Teaching"),
      DropdownItem("पुलिस", "Police officer"),
      DropdownItem("रेलवे/ बैंक", "Railway/ Bank"),
      DropdownItem("लेखपाल/ पटवारी/ तेहसीलदार", "Lekhpaal/ Patwari/ Tehsildar"),
      DropdownItem("नर्स/ आशा/ आंगनवाड़ी", "Nurse/ Asha/ Anganwadi"),
      DropdownItem("डॉक्टर/ अभियंता/ वकील ", "Doctor/ Engineer/ Lawyer"),
      DropdownItem("अकाउंटेंट/ मार्केटिंग/ डाटा एंट्री",
          "Accountant/ Marketing/ Data Entry"),
      DropdownItem("स्टार्ट-अप/ व्यवसाय ", "Start-up/ business"),
      DropdownItem("अन्य", "Others"),
    ],
    'en': [
      DropdownItem("Armed Services", "Armed Services"),
      DropdownItem("Civil Services", "Civil Services"),
      DropdownItem("Teaching", "Teaching"),
      DropdownItem("Police officer", "Police officer"),
      DropdownItem("Railway/ Bank", "Railway/ Bank"),
      DropdownItem(
          "Lekhpaal/ Patwari/ Tehsildar", "Lekhpaal/ Patwari/ Tehsildar"),
      DropdownItem("Nurse/ Asha/ Anganwadi", "Nurse/ Asha/ Anganwadi"),
      DropdownItem("Doctor/ Engineer/ Lawyer", "Doctor/ Engineer/ Lawyer"),
      DropdownItem("Accountant/ Marketing/ Data Entry",
          "Accountant/ Marketing/ Data Entry"),
      DropdownItem("Start-up/ business", "Start-up/ business"),
      DropdownItem("Others", "Others"),
    ],
    'tl': [
      DropdownItem("సాయుధ సేవలు", "Armed Services"),
      DropdownItem("పౌర సేవలు", "Civil Services"),
      DropdownItem("టీచింగ్", "Teaching"),
      DropdownItem("పోలీసు అధికారి", "Police officer"),
      DropdownItem("రైల్వే/బ్యాంక్", "Railway/ Bank"),
      DropdownItem(
          "లేఖపాల్/పట్వారీ/తహసీల్దార్", "Lekhpaal/ Patwari/ Tehsildar"),
      DropdownItem("నర్సు/ఆశా/అంగన్‌వాడీ", "Nurse/ Asha/ Anganwadi"),
      DropdownItem("డాక్టర్/ఇంజినీర్/లాయర్", "Doctor/ Engineer/ Lawyer"),
      DropdownItem("అకౌంటెంట్/మార్కెటింగ్/డేటా ఎంట్రీ",
          "Accountant/ Marketing/ Data Entry"),
      DropdownItem("స్టార్ట్ అప్/వ్యాపారం", "Start-up/ business"),
      DropdownItem("ఇతరులు", "Others"),
    ]
  };

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController voterController = TextEditingController();

  bool isEnglish = true;
  bool otpSend = false;
  bool otpVerified = false;
  Address? address;
  bool isLocationCaptured = false;
  bool checkBoxTicked = false;

  String? selectedLanguage = 'en';

  String? selectedJob;
  String? selectedGender;
  String? selectedCategory;
  States? selectedState;
  String? selectedParliament;
  String? selectAssembly;
  String? selectedParliamentName;
  String? selectAssemblyName;
  Districts? selectedDistrict;
  Assembly? selectedAssembly;
  String? selectedAssemblyLocalNameSearch;
  String? selectedParliamentLocalNameSearch;

  List<States>? stateList;
  List<Districts>? districtList;
  List<Assembly>? assemblyList;
  List<DropdownItem> jobsEnglish = [
    DropdownItem("Armed Services", "Armed Services"),
    DropdownItem("Civil Services", "Civil Services"),
    DropdownItem("Teaching", "Teaching"),
    DropdownItem("Police officer", "Police officer"),
    DropdownItem("Railway/ Bank", "Railway/ Bank"),
    DropdownItem(
        "Lekhpaal/ Patwari/ Tehsildar", "Lekhpaal/ Patwari/ Tehsildar"),
    DropdownItem("Nurse/ Asha/ Anganwadi", "Nurse/ Asha/ Anganwadi"),
    DropdownItem("Doctor/ Engineer/ Lawyer", "Doctor/ Engineer/ Lawyer"),
    DropdownItem("Accountant/ Marketing/ Data Entry",
        "Accountant/ Marketing/ Data Entry"),
    DropdownItem("Start-up/ business", "Start-up/ business"),
    DropdownItem("Others", "Others"),
  ];
  List<DropdownItem> jobsHindi = [
    DropdownItem("सेना", "Armed Services"),
    DropdownItem("सिविल सेवा", "Civil Services"),
    DropdownItem("शिक्षण", "Teaching"),
    DropdownItem("पुलिस", "Police officer"),
    DropdownItem("रेलवे/ बैंक", "Railway/ Bank"),
    DropdownItem("लेखपाल/ पटवारी/ तेहसीलदार", "Lekhpaal/ Patwari/ Tehsildar"),
    DropdownItem("नर्स/ आशा/ आंगनवाड़ी", "Nurse/ Asha/ Anganwadi"),
    DropdownItem("डॉक्टर/ अभियंता/ वकील ", "Doctor/ Engineer/ Lawyer"),
    DropdownItem("अकाउंटेंट/ मार्केटिंग/ डाटा एंट्री",
        "Accountant/ Marketing/ Data Entry"),
    DropdownItem("स्टार्ट-अप/ व्यवसाय ", "Start-up/ business"),
    DropdownItem("अन्य", "Others"),
  ];
  List<DropdownItem> genders = [
    DropdownItem("Male", "Male"),
    DropdownItem("Female", "Female"),
    DropdownItem("Other", "Other"),
  ];
  List<DropdownItem> language = [
    DropdownItem("English", "en"),
    DropdownItem("Hindi", "hi"),
    DropdownItem("Telugu", "te"),
  ];
  List<DropdownItem> categoriesEnglish = [
    DropdownItem("General", "General"),
    DropdownItem("SC", "SC"),
    DropdownItem("ST", "ST"),
    DropdownItem("OBC", "OBC"),
    DropdownItem("Unknown", "Unknown"),
  ];
  List<DropdownItem> categoriesHindi = [
    DropdownItem("सामान्य", "General"),
    DropdownItem("अनुसूचित जाति", "SC"),
    DropdownItem("अनुसूचित जनजाति", "ST"),
    DropdownItem("पिछड़ा वर्ग", "OBC"),
    DropdownItem("अन्य", "Unknown"),
  ];
  List<DropdownItem> parliamentDropdownItems = [];
  List<DropdownItem> assemblyDropdownItems = [];

  Future<void> setStateAssemblyConsDetailInLocalStorage(
      String stateCode, String assemblyCode, String parliamentCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('rozgarStateCode', stateCode);
    await preferences.setString('rozgarAssemblyCode', assemblyCode);
    await preferences.setString('rozgarParliamentCode', parliamentCode);
    Log.printILog('Details write in local storage');
  }

  Future<void> getStateAssemblyConsDetailInLocalStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var stateCode = await preferences.getString('rozgarStateCode');
    var assemblyCode = await preferences.getString('rozgarAssemblyCode');
    var parliamentCode = await preferences.getString('rozgarParliamentCode');

    if (assemblyCode != null && stateCode != null && parliamentCode != null) {
      selectedState =
          stateList!.firstWhere((element) => element.stateCode == stateCode);

      parliamentDropdownItems = await DbServices.db
          .getLocalNamedParliaments(stateCode: selectedState!.stateCode);
      selectedParliament = parliamentDropdownItems
          .firstWhere((element) => element.value == parliamentCode)
          .value;

      assemblyDropdownItems = await DbServices.db.getLocalNamedAssembly(
          stateCode: selectedState!.stateCode,
          loksabhaCode: selectedParliament);
      selectAssembly = assemblyDropdownItems
          .firstWhere((element) => element.value == assemblyCode)
          .value;
      Log.printILog(
          '${selectedState!.stateCode}, $selectedParliament, $selectAssembly');
    }
    Log.printILog('$stateCode, $assemblyCode, $parliamentCode');
    update();
  }

  Future<void> getStatesList() async {
    var tempStateList = await DbServices.db.getAllStates(true);
    stateList = [];
    for (var i in tempStateList) {
      if (['TS', 'U1', 'U2', 'U3'].contains(i.stateCode)) {
      } else {
        stateList!.add(i);
      }
    }
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

  Future<void> getAssemblyAndParliament() async {
    var workStateCode = selectedState!.stateCode;
    parliamentDropdownItems =
        await DbServices.db.getLocalNamedParliaments(stateCode: workStateCode);
    if (selectedDistrict != null)
      assemblyDropdownItems = await DbServices.db.getLocalNamedAssembly(
          stateCode: selectedState!.stateCode,
          loksabhaCode: selectedParliament);
    update();
  }

  void changeParliament(String parliament) async {
    selectedParliament = parliament;
    selectAssembly = null;
    assemblyDropdownItems = await DbServices.db.getLocalNamedAssembly(
        stateCode: selectedState!.stateCode, loksabhaCode: selectedParliament);
    update();
  }

  void changeAssemblySearch(String assembly) async {
    selectAssembly = assembly;
    update();
    selectAssemblyName = assemblyDropdownItems
        .firstWhere((element) => element.value == selectAssembly)
        .englishLangName;
    selectedAssemblyLocalNameSearch = assemblyDropdownItems
            .firstWhere((element) => element.value == selectAssembly)
            .localLangName ??
        "";

    selectedParliamentName = parliamentDropdownItems
        .firstWhere((element) => element.value == selectedParliament)
        .englishLangName;
    selectedParliamentLocalNameSearch = parliamentDropdownItems
            .firstWhere((element) => element.value == selectedParliament)
            .localLangName ??
        "";
    await setStateAssemblyConsDetailInLocalStorage(
        selectedState!.stateCode, selectAssembly!, selectedParliament!);
  }

  void onChangeState(States value) async {
    selectedState = value;
    selectedDistrict = null;
    selectedAssembly = null;
    update();
    await getAssemblyAndParliament();
    update();
  }

  void onChangedJob(String value) {
    selectedJob = value;
    update();
  }

  void onChangedLanguage(String value) {
    selectedLanguage = value;
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

  void changeCheckBox(bool checkbox) {
    checkBoxTicked = checkbox;
    update();
  }

  Future captureLocation(BuildContext context) async {
    ProgressDialogUtils.showProgressIndicator();
    final result = await sl<LocationProvider>().getCurrentAddress();
    ProgressDialogUtils.closeDialog();
    // close loading
    if (result is Address) {
      address = result;
      isLocationCaptured = true;
      update();
      return true;
    } else {
      CustomSnackBar.showErrorSnackBar(result);
      return false;
    }
  }

  Future getOtp(BuildContext context) async {
    ProgressDialogUtils.showProgressIndicator();
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

  Future verifyOtpForMember(BuildContext context) async {
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
    ProgressDialogUtils.showProgressIndicator();

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
        otpSend = false;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
        return false;
      }
    } else {
      otpVerified = false;
      otpSend = false;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.message.toString())));
      return false;
    }
  }

  void addCampaign(BuildContext context) async {
    if (!await captureLocation(context)) {
      CustomSnackBar.showErrorSnackBar("Location Not Enabled ");
      return;
    }
    if (!await verifyOtpForMember(context)) {
      return;
    }
    ProgressDialogUtils.showProgressIndicator();
    Map<String, String> data = {
      "NAME": "${nameController.text}",
      "MOBILE": "${mobileController.text}",
      "AGE": "${ageController.text ?? ""}",
      "GENDER": "$selectedGender",
      "RELATIVE_NAME": "",
      // "SCHEME_OPTIONS":
      // "${schemeOptionsList.reduce((value, element) => "$value,$element")}",
      "CAMPAIGN_ID": "9",
      "VERIFICATION_CODE": "${otpCodeController.text}",
      "EPIC": "${voterController.text}",
      "RECEPTION": "",
      "CITY": "${address?.locality ?? ""}",
      "STATE": "${address?.state ?? ""}",
      "ADDED_BY_ASSEMBLY": selectAssemblyName ?? "",
      "WARD_NO": "",
      "LOCATION": "${address?.formattedAddress ?? ""}",
      "INCLINATION": "${""}",
      "ASSEMBLY_CODE": "${selectAssembly ?? ""}",
      "BOOTH_MEMBER": checkBoxTicked ? "YES" : "NO",
      "FAMILY_VOTERS": "",
      "VOTER_LIST_COUNT": "",
      "STATE_CODE": "${selectedState!.stateCode}",
      "REFERRED_BY": "",
      "OCCUPATION": "$selectedJob",
      "CATEGORY": "${selectedCategory ?? ""}",
      "LATITUDE": "${address?.latitude ?? ""}",
      "LONGITUDE": "${address?.longitude ?? ""}",
      "PARLIAMENT": "${selectedParliament}",
      "EDUCATION": "${educationController.text}",
    };

    debugPrint(data.toString());
    ApiResponse apiResponse = await CampaignRepo().addCampaignData(data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        ProgressDialogUtils.closeDialog();
        Get.back();
        campaignSuccessBottomSheet();
      } else {
        Navigator.of(context).pop();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    } else {
      Navigator.of(context).pop(); // pop loading
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(apiResponse.error)));
    }
  }

  bool validateForm(BuildContext context) {
    bool validatedSuccess = true;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (mobileController.text.isEmpty || mobileController.text.length != 10) {
        CustomSnackBar.showErrorSnackBar("कृपया मोबाइल नंबर भरें");
        validatedSuccess = false;
      }
      if (otpCodeController.text.trim().isEmpty) {
        CustomSnackBar.showErrorSnackBar("Kindly fill OTP code");
        validatedSuccess = false;
      }
      if (selectAssembly == null) {
        CustomSnackBar.showErrorSnackBar("एक असेंबली चुनें");
        validatedSuccess = false;
      }
      if (selectedJob == null) {
        CustomSnackBar.showErrorSnackBar("एक असेंबली चुनें");
        validatedSuccess = false;
      }
      if (selectedCategory == null) {
        CustomSnackBar.showErrorSnackBar("एक असेंबली चुनें");
        validatedSuccess = false;
      }
      if (selectedGender == null) {
        CustomSnackBar.showErrorSnackBar("एक असेंबली चुनें");
        validatedSuccess = false;
      }
    } else {
      validatedSuccess = false;
    }

    // if (name.isEmpty) {
    //   CustomSnackBar.showErrorSnackBar("कृपया नाम भरें");
    //   validatedSuccess = false;
    // }

    // if (mobile.isEmpty && mobile.length == 10) {
    //   CustomSnackBar.showErrorSnackBar("कृपया मोबाइल नंबर भरें");
    //   validatedSuccess = false;
    // }
    // if (otpCodeController.text.trim().isEmpty) {
    //   CustomSnackBar.showErrorSnackBar("Kindly fill OTP code");
    //   validatedSuccess = false;
    // }
    // if (age.isEmpty) {
    //   CustomSnackBar.showErrorSnackBar("एक आयु चुनें");
    //   validatedSuccess = false;
    // }
    // if (selectedAssembly == null) {
    //   CustomSnackBar.showErrorSnackBar("एक असेंबली चुनें");
    //   validatedSuccess = false;
    // }

    return validatedSuccess;
  }
}
