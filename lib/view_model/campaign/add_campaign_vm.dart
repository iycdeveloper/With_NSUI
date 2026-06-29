import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/voter.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/screens/ui/home/campaign/add_campaign.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/dropdown/dropdown_picker.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddCampaignVM extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController relativeNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  // TextEditingController epicIdController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  bool isLoading = false;
  bool isLocationCaptured = false;

  String? selectedGender;
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
  final FocusNode campaignCodeFocus = FocusNode();
  final FocusNode otpCodeFocus = FocusNode();

  bool isEnglish = true;

  late List<DropdownItem> genders;

  late List<DropdownItem> inclinations;

  late List<DropdownItem> ageList;

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
    if (this.isShimlaCampaign) {
      selectedInclination = val;
    } else {
      selectedInclinations = val;
    }
    notifyListeners();
  }

  void updateUserData(Voter voter) {
    nameController.text = voter.name;
    relativeNameController.text = voter.fatherOrHusbandName;
    //   idCardNumberController.text = voter.voterId;
    selectedGender = voter.gender == "Male" ? "M" : "F";
    notifyListeners();
  }

  bool isShimlaCampaign = false;
  void initAddCampaign(BuildContext context, String campaignId,
      {bool? isShimlaCampaign}) {
    this.campaignId = campaignId;

    isLoading = true;
    if (isShimlaCampaign != null) {
      this.isShimlaCampaign = isShimlaCampaign;
      if (isShimlaCampaign) isEnglish = false;
    }

    genders = this.isShimlaCampaign
        ? [
            DropdownItem("पुस्र्ष", "M"),
            DropdownItem("महिला", "F"),
            DropdownItem("और", "O")
          ]
        : [
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
    // notifyListeners();

    boothListDropDown = List.generate(
        500, (index) => DropdownItem("वार्ड ${index + 1}", "${index + 1}"));
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
    if (relativeNameController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill Father or Husband Name", context);
      validatedSuccess = false;
    }

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
    if ((isShimlaCampaign && selectedInclination == null) ||
        (!isShimlaCampaign && selectedInclinations.isEmpty)) {
      showCustomSnackBar(
          isShimlaCampaign ? "उत्तर चुनें" : "Select a Promises", context);
      validatedSuccess = false;
    }
    if (selectedAge == null) {
      showCustomSnackBar("Select an Age", context);
      validatedSuccess = false;
    }

    return validatedSuccess;
  }

  Address? address;
  captureLocation(BuildContext context) async {
    showNetworkLoadingDialog(context);
    address = await sl<LocationProvider>().getCurrentAddress();

    Navigator.of(context).pop(); // close loading
    if (address != null) isLocationCaptured = true;

    notifyListeners();
  }

  bool shouldPickAssembly = false;
  String? selectedAssemblyName;
  List<Assembly>? assemblyList;
  List<DropdownItem>? assemblyDropDownList;

  getAssemblyList() async {
    /// district null all assembly in states will return
    assemblyList = await DbServices.db
        .getAssembly(null, stateCode: AppConstants.campaignState);

    if (assemblyList != null && assemblyList!.isNotEmpty)
      assemblyDropDownList = List.generate(
          assemblyList!.length,
          (index) => DropdownItem(
              assemblyList![index].name, assemblyList![index].assemblyCode));
    //notifyListeners();
    return true;
  }

  changeAssembly(val) {
    selectedAssemblyId = val;
    if (val != null)
      selectedAssemblyName = assemblyList
          ?.firstWhere((element) => element.assemblyCode == val)
          .name;
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
                value: context.read<AddCampaignVM>(),
                child: Consumer<AddCampaignVM>(
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
    if (!isShimlaCampaign) {
      final result = await checkAssembly(context);
      if (result == null || result == false) return;
    }

    if (!await verifyOtpForMember(context)) {
      return;
    }

    showNetworkLoadingDialog(context);

    Map<String, String> data = {
      "NAME": "${nameController.text}",
      "MOBILE": "${mobileController.text}",
      "AGE": "${selectedAge}",
      "GENDER": "$selectedGender",
      "RELATIVE_NAME": "${relativeNameController.text}",
      "INCLINATION": this.isShimlaCampaign
          ? "$selectedInclination"
          : "${selectedInclinations.reduce((value, element) => "$value,$element")}",
      "CAMPAIGN_ID": "${campaignId}",
      "CAMPAIGN_CODE": "${otpCodeController.text}",
      "RECEPTION": "$rating",
      "CITY": "${address?.locality ?? ""}",
      "STATE": "${address?.state ?? ""}",
      "ADDED_BY_ASSEMBLY": selectedAssemblyName ?? "",
      "WARD_NO": "${selectedWard ?? ""}",
      "LOCATION": "${address?.formattedAddress ?? ""}"
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
              create: (context) => AddCampaignVM(),
              child: AddCampaign(
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
}
