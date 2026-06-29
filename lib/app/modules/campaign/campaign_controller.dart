import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/data/resources/repository/campaign_repo.dart';
import 'package:iyc/app/data/resources/services/image_services.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_ml_button.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/helper/upload_document.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../nyay_guarantee/local_widget/form_success_bootom_sheet.dart';

class CampaignController extends GetxController {
  String campaignId = Get.arguments;

  // @override
  // void onInit() async {
  //   super.onInit();
  //   userDetail = Get.find<ProfileController>().userDetail;
  //   await getLocation(isRefresh: true);
  //   update();
  // }

  Map<String, List<DropdownItem>> language = {
    '8': [DropdownItem("Hindi", "hi"),],
    '11': [DropdownItem("Hindi", "hi"),],
    '12': [DropdownItem("English", "en"), DropdownItem("Hindi", "hi"), DropdownItem("Telegu", "tl"),],
    '18': [DropdownItem("Hindi", "hi"),],
  };

  Map<String, Map<String, String>> appBarTitle = {
    '13':{'hi':'चंडीगढ़ डोर टू डोर'},
    '12':{'hi':'न्याय गारंटी', 'en':'Nyay Guarantee', 'tl':'న్యాయ్ గ్యారెంటీ'},
    '11':{'hi':'हिमाचल कांग्रेस संकल्प'},
    '8': {'hi':'हरियाणा कांग्रेस संकल्प'}
  };
  Map<dynamic, dynamic> bodyTitle = {
    'en': {
      'llb_leader_mobile': 'Leader Mobile number',
      'llb_submit': 'SUBMIT'
    },
    'hi': {
      'llb_leader_mobile': 'नेता का मोबाइल नंबर',
      'llb_submit': 'SUBMIT'
    },
    'tl': {
      'llb_leader_mobile': 'లీడర్ నంబర్',
      'llb_submit': 'సబ్మిట్ చేయండి'
    }
  };
  Map<String, dynamic> options = {
    '8': {
      'hi': []
    },
    '11': {
      'hi': []
    },
    '12': {
      'hi': [
        DropdownItem("ज़रूरतमंद महिलाओं को सालाना ₹ 1 लाख",
            "Needy women to receive an annual assistance of ₹ 1 Lakh "),
        DropdownItem(
            "केंद्र सरकार में नई भर्तियों में 50% महिला आरक्षण। आशा, आँगनबाड़ी, मिड-डे-मिल वर्कर का मानदेय दुगुना",
            "50% women’s Reservations in all new central government recruitments and doubling of honorarium for ASHA, aanganawaadi, and Mid-day Meal workers"),
        DropdownItem("पेपर लीक से मुक्ति (20 हज़ार मुआवजा/ उम्र-सीमा में छूट)/अग्निवीर योजना बंद-नियमित फौजी भर्ती चालू",
            "No Paper Leak ( ₹ 20,000 Compensation and age relaxations)/Abolish Agniveer- Start proper army recruitment"),
        DropdownItem("30 लाख सरकारी नौकरियों में भर्ती, वार्षिक ₹ 1 लाख का भत्ता",
            "Recruitment of 30 Lakhs Government Jobs and annual ₹ 1 Lakh annual allowance"),
        DropdownItem("MSP की लीगल गारंटी का क़ानून", "Legal Guarantee of MSP"),
        DropdownItem("किसान क़र्ज़ा माफ़ी आयोग के गठन से ऋण माफ़ी",
            "Loan waiver through formation of farmer debt relief commission "),
        DropdownItem(
            "मुफ़्त जाँच, दवा एवं इलाज और असंगठित श्रमिकों के लिए जीवन/ दुर्घटना बीमा",
            "Free check-ups, medicine, treatment, and life/accident insurance for unorganized laborers"),
        DropdownItem(
            "₹ 400/ प्रतिदीन राष्ट्रीय न्यूनतम मज़दूरी एवं शहरी क्षेत्रों के लिए रोज़गार गारंटी अधिनियम",
            "₹400/day National Minimum Wage and Employment Guarantee Act for urban areas."),
        DropdownItem("व्यापक सामाजिक/ आर्थिक/ जाति जनगणना",
            "Extensive social/economic/caste census"),
        DropdownItem("SC/ST/OBC आरक्षण पर 50% आरक्षण सीमा हटेगी",
            "Removal of 50% reservation cap on SC/ST/OBC reservations."),
      ],
      'en': [
        DropdownItem("Needy women to receive an annual assistance of ₹ 1 Lakh",
            "Needy women to receive an annual assistance of ₹ 1 Lakh"),
        DropdownItem(
            "50% women’s Reservations in all new central government recruitments and doubling of honorarium for ASHA, aanganawaadi, and Mid-day Meal workers",
            "50% women’s Reservations in all new central government recruitments and doubling of honorarium for ASHA, aanganawaadi, and Mid-day Meal workers"),
        DropdownItem("No Paper Leak ( ₹ 20,000 Compensation and age relaxations)/Abolish Agniveer- Start proper army recruitment",
            "No Paper Leak ( ₹ 20,000 Compensation and age relaxations)/Abolish Agniveer- Start proper army recruitment)"),
        DropdownItem(
            "Recruitment of 30 Lakhs Government Jobs and annual ₹ 1 Lakh annual allowance",
            "Recruitment of 30 Lakhs Government Jobs and annual ₹ 1 Lakh annual allowance"),
        DropdownItem("Legal Guarantee of MSP", "Legal Guarantee of MSP"),
        DropdownItem(
            "Loan waiver through formation of farmer debt relief commission",
            "Loan waiver through formation of farmer debt relief commission"),
        DropdownItem(
            "Free check-ups, medicine, treatment, and life/accident insurance for unorganized laborers",
            "Free check-ups, medicine, treatment, and life/accident insurance for unorganized laborers"),
        DropdownItem(
            "₹400/day National Minimum Wage and Employment Guarantee Act for urban areas.",
            "₹400/day National Minimum Wage and Employment Guarantee Act for urban areas."),
        DropdownItem("Extensive social/economic/caste census",
            "Extensive social/economic/caste census"),
        DropdownItem("Removal of 50% reservation cap on SC/ST/OBC reservations.",
            "Removal of 50% reservation cap on SC/ST/OBC reservations."),
      ],
      'tl': [
        DropdownItem(
            "నిరుపేద మహిళలు ₹ 1 లక్ష వార్షిక సహాయాన్ని అందుకుంటారు",
            "Needy women to receive an annual assistance of ₹ 1 Lakh"),
        DropdownItem(
            "అన్ని కొత్త కేంద్ర ప్రభుత్వ రిక్రూట్‌మెంట్లలో 50% మహిళా రిజర్వేషన్లు మరియు ఆశా, అంగనవాడీ మరియు మధ్యాహ్న భోజన కార్మికులకు గౌరవ వేతనం రెట్టింపు",
            "50% women’s Reservations in all new central government recruitments and doubling of honorarium for ASHA, aanganawaadi, and Mid-day Meal workers"),
        DropdownItem("పేపర్ లీక్ లేదు ( ₹ 20,000 పరిహారం మరియు వయో సడలింపులు)/అగ్నివీర్‌ని రద్దు చేయండి- సరైన ఆర్మీ రిక్రూట్‌మెంట్‌ను ప్రారంభించండి.",
            "No Paper Leak ( ₹ 20,000 Compensation and age relaxations)/Abolish Agniveer- Start proper army recruitment."),
        DropdownItem(
            "30 లక్షల ప్రభుత్వ ఉద్యోగాల నియామకం మరియు వార్షిక ₹ 1 లక్ష వార్షిక భత్యం",
            "Recruitment of 30 Lakhs Government Jobs and annual ₹ 1 Lakh annual allowance"),
        DropdownItem("MSP క చటపరన", "Legal Guarantee of MSP"),
        DropdownItem(
            "రైతు రుణ ఉపశమన కమిషన్ ఏర్పాటు ద్వారా రుణమాఫీ",
            "Loan waiver through formation of farmer debt relief commission"),
        DropdownItem(
            "అసంఘటిత కార్మికులకు ఉచిత తనిఖీలు, ఔషధం, చికిత్స మరియు జీవిత/ప్రమాద బీమా",
            "Free check-ups, medicine, treatment, and life/accident insurance for unorganized laborers"),
        DropdownItem(
            "పట్టణ ప్రాంతాలకు రోజుకు ₹400 జాతీయ కనీస వేతనం మరియు ఉపాధి హామీ చట్టం.",
            "₹400/day National Minimum Wage and Employment Guarantee Act for urban areas."),
        DropdownItem("విస్తృతమైన సామాజిక/ఆర్థిక/కుల గణన",
            "Extensive social/economic/caste census"),
        DropdownItem("SC/ST/OBC రిజర్వేషన్లపై 50% రిజర్వేషన్ పరిమితిని తొలగించడం.",
            "Removal of 50% reservation cap on SC/ST/OBC reservations."),
      ],
    },
    '13': {
      'hi': [
        DropdownItem("अच्छी पढ़ाई के बाद चंडीगढ़ में नौकरी सुनिश्चित करने के लिए IT हब का विकास !",
            "अच्छी पढ़ाई के बाद चंडीगढ़ में नौकरी सुनिश्चित करने के लिए IT हब का विकास !"),
        DropdownItem(
            "किराना सामान व‌ अन्य चीजों की महंगाई",
            "किराना सामान व‌ अन्य चीजों की महंगाई"),
        DropdownItem("अच्छी पढ़ाई के बाद चंडीगढ़ में नौकरी सुनिश्चित करने के लिए IT हब का विकास !",
            "अच्छी पढ़ाई के बाद चंडीगढ़ में नौकरी सुनिश्चित करने के लिए IT हब का विकास !)"),
        DropdownItem(
            "पुलिस और सुरक्षा प्रबंधन में सख्ती !",
            "पुलिस और सुरक्षा प्रबंधन में सख्ती !"),
        DropdownItem(
            "भ्रष्टाचार को देंगे मात चंडीगढ़ के फैसलों में होगा नागरिक का हाथ !",
            "भ्रष्टाचार को देंगे मात चंडीगढ़ के फैसलों में होगा नागरिक का हाथ !"),
        DropdownItem(
            "मेयर चुनाव जैसी दुर्घटना को रोकना  (लोकतंत्र की रक्षा) ",
            "मेयर चुनाव जैसी दुर्घटना को रोकना  (लोकतंत्र की रक्षा) "),
        DropdownItem(
            "बुढ़ापा पेंशन में इजाफा (2000 रुपए/ महीना)",
            "बुढ़ापा पेंशन में इजाफा (2000 रुपए/ महीना)"),
        DropdownItem("30 लाख सरकारी नौकरियों में भर्ती और नौकरी मिलने तक सालाना 1 लाख की एप्रेंटिसशिप",
            "30 लाख सरकारी नौकरियों में भर्ती और नौकरी मिलने तक सालाना 1 लाख की एप्रेंटिसशिप"),
        DropdownItem("मुफ़्त जाँच, दवा एवं इलाज और असंगठित श्रमिकोंन के लिए जीवन/ दुर्घटना बीमा",
            "मुफ़्त जाँच, दवा एवं इलाज और असंगठित श्रमिकोंन के लिए जीवन/ दुर्घटना बीमा"),
      ],
    }
  };

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController leaderMobileController = TextEditingController();
  String? address;
  UserDetail? userDetail;
  bool isLocationCaptured = false;
  String? selectedLanguage = 'hi';

