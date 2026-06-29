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
import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/screens/ui/home/campaign/add_campaign_tl.dart';
import 'package:iyc/screens/ui/home/yuva_booth/search_voters_list.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:collection/collection.dart';

class AddCampaignTLVM extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  TextEditingController epicIdController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  List<int> selectedYesOrNo = [];

  onClickCheckBox(int index) {
    if (selectedYesOrNo.contains(index)) {
      selectedYesOrNo.remove(index);
    } else {
      selectedYesOrNo.add(index);
    }

    notifyListeners();
  }

  bool isLoading = true;
  bool isLocationCaptured = false;

  String? selectedGender;
  String? selectedAge;
  late String campaignId;

  String? selectedAssemblyId;

  bool validateVoterIdAndShowPopUp(BuildContext context, bool isLangEng) {
    if (epicIdController.text.isEmpty) {
      showCustomSnackBar(
          isLangEng
              ? 'Please add the voter ID of the booth member by going to the search option.'
              : 'Please add the voter ID of the booth member by going to the search option.',
          context);
      return false;
    } else {
      return true;
    }
  }

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

  String? selectedInclination;
  double rating = 2.5;

  bool otpSend = false;
  bool otpVerified = false;

  final FocusNode mobileFocus = FocusNode();
  final FocusNode campaignCodeFocus = FocusNode();
  final FocusNode otpCodeFocus = FocusNode();

  bool isEnglish = false;

  late List<DropdownItem> genders;

  late List<DropdownItem> inclinations;
  late List<DropdownItem> partyList;

  late List<DropdownItem> ageList;

  List<DropdownItem> categoryList = [];

  String? selectedParty;

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

  void changeCategory(value) {
    selectedCategory = value;
    notifyListeners();
  }

  String? selectedCategory;

  changeInclination(val) {
    if (this.isShimlaCampaign) {
      selectedInclination = val;
    } else {
      selectedInclinations = val;
    }
    notifyListeners();
  }

  bool isVoterFamilySearchable = false;

  void updateUserData(Voter voter) {
    nameController.text = voter.name;
    isVoterFamilySearchable = true;
    relativeNameController.text = voter.fatherOrHusbandName;
    //   idCardNumberController.text = voter.voterId;
    selectedGender =
        (voter.gender == "Male" || voter.gender == "M") ? "M" : "F";
    selectedAge = voter.age;
    selectedAssemblyId = assemblyList
        ?.firstWhereOrNull((element) =>
            (element.assemblyNameLocalLang == voter.assembly ||
                element.name == voter.assembly))
        ?.assemblyCode;
    notifyListeners();
    selectedAssemblyName = assemblyList
        ?.firstWhereOrNull(
            (element) => element.assemblyCode == selectedAssemblyId)
        ?.name;
    epicIdController.text = voter.voterId;
  }

  bool isShimlaCampaign = false;

  List<DropdownItem> declarerList = [];

  Future<void> initAddCampaign(BuildContext context, String campaignId, {bool? isShimlaCampaign}) async {
    this.campaignId = campaignId;
    if (await LocalStorageServices().getTlCampaignSelectedLang() == "english") {
      changeLanguage(context);
    }
    declarerList = [
      DropdownItem(
          isEnglish
              ? "Verification: Voter at Home"
              : "ధృవీకరణ: ఓటరు ఇంట్లోనే ఉన్నారు",
          "Verification: Voter at Home"),
      DropdownItem(
          isEnglish
              ? "Verification: Voter no longer stays at home"
              : "ధృవీకరణ: ఓటరు ఇకపై ఇంట్లో ఉండరు",
          "Verification: Voter no longer stays at home"),
      DropdownItem(isEnglish ? "Deceased" : "మరణించారు", "Deceased"),
      DropdownItem(isEnglish ? "Fake / Unverified" : "నకిలీ / ధృవీకరించబడలేదు",
          "Fake / Unverified"),
    ];
    voterListOptionList = [
      DropdownItem("0", "0"),
      DropdownItem("1", "1"),
      DropdownItem("2", "2"),
      DropdownItem(
          isEnglish ? "More than 2" : "ఒకటి కన్నా ఎక్కువ", "More than 2")
    ];
    genders = [
      DropdownItem(isEnglish ? "Male" : "పురుష", "M"),
      DropdownItem(isEnglish ? "Female" : "స్త్రీ", "F"),
      DropdownItem(isEnglish ? "Other" : "ఇతర", "O"),
    ];
    partyList = [
      DropdownItem("Congress", isEnglish ? "Congress" : "-కాంగ్రెస్"),
      DropdownItem("BRS", isEnglish ? "BRS" : "బీఆర్ ఎస్"),
      DropdownItem("BJP", isEnglish ? "BJP" : "బిజేపి"),//AIMIM
      DropdownItem("AIMIM", isEnglish ? "AIMIM" : "AIMIM"),//
      DropdownItem(isEnglish ? "OTHERS" : "ఇతరులు", "OTHERS",),
      DropdownItem("NEUTRAL", isEnglish ? "NEUTRAL" : "తటస్తం"),
    ];
    categoryList = [
      DropdownItem(isEnglish ? "SC" : "షెడ్యూల్డ్ కులం", "SC"),
      DropdownItem(isEnglish ? "ST" : "షెడ్యూల్డ్ తెగలు/ గిరిజన", "ST"),
      DropdownItem(
        isEnglish ? "OBC" : "ఇతర పిఛుపడా వర్గం",
        "OBC",
      ),
      DropdownItem(
        isEnglish ? "GENERAL" : "సాధారణ వర్గం",
        "GENERAL",
      ),
      DropdownItem(
        isEnglish ? "Minority" : "అల్పసంఖ్య",
        "Minority",
      ),
      DropdownItem(
        isEnglish ? "MBC" : "అత్యంత వెనుకబడిన వర్గం",
        "MBC",
      ),
      DropdownItem(
        isEnglish
            ? "Nomadic Tribe/ VJNT"
            : "సంచార జాతులు/ విముక్త జాతి సంచార తెగలు",
        "Nomadic Tribe/ VJNT",
      ),
      DropdownItem(
        isEnglish ? "UNKNOWN" : "తెలియని",
        "UNKNOWN",
      ),
    ];
    inclinationList = [
      MultiSelectItem(
        "Mahalaxmi",
        isEnglish
            ? """Mahalaxmi
     • Financial assistance of Rs. 2500 per month for women.
     • Gas cylinder only for Rs 500.  
     • Free travel for women across the state in RTC Buses."""
            : """మహాలక్ష్మీ
      •  మహిళలకు ప్రతి నెల 2500 ఆర్ధిక సహాయం.
      •  రూ.500 లకే గ్యాస్ సిలిండర్.
      •  ఆర్టీసీ బస్సుల్లో మహిళలకు రాష్ట్ర వ్యాప్తంగా ఉచిత ప్రయాణం.""",
      ),
      MultiSelectItem(
        "Rythu Bharosa ",
        isEnglish
            ? """Rythu Bharosa
   •  Rs. 15,000 financial assistance per year for Farmers and Tenant Farmers.
   •  Rs. 12,000 financial assistance per year for Agricultural Labourers.
   •  Bonus of Rs.500 per quintal for paddy crop. """
            : """రైతు భరోసా
   •  రైతులు, కౌలు రైతులకు ఏటా రూ.15 వేల పంట పెట్టుబడి సాయం
   •  వ్యవసాయ కూలీలకు ఏడాదికి రూ.12 వేల సాయం.
   •  వరి పంటకు ప్రతి క్వింటాల్ కు రూ.500 బోనస్.""",
      ),
      MultiSelectItem(
        "Gruha Jyothi",
        isEnglish
            ? """Gruha Jyothi
    •  Free electricity up to 200 units for all households."""
            : """గ్రుహ జ్యోతి
    •  ప్రతి కుటుంబానికి 200 యూనిట్ల వరకు ఉచిత కరెంటు. """,
      ),
      MultiSelectItem(
        "Indiramma Indlu",
        isEnglish
            ? """Indiramma Indlu
    •  House site and 5 lakhs for people not having own house.
    •  250 sq. yard plot for all Telangana Movement Fighters."""
            : """ఇందిరమ్మ ఇండ్లు
    •  ఇల్లు లేని వారికి ఇంటి స్థలం & 5 లక్షలు.
    •  ఉద్యమకారుల కుటుంబాలకు 250 చ.గజాల ఇంటి స్థలం """,
      ),
      MultiSelectItem(
        "Yuva Vikasam",
        isEnglish
            ? """Yuva Vikasam
    •  Vidya Bharosa Card worth Rs. 5 lakhs for students.
    • Telangana International Schools in every Mandal."""
            : """యవ వికాసం
    •  విద్యార్థులకు ₹5 లక్షల విద్యా భరోసా కార్డు.
    •  ప్రతీ మండలంలో తెలంగాణ ఇంటర్నేషనల్ స్కూల్స్.""",
      ),
      MultiSelectItem(
        "Cheyutha ",
        isEnglish
            ? """Cheyutha
    •  Rs. 4000 pension every month.
    •  Rs. 10 lakh Rajiv Arogyasri Insurance. """
            : """చేయూత
    •  నెలకు రూ.4 వేల పింఛన్
    •  రూ. 10 లక్షల రాజీవ్ ఆరోగ్య శ్రీ భీమా
    """,
      ),
    ];


    inclinations = [
      DropdownItem("क्लीन ग्रीन व सुव्यवस्थित शिमला शहर।",
          "क्लीन ग्रीन व सुव्यवस्थित शिमला शहर।"),
      DropdownItem(
          "निर्विघ्न स्वच्छ जल आपूर्ति।", "निर्विघ्न स्वच्छ जल आपूर्ति।"),
      DropdownItem("पार्क, पार्किंग व सामुदायिक केंद्र।",
          "पार्क, पार्किंग व सामुदायिक केंद्र।"),
      DropdownItem("नशा मुक्ति की ओर कदम।", "नशा मुक्ति की ओर कदम।"),
      DropdownItem("एम्बुलेंस मार्ग, सुचारू सार्वजनिक परिवहन व्यवस्था",
          "एम्बुलेंस मार्ग, सुचारू सार्वजनिक परिवहन व्यवस्था"),
      DropdownItem("वेलनेस सेंटर।", "वेलनेस सेंटर।"),
      DropdownItem("इंडोर स्टेडियम।", "इंडोर स्टेडियम।"),
      DropdownItem("शहरी गरीब व्यक्तियों को आवास योजना।",
          "शहरी गरीब व्यक्तियों को आवास योजना।"),
      DropdownItem("डि-कंजशन से छुटकारा व व्यापारियों को राहत।",
          "डि-कंजशन से छुटकारा व व्यापारियों को राहत।"),
      DropdownItem("स्वास्थ्य क्षेत्र का विस्तारीकरण।",
          "स्वास्थ्य क्षेत्र का विस्तारीकरण।"),
      DropdownItem("महिलाओं के उत्थान के लिए कौशल विकास केंद्र।",
          "महिलाओं के उत्थान के लिए कौशल विकास केंद्र।"),
      DropdownItem("विद्युत सेवाएँ।", "विद्युत सेवाएँ।"),
      DropdownItem("पर्यटन विकास।", "पर्यटन विकास।"),
      DropdownItem(
          "शिक्षा सुदृढ़ीकरण व पुस्तकालय।", "शिक्षा सुदृढ़ीकरण व पुस्तकालय।"),
    ];

    ageList = List.generate(
        81, (index) => DropdownItem("${index + 18}", "${index + 18}"));

    isLoading = false;
    notifyListeners();

    boothListDropDown = List.generate(
        500, (index) => DropdownItem("वार्ड ${index + 1}", "${index + 1}"));
    getAssemblyList();
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

    // if (selectedGender == null) {
    //   showCustomSnackBar("Select Gender", context);
    //   validatedSuccess = false;
    // }
    // if ((isShimlaCampaign && selectedInclination == null) ||
    //     (!isShimlaCampaign && selectedInclinations.isEmpty)) {
    //   showCustomSnackBar(
    //       isShimlaCampaign ? "उत्तर चुनें" : "Select a Promises", context);
    //   validatedSuccess = false;
    // }
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
              (assemblyList![index].assemblyNameLocalLang?.trim().isNotEmpty ??
                      false)
                  ? "${assemblyList![index].name} (${assemblyList![index].assemblyNameLocalLang})"
                  : assemblyList![index].name,
              assemblyList![index].assemblyCode,
              englishLangName: assemblyList![index].name,
              localLangName: assemblyList![index].assemblyNameLocalLang));
    notifyListeners();
    return true;
  }

  changeAssembly(val) {
    if (val != null) selectedAssemblyId = val;
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
                value: context.read<AddCampaignTLVM>(),
                child: Consumer<AddCampaignTLVM>(
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
    Map<String, String> data = {
      "NAME": "${nameController.text}",
      "MOBILE": "${mobileController.text}",
      "AGE": "${selectedAge}",
      "GENDER": "$selectedGender",
      "RELATIVE_NAME": "${relativeNameController.text}",
      "SCHEME_OPTIONS":this.isShimlaCampaign
          ? "$selectedInclination"
          : "${selectedInclinations.reduce((value, element) => "$value,$element")}",

      "CAMPAIGN_ID": "${campaignId}",
      "CAMPAIGN_CODE": "${otpCodeController.text}",
      "RECEPTION": "$rating",
      "EPIC": "${epicIdController.text}",
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
      "CATEGORY": "${selectedCategory ?? ""}",
      "STATE_CODE": "${await LocalStorageServices().getWorkStateCode()}",
      "VOTER_LIST_COUNT": "${selectedVoterListOption ?? ""}",
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
              create: (context) => AddCampaignTLVM(),
              child: AddCampaignTL(
                  campaignId: campaignId, isShimlaCampaign: isShimlaCampaign),
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
      LocalStorageServices().setTlCampaignSelectedLang("telungu");
    } else {
      isEnglish = true;
      LocalStorageServices().setTlCampaignSelectedLang("english");
    }

    genders = [
      DropdownItem(isEnglish ? "Male" : "పురుష", "M"),
      DropdownItem(isEnglish ? "Female" : "స్త్రీ", "F"),
      DropdownItem(isEnglish ? "Other" : "ఇతర", "O"),
    ];
    partyList = [
      DropdownItem(isEnglish ? "Congress" : "-కాంగ్రెస్", "Congress"),
      DropdownItem(
        isEnglish ? "BRS" : "బీఆర్ ఎస్",
        "BRS",
      ),
      DropdownItem(
        isEnglish ? "BJP" : "బిజేపి",
        "BJP",
      ),
      DropdownItem(
        isEnglish ? "OTHERS" : "ఇతరులు",
        "OTHERS",
      ),
      DropdownItem(
        isEnglish ? "NEUTRAL" : "తటస్తం",
        "NEUTRAL",
      ),
    ];
    categoryList = [
      DropdownItem(isEnglish ? "SC" : "షెడ్యూల్డ్ కులం", "SC"),
      DropdownItem(isEnglish ? "ST" : "షెడ్యూల్డ్ తెగలు/ గిరిజన", "ST"),
      DropdownItem(
        isEnglish ? "OBC" : "ఇతర పిఛుపడా వర్గం",
        "OBC",
      ),
      DropdownItem(
        isEnglish ? "GENERAL" : "సాధారణ వర్గం",
        "GENERAL",
      ),
      DropdownItem(
        isEnglish ? "Minority" : "అల్పసంఖ్య",
        "Minority",
      ),
      DropdownItem(
        isEnglish ? "MBC" : "అత్యంత వెనుకబడిన వర్గం",
        "MBC",
      ),
      DropdownItem(
        isEnglish
            ? "Nomadic Tribe/ VJNT"
            : "సంచార జాతులు/ విముక్త జాతి సంచార తెగలు",
        "Nomadic Tribe/ VJNT",
      ),
      DropdownItem(
        isEnglish ? "UNKNOWN" : "తెలియని",
        "UNKNOWN",
      ),
    ];
    inclinationList = [
      MultiSelectItem(
        "Mahalaxmi",
        isEnglish
            ? """Mahalaxmi
     • Financial assistance of Rs. 2500 per month for women.
     • Gas cylinder only for Rs 500.  
     • Free travel for women across the state in RTC Buses."""
            : """
  మహాలక్ష్మీ
      •  మహిళలకు ప్రతి నెల 2500 ఆర్ధిక సహాయం.
      •  రూ.500 లకే గ్యాస్ సిలిండర్.
      •  ఆర్టీసీ బస్సుల్లో మహిళలకు రాష్ట్ర వ్యాప్తంగా ఉచిత ప్రయాణం.""",
      ),
      MultiSelectItem(
        "Rythu Bharosa ",
        isEnglish
            ? """Rythu Bharosa
   •  Rs. 15,000 financial assistance per year for Farmers and Tenant Farmers.
   •  Rs. 12,000 financial assistance per year for Agricultural Labourers.
   •  Bonus of Rs.500 per quintal for paddy crop. """
            : """రైతు భరోసా
   •  రైతులు, కౌలు రైతులకు ఏటా రూ.15 వేల పంట పెట్టుబడి సాయం
   •  వ్యవసాయ కూలీలకు ఏడాదికి రూ.12 వేల సాయం.
   •  వరి పంటకు ప్రతి క్వింటాల్ కు రూ.500 బోనస్.""",
      ),
      MultiSelectItem(
        "Gruha Jyothi",
        isEnglish
            ? """Gruha Jyothi
    •  Free electricity up to 200 units for all households."""
            : """గ్రుహ జ్యోతి
    •  ప్రతి కుటుంబానికి 200 యూనిట్ల వరకు ఉచిత కరెంటు. """,
      ),
      MultiSelectItem(
        "Indiramma Indlu",
        isEnglish
            ? """Indiramma Indlu
    •  House site and 5 lakhs for people not having own house.
    •  250 sq. yard plot for all Telangana Movement Fighters."""
            : """ఇందిరమ్మ ఇండ్లు
    •  ఇల్లు లేని వారికి ఇంటి స్థలం & 5 లక్షలు.
    •  ఉద్యమకారుల కుటుంబాలకు 250 చ.గజాల ఇంటి స్థలం """,
      ),
      MultiSelectItem(
        "Yuva Vikasam",
        isEnglish
            ? """Yuva Vikasam
    •  Vidya Bharosa Card worth Rs. 5 lakhs for students.
    • Telangana International Schools in every Mandal."""
            : """యవ వికాసం
    •  విద్యార్థులకు ₹5 లక్షల విద్యా భరోసా కార్డు.
    •  ప్రతీ మండలంలో తెలంగాణ ఇంటర్నేషనల్ స్కూల్స్.""",
      ),
      MultiSelectItem(
        "Cheyutha ",
        isEnglish
            ? """Cheyutha
    •  Rs. 4000 pension every month.
    •  Rs. 10 lakh Rajiv Arogyasri Insurance. """
            : """చేయూత
    •  నెలకు రూ.4 వేల పింఛన్
    •  రూ. 10 లక్షల రాజీవ్ ఆరోగ్య శ్రీ భీమా
    """,
      ),
    ];

    // inclinationMap.addEntries(inclinationList
    //     .map((e) => e.value)
    //     .toList()
    //     .map((e) => MapEntry(e, null)));

    print("TL is working");
    print(inclinationMap);

    voterListOptionList = [
      DropdownItem("0", "0"),
      DropdownItem("1", "1"),
      DropdownItem("2", "2"),
      DropdownItem(
          isEnglish ? "More than 2" : "ఒకటి కన్నా ఎక్కువ", "More than 2")
    ];

    declarerList = [
      DropdownItem(
          isEnglish
              ? "Verification: Voter at Home"
              : "ధృవీకరణ: ఓటరు ఇంట్లోనే ఉన్నారు",
          "Verification: Voter at Home"),
      DropdownItem(
          isEnglish
              ? "Verification: Voter no longer stays at home"
              : "ధృవీకరణ: ఓటరు ఇకపై ఇంట్లో ఉండరు",
          "Verification: Voter no longer stays at home"),
      DropdownItem(isEnglish ? "Deceased" : "మరణించారు", "Deceased"),
      DropdownItem(isEnglish ? "Fake / Unverified" : "నకిలీ / ధృవీకరించబడలేదు",
          "Fake / Unverified"),
    ];
    notifyListeners();
  }

  String? selectedWard;

  void changeWard(value) {
    selectedWard = value;
    notifyListeners();
  }

  void changeParty(value) {
    selectedParty = value;
    notifyListeners();
  }

  bool checkBoxTicked = false;

  void changeCheckBox(bool checkbox) {
    checkBoxTicked = checkbox;
    notifyListeners();
  }

  void VoterListOption(value) {
    selectedVoterListOption = value;
    notifyListeners();
  }

  String? selectedVoterListOption;

  List<DropdownItem>? voterListOptionList;

  void changeDeclare(value) {
    selectedDeclarer = value;
    notifyListeners();
  }

  String? selectedDeclarer;

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

    langCode = isEnglish ? 'EN' : 'TI';

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
