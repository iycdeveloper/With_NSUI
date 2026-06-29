import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/repository/voters_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/home/campaign/nyay_guarantee.dart';
import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NyayGuaranteeVM extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController casteController = TextEditingController();
  TextEditingController epicIdController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController leaderMobileController = TextEditingController();

  bool isLoading = false;
  bool isLocationCaptured = false;
  String? selectedDate;
  DateTime eventDate = DateTime.now();
  List<DropdownItem> voterListOptionList = [];

  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    notifyListeners();
  }

  bool validateVoterIdAndShowPopUp(BuildContext context, bool isLangEng) {
    if (epicIdController.text.isEmpty) {
      showCustomSnackBar(
          isLangEng
              ? 'Please add the voter ID of the booth member by going to the search option.'
              : 'कृपया बूथ सदस्य का वोटर आईडी सर्च ऑप्शन में जाकर जोड़े।',
          context);
      return false;
    } else {
      return true;
    }
  }

  bool isEnglish = false;
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

  // changeInclination(val) {
  //   if (this.isShimlaCampaign) {
  //     selectedInclination = val;
  //   } else {
  //     selectedInclinations = val;
  //   }
  //   notifyListeners();
  // }
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
                element.name.toUpperCase() == voter.assembly?.toUpperCase() ||
                element.assemblyNameLocalLang == voter.assembly))
        ?.assemblyCode;

    // selectedAssemblyId = assemblyList
    // ?.firstWhereOrNull((element) =>
    //     (element.name.toUpperCase() == voter.assembly?.toUpperCase() ||
    //         element.assemblyNameLocalLang == voter.assembly))
    // ?.assemblyCode;
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

    if (await LocalStorageServices().getCgCampaignSelectedLang() == "english") {
      changeLanguage(context);
    }
    voterListOptionList = [
      DropdownItem("0", "0"),
      DropdownItem("1", "1"),
      DropdownItem("2", "2"),
      DropdownItem(isEnglish ? "More Than 2" : "2 से ज्यादा", "2 से ज्यादा")
    ];
    categoryList = [
      DropdownItem(isEnglish ? "General" : "सामान्य", "General"),
      DropdownItem(isEnglish ? "SC" : "अनुसूचित जाति", "SC"),
      DropdownItem(isEnglish ? "ST" : "अनुसूचित जनजाति", "ST"),
      //  DropdownItem("अल्पसंख्यक", "Minority"),
      DropdownItem(isEnglish ? "OBC" : "पिछड़ा वर्ग", "OBC"),
      DropdownItem(isEnglish ? "Unknown" : "अन्य", "Unknown"),
      // DropdownItem("सबसे पिछड़ा वर्ग", "MBC"),
      // DropdownItem("ख़ानाबदोश जनजाति/विमुक्त जाति और खानाबदोश जनजाति",
      //     "Nomadic tribe/VJNT")
    ];
    genders = [
      DropdownItem(isEnglish ? "Male" : "पुस्र्ष", "M"),
      DropdownItem(isEnglish ? "Female" : "महिला", "F"),
      DropdownItem(isEnglish ? "Other" : "अन्य", "O")
    ];
    partyList = [
      DropdownItem("कांग्रेस", "कांग्रेस"),
      DropdownItem("भाजपा", "भाजपा"),
      DropdownItem("निष्पक्ष", "निष्पक्ष")
    ];

    inclinationList = [
      MultiSelectItem(
          "ज़रूरतमंद महिलाओं को सालाना ₹ 1 लाख",
          isEnglish
              ? "Needy women to receive an annual assistance of ₹ 1 Lakh "
              : "ज़रूरतमंद महिलाओं को सालाना ₹ 1 लाख"),
      MultiSelectItem(
          "केंद्र सरकार में नई भर्तियों में 50% महिला आरक्षण। आशा, आँगनबाड़ी, मिड-डे-मिल वर्कर का मानदेय दुगुना",
          isEnglish
              ? "50% women’s Reservations in all new central government recruitments and doubling of honorarium for ASHA, aanganawaadi, and Mid-day Meal workers"
              : "केंद्र सरकार में नई भर्तियों में 50% महिला आरक्षण। आशा, आँगनबाड़ी, मिड-डे-मिल वर्कर का मानदेय दुगुना"),
      MultiSelectItem(
          "पेपर लीक से मुक्ति (20 हज़ार मुआवजा/ उम्र-सीमा में छूट)",
          isEnglish
              ? "No Paper Leak ( ₹ 20,000 Compensation and age relaxations) "
              : "पेपर लीक से मुक्ति (20 हज़ार मुआवजा/ उम्र-सीमा में छूट)"),
      MultiSelectItem(
          "30 लाख सरकारी नौकरियों में भर्ती, वार्षिक ₹ 1 लाख का भत्ता",
          isEnglish
              ? "Recruitment of 30 Lakhs Government Jobs and annual ₹ 1 Lakh annual allowance"
              : "30 लाख सरकारी नौकरियों में भर्ती, वार्षिक ₹ 1 लाख का भत्ता"),
      MultiSelectItem(
          "MSP की लीगल गारंटी का क़ानून",
          isEnglish
              ? "Legal Guarantee of MSP"
              : "MSP की लीगल गारंटी का क़ानून"),
      MultiSelectItem(
          "किसान क़र्ज़ा माफ़ी आयोग के गठन से ऋण माफ़ी",
          isEnglish
              ? "Loan waiver through formation of farmer debt relief commission "
              : "किसान क़र्ज़ा माफ़ी आयोग के गठन से ऋण माफ़ी"),
      MultiSelectItem(
          "मुफ़्त जाँच, दवा एवं इलाज और असंगठित श्रमिकों के लिए जीवन/ दुर्घटना बीमा",
          isEnglish
              ? "Free check-ups, medicine, treatment, and life/accident insurance for unorganized laborers"
              : "मुफ़्त जाँच, दवा एवं इलाज और असंगठित श्रमिकों के लिए जीवन/ दुर्घटना बीमा"),
      MultiSelectItem(
          "₹ 400/ प्रतिदीन राष्ट्रीय न्यूनतम मज़दूरी एवं शहरी क्षेत्रों के लिए रोज़गार गारंटी अधिनियम",
          isEnglish
              ? "₹400/day National Minimum Wage and Employment Guarantee Act for urban areas."
              : "₹ 400/ प्रतिदीन राष्ट्रीय न्यूनतम मज़दूरी एवं शहरी क्षेत्रों के लिए रोज़गार गारंटी अधिनियम"),
      MultiSelectItem(
          "व्यापक सामाजिक/ आर्थिक/ जाति जनगणना",
          isEnglish
              ? "Extensive social/economic/caste census"
              : "व्यापक सामाजिक/ आर्थिक/ जाति जनगणना"),
      MultiSelectItem(
          "SC/ST/OBC आरक्षण पर 50% आरक्षण सीमा हटेगी",
          isEnglish
              ? "Removal of 50% reservation cap on SC/ST/OBC reservations."
              : "SC/ST/OBC आरक्षण पर 50% आरक्षण सीमा हटेगी"),
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

    // await getAssemblyList();
    await getStateList();
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
      showCustomSnackBar(isEnglish ? "Name empty" : "कृपया नाम भरें", context);
      validatedSuccess = false;
    }

    if (mobileController.text.trim().isEmpty) {
      showCustomSnackBar(
          isEnglish ? "mobile number invalid" : "कृपया मोबाइल नंबर भरें",
          context);
      validatedSuccess = false;
    }
    if (otpCodeController.text.trim().isEmpty) {
      showCustomSnackBar(
          isEnglish
              ? "Registration code invalid"
              : "कृपया रजिस्ट्रेशन कोड भरें",
          context);
      validatedSuccess = false;
    }
    if (selectedAge == null) {
      showCustomSnackBar(
          isEnglish ? "Age is empty" : "कृपया उम्र चुनें", context);
      validatedSuccess = false;
    }
    if (stateCode == null) {
      showCustomSnackBar(
          isEnglish ? "State not selected" : "State not selected", context);
      validatedSuccess = false;
    }
    if (selectedParliamentCode == null) {
      showCustomSnackBar(
          isEnglish ? "Parliament not selected" : "Parliament not selected", context);
      validatedSuccess = false;
    }
    if (selectedAssemblyCode == null) {
      showCustomSnackBar(
          isEnglish ? "Assembly not selected" : "एक असेंबली चुनें", context);
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


  List<States>? stateList;
  List<DropdownItem>? stateListDropdown;
  String? stateCode;
  getStateList() async {
    stateList = await DbServices.db.getAllStates();
    if (stateList != null && stateList!.isNotEmpty)
      stateListDropdown = List.generate(
          stateList!.length,
          (index) => DropdownItem(
              stateList![index].name, stateList![index].stateCode));
  }
  void changeState(String val){
    Log.printDLog('Selected state code $stateCode');
    stateCode = val;
    getAssemblyParliament();
    notifyListeners();
  }

  List<DropdownItem> parliamentDropdown = [];
  List<DropdownItem> assemblyDropdown = [];
  String? selectedParliamentCode;
  String? selectedAssemblyCode;

  getAssemblyParliament() async {
    var workStateCode = stateCode;

    parliamentDropdown =
    await DbServices.db.getLocalNamedParliaments(stateCode: workStateCode);
    notifyListeners();
  }

  onChangeParliament(val) async{
    selectedParliamentCode = val;
    notifyListeners();
    await getAssemblyList();
  }

  bool shouldPickAssembly = false;
  String? selectedAssemblyName;
  List<Assembly>? assemblyList;
  List<DropdownItem>? assemblyDropDownList;
  getAssemblyList() async {
    Log.printDLog('Selected Parliament $selectedParliamentCode');
    if (selectedParliamentCode != null)
      assemblyDropdown = await DbServices.db.getLocalNamedAssembly(
          stateCode: stateCode,
          loksabhaCode: selectedParliamentCode);
    Log.printDLog('Assembly count ${assemblyDropdown.length}');
    notifyListeners();
  }
  changeAssembly(val) {
    selectedAssemblyCode = val;
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
                value: context.read<NyayGuaranteeVM>(),
                child: Consumer<NyayGuaranteeVM>(
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

    showNetworkLoadingDialog(context);
    var schemeOptionsList =
        inclinationMap.entries.map((e) => "${e.key}-${e.value ?? ""}").toList();
    var familyVotersSelected = votersList
        .where((e) => e.selectedFamilyVoterOption != null)
        .toList()
        .map((e) => "${e.voterId}-${e.selectedFamilyVoterOption}")
        .toList();
    
    Log.printDLog("parliament code $selectedParliamentCode  Assembly code $selectedAssemblyCode");

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
      "ASSEMBLY_CODE": "${selectedAssemblyCode  ?? ""}",
      "PARLIAMENT_CODE": "${selectedParliamentCode  ?? ""}",
      "BOOTH_MEMBER": "${checkBoxTicked ? "YES" : "NO"}",
      "FAMILY_VOTERS":
          "${familyVotersSelected.isNotEmpty ? familyVotersSelected.reduce((value, element) => "$value,$element") : ""}",
      "VOTER_LIST_COUNT": "${selectedVoterListOption ?? ""}",
      "STATE_CODE": "${stateCode}",
      "OCCUPATION": "${jobController.text}",
      "REFERRED_BY": "${leaderMobileController.text}",
      "CATEGORY": "${selectedCategory ?? ""}",
      "LATITUDE": "${address?.latitude ?? ""}",
      "LONGITUDE": "${address?.longitude ?? ""}",
      "CASTE": "${casteController.text}",
      "DOB": "${selectedDate ?? ""}"
    };
    Log.printDLog(data);

    ApiResponse apiResponse = await CampaignRepo().addCampaignData(data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
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
              create: (context) => NyayGuaranteeVM(),
              child: NyayGuaranteeCampaign(
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
      LocalStorageServices().setCgCampaignSelectedLang("hindi");
    } else {
      isEnglish = true;
      LocalStorageServices().setCgCampaignSelectedLang("english");
    }

    genders = [
      DropdownItem(isEnglish ? "Male" : "पुस्र्ष", "M"),
      DropdownItem(isEnglish ? "Female" : "महिला", "F"),
      DropdownItem(isEnglish ? "Other" : "अन्य", "O")
    ];

    inclinationList = [
      MultiSelectItem(
          "ज़रूरतमंद महिलाओं को सालाना ₹ 1 लाख",
          isEnglish
              ? "Needy women to receive an annual assistance of ₹ 1 Lakh "
              : "ज़रूरतमंद महिलाओं को सालाना ₹ 1 लाख"),
      MultiSelectItem(
          "केंद्र सरकार में नई भर्तियों में 50% महिला आरक्षण। आशा, आँगनबाड़ी, मिड-डे-मिल वर्कर का मानदेय दुगुना",
          isEnglish
              ? "50% women’s Reservations in all new central government recruitments and doubling of honorarium for ASHA, aanganawaadi, and Mid-day Meal workers"
              : "केंद्र सरकार में नई भर्तियों में 50% महिला आरक्षण। आशा, आँगनबाड़ी, मिड-डे-मिल वर्कर का मानदेय दुगुना"),
      MultiSelectItem(
          "पेपर लीक से मुक्ति (20 हज़ार मुआवजा/ उम्र-सीमा में छूट)",
          isEnglish
              ? "No Paper Leak ( ₹ 20,000 Compensation and age relaxations) "
              : "पेपर लीक से मुक्ति (20 हज़ार मुआवजा/ उम्र-सीमा में छूट)"),
      MultiSelectItem(
          "30 लाख सरकारी नौकरियों में भर्ती, वार्षिक ₹ 1 लाख का भत्ता",
          isEnglish
              ? "Recruitment of 30 Lakhs Government Jobs and annual ₹ 1 Lakh annual allowance"
              : "30 लाख सरकारी नौकरियों में भर्ती, वार्षिक ₹ 1 लाख का भत्ता"),
      MultiSelectItem(
          "MSP की लीगल गारंटी का क़ानून",
          isEnglish
              ? "Legal Guarantee of MSP"
              : "MSP की लीगल गारंटी का क़ानून"),
      MultiSelectItem(
          "किसान क़र्ज़ा माफ़ी आयोग के गठन से ऋण माफ़ी",
          isEnglish
              ? "Loan waiver through formation of farmer debt relief commission "
              : "किसान क़र्ज़ा माफ़ी आयोग के गठन से ऋण माफ़ी"),
      MultiSelectItem(
          "मुफ़्त जाँच, दवा एवं इलाज और असंगठित श्रमिकों के लिए जीवन/ दुर्घटना बीमा",
          isEnglish
              ? "Free check-ups, medicine, treatment, and life/accident insurance for unorganized laborers"
              : "मुफ़्त जाँच, दवा एवं इलाज और असंगठित श्रमिकों के लिए जीवन/ दुर्घटना बीमा"),
      MultiSelectItem(
          "₹ 400/ प्रतिदीन राष्ट्रीय न्यूनतम मज़दूरी एवं शहरी क्षेत्रों के लिए रोज़गार गारंटी अधिनियम",
          isEnglish
              ? "₹400/day National Minimum Wage and Employment Guarantee Act for urban areas."
              : "₹ 400/ प्रतिदीन राष्ट्रीय न्यूनतम मज़दूरी एवं शहरी क्षेत्रों के लिए रोज़गार गारंटी अधिनियम"),
      MultiSelectItem(
          "व्यापक सामाजिक/ आर्थिक/ जाति जनगणना",
          isEnglish
              ? "Extensive social/economic/caste census"
              : "व्यापक सामाजिक/ आर्थिक/ जाति जनगणना"),
      MultiSelectItem(
          "SC/ST/OBC आरक्षण पर 50% आरक्षण सीमा हटेगी",
          isEnglish
              ? "Removal of 50% reservation cap on SC/ST/OBC reservations."
              : "SC/ST/OBC आरक्षण पर 50% आरक्षण सीमा हटेगी"),
    ];

    categoryList = [
      DropdownItem(isEnglish ? "General" : "सामान्य", "General"),
      DropdownItem(isEnglish ? "SC" : "अनुसूचित जाति", "SC"),
      DropdownItem(isEnglish ? "ST" : "अनुसूचित जनजाति", "ST"),
      DropdownItem(isEnglish ? "Minorities" : "अल्प-संख्यक", "Minorities"),
      DropdownItem(isEnglish ? "OBC" : "पिछड़ा वर्ग", "OBC"),
      DropdownItem(isEnglish ? "Unknown" : "अन्य", "Unknown"),
      // DropdownItem("सबसे पिछड़ा वर्ग", "MBC"),
      // DropdownItem("ख़ानाबदोश जनजाति/विमुक्त जाति और खानाबदोश जनजाति",
      //     "Nomadic tribe/VJNT")
    ];

    voterListOptionList = [
      DropdownItem("0", "0"),
      DropdownItem("1", "1"),
      DropdownItem("2", "2"),
      DropdownItem(isEnglish ? "More Than 2" : "2 से ज्यादा", "2 से ज्यादा")
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

  void changeCategory(value) {
    selectedCategory = value;
    notifyListeners();
  }

  String? selectedCategory;

  List<DropdownItem> categoryList = [];

  void changeVoterListOption(value) {
    selectedVoterListOption = value;
    notifyListeners();
  }

  String? selectedVoterListOption;

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

  // String? selectedParliamentCode;
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
      CustomSnackBar.showWarningSnackBar("Work state is not assigned to user");
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

  // getAssemblyList() async {
  //   if (selectedParliamentCode != null)
  //     assemblyDropdownItems = await DbServicesVoter.db.getLocalNamedAssembly(
  //         stateCode: await LocalStorageServices().getWorkStateCode(),
  //         loksabhaCode: selectedParliamentCode);
  //   ;
  //   notifyListeners();
  //   return true;
  // }

  // getParliamentList() async {
  //   parliamentDropdownItems = await DbServicesVoter.db.getDistrictDropDown(
  //       stateCode: await LocalStorageServices().getWorkStateCode());
  //   return true;
  // }

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

    langCode = isEnglish ? 'EN' : 'HI';

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