  List<int> selectedInclinationList = [];
  bool showProfileImage = false;
  File? pickedProfileFile;
  String? pickedProfileFilePath;
  Future<void> pickDocument(ImageSource imageSource, String? pickedFilePath,
      DocumentType documentType) async {
    final result = await ImageServices().pickImage(imageSource);
    if (result != null) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      ProgressDialogUtils.showProgressIndicator();
      File image;
      image = File(result.path);
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final String filePath = '$dirPath/${p.basename(result.path)}';
      final File newImage = await image.copy(filePath);
      File _image = newImage;
      // InputImage inputImage = InputImage.fromFilePath(filePath);
      // final FaceDetector _faceDetector = FaceDetector(
      //   options: FaceDetectorOptions(
      //     enableContours: true,
      //     enableLandmarks: true,
      //   ),
      // );
      // final faces = await _faceDetector.processImage(inputImage);
      // ProgressDialogUtils.closeDialog();
      // if(faces.length == 0){
      //   CustomSnackBar.showErrorSnackBar('Human face not detected');
      //   return;
      // }
      // if(faces.length >= 2){
      //   CustomSnackBar.showErrorSnackBar('More then 1 human face detected');
      //   return;
      // }
      switch (documentType) {
        case DocumentType.amImage:
          pickedProfileFile = _image;
          pickedProfileFilePath = pickedProfileFile!.path;
          showProfileImage = true;
          Log.printILog(pickedProfileFilePath);
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

  void onClickCheckedBox(int index) {
    if (selectedInclinationList.contains(index)) {
      selectedInclinationList.remove(index);
    } else {
      selectedInclinationList.add(index);
    }
    update();
  }

  void onChangedLanguage(String value) {
    selectedLanguage = value;
    update();
  }

  Future captureLocation(BuildContext context) async {
    ProgressDialogUtils.showProgressIndicator();
    double lat = sl<LocationProvider>().currentLocation!.latitude;
    double long = sl<LocationProvider>().currentLocation!.longitude;
    Dio dio = Dio();
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyBgDcHORuFktFOxxEVESf6S1WoQKBfIhWc";
    var  response = await dio.get(apiurl);
    if (response.statusCode == 200) {
      Map data = response.data;
      if (data["status"] == "OK") {
        if (data["results"].length > 0) {
          Map firstResult = data["results"][0];
          Log.printILog(firstResult);
          address = firstResult["formatted_address"];
          Log.printILog(address);
        }
      }}
    else{
      CustomSnackBar.showErrorSnackBar(response.toString());
      return false;
    }
    ProgressDialogUtils.closeDialog();
    return true;
  }

  void addCampaign(BuildContext context) async {
    if (!await captureLocation(context)) {
      CustomSnackBar.showErrorSnackBar("Location Not Enabled");
      return;
    }
    var count = 0;
    var SCHEME_OPTIONS = '';
    for(var i in options[campaignId]['en']) {
      SCHEME_OPTIONS +=
      '${i.value}-${selectedInclinationList.contains(count)}, ';
      count += 1;
    }
    Log.printDLog(SCHEME_OPTIONS);
    ProgressDialogUtils.showProgressIndicator();
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    var fileLink = '${userDetail!.mobile}_$timestamp.jpg';
    Map<String, String> data = {
      "SCHEME_OPTIONS": SCHEME_OPTIONS,
      "REFERRED_BY": "${leaderMobileController.text}",
      "CAMPAIGN_ID": "13",
      "LOCATION": "$address",
      "FILE_LINK": "$fileLink"
    };
    ApiResponse apiResponse = await CampaignRepo().addCampaignData(data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        await uploadDocument(
            pickedProfileFilePath,
            "${sl<SharedPreferences>().get("s3_bucket")}/NYAY",
            "$fileLink");
        ProgressDialogUtils.closeDialog();
        leaderMobileController.clear();
        selectedInclinationList = [];
        showProfileImage = false;
        pickedProfileFilePath = null;
        pickedProfileFile = null;
        update();
        campaignSuccessBottomSheet();
      } else {
        Navigator.of(context).pop();
        CustomSnackBar.showErrorSnackBar(responseDecoded['response']);
      }
    } else {
      Navigator.of(context).pop();
      CustomSnackBar.showErrorSnackBar(apiResponse.error);
    }
  }

  bool validateForm(BuildContext context) {
    bool validatedSuccess = true;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (pickedProfileFilePath == null) {
        CustomSnackBar.showErrorSnackBar(selectedLanguage == 'en'
            ? 'Upload Photo'
            : "Upload Photo");
        validatedSuccess = false;
      }
    } else {
      validatedSuccess = false;
    }

    return validatedSuccess;
  }

  Future<void> getLocation({bool isRefresh = false}) async {
    Log.printILog("Setting initial location");
    if (sl<LocationProvider>().currentLocation != null) {
      return;
    }
    try {
      sl<LocationProvider>().currentLocation ??
          await sl<LocationProvider>().setInitialLocationOnLogin(Get.context!);
    } on Exception catch (e) {
      // TODO
    }
    if (sl<LocationProvider>().currentLocation != null) {
      update();
    } else {

    }
  }

}
