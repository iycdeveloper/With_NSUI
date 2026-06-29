import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/yuva_user/yuva_user.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/app/data/resources/repository/yuva_booth_repo.dart';
import 'package:iyc/app/data/resources/services/db_services.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/screens/widgets/overlay/overlay_entry.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../di_container.dart';

class AddYuvaDataMeetingVM extends ChangeNotifier {
  GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController feedBackController = TextEditingController();
  TextEditingController idCardNumberController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  final FocusNode mobileFocus = FocusNode();
  final FocusNode wardFocus = FocusNode();

  bool loadingPage = false;
  late YuvaUser currentYuvaUser;
  late List<YuvaUser> yuvaUsersList;
  String? selectedBooth;
  List<DropdownItem> boothList = [];
  List<Assembly>? assemblyList;
  Assembly? selectedAssembly;
  String? selectedAssemblyName;

  String? selectedReception;
  String? selectedFrontal;
  String? selectedReportType;

  DateTime eventDate = DateTime.now();
  String? selectedDate;

  List<DropdownItem> receptionList = [
    DropdownItem("POSITIVE", "POSITIVE"),
    DropdownItem("NEGATIVE", "NEGATIVE"),
    DropdownItem("NEUTRAL", "NEUTRAL"),
  ];
  List<DropdownItem> frontalList = [
    DropdownItem("Youth Congress", "Youth Congress"),
    DropdownItem("Mahila Congress", "Mahila Congress"),
    DropdownItem("Sevadal", "Sevadal"),
    DropdownItem("District Congress Committee", "District Congress Committee"),
    DropdownItem("Block Congress Committee", "Block Congress Committee"),
    DropdownItem("Pradesh Congress Committee", "Pradesh Congress Committee"),
  ];

  List<DropdownItem> reportTypeList = [
    DropdownItem("Elected Representatives of Local Bodies",
        "Elected Representatives of Local Bodies"),
    DropdownItem("Party Office Bearers", "Party Office Bearers"),
  ];
  changeSelectedReception(value) {
    selectedReception = value;
    notifyListeners();
  }

  changeSelectedFrontal(value) {
    selectedFrontal = value;
    notifyListeners();
  }

  changeSelectedReportType(value) {
    selectedReportType = value;
    notifyListeners();
  }

  changeSelectedBooth(values) {
    selectedBooth = values;
    print(selectedBooth);
    notifyListeners();
  }
  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
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
        .getAssembly(null, stateCode: currentYuvaUser.stateCode);
    if (currentYuvaUser.roleId == "3") {
      /// picking only assembly list available in yuva users list
      assemblyList = assemblyList!
          .where((element) => yuvaUsersList
              .map((e) => e.assemblyCode)
              .toList()
              .contains(element.assemblyCode))
          .toList();
    }

    //notifyListeners();
    return true;
  }

  bool validateForm(BuildContext context) {
    bool validatedSuccess = true;

    if (nameController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill Name", context);
      validatedSuccess = false;
    }
    if (designationController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill designation", context);
      validatedSuccess = false;
    }
    if (mobileController.text.trim().isEmpty) {
      showCustomSnackBar("Kindly fill mobile number", context);
      validatedSuccess = false;
    }

    if (int.parse(currentYuvaUser.roleId) == "3" && selectedAssembly == null) {
      showCustomSnackBar("Kindly Select Assembly", context);
      validatedSuccess = false;
    }
    if (selectedReportType == null) {
      showCustomSnackBar("Kindly Select report Type", context);
      validatedSuccess = false;
    } else {
      if (selectedReportType == "Party Office Bearers" &&
          selectedFrontal == null) {
        showCustomSnackBar("Kindly Select Frontal Type", context);
        validatedSuccess = false;
      }
    }
    if (selectedReception == null) {
      showCustomSnackBar("Kindly Select Reception Type", context);
      validatedSuccess = false;
    }
    if (selectedDate == null) {
      showCustomSnackBar("Select a date of birth", context);
      validatedSuccess = false;
    }

    return validatedSuccess;
  }

  Future<void> submit(BuildContext context) async {
    if (!validateForm(context)) {
      return;
    }
    showNetworkLoadingDialog(context);
    ApiResponse apiResponse = await sl<YuvaBoothRepo>().addYuvaDataMeeting({
      "NAME": "${nameController.text}",
      "MOBILE": "${mobileController.text}",
      "DESIGNATION": "${designationController.text}",
      "WARD": "${wardController.text}",
      "BOOTH": "$selectedBooth",
      "RECEPTION": "$selectedReception",
      "FEEDBACK": "${feedBackController.text}",
      "FRONTAL": "$selectedFrontal",
      "REPORT_TYPE": "$selectedReportType",
      "ASSEMBLY_CODE":
          "${selectedAssembly?.assemblyCode ?? currentYuvaUser.assemblyCode}",
      "STATE_CODE":
          "${selectedAssembly?.stateCode ?? currentYuvaUser.stateCode}",
      "YUVA_USER_ID": "${currentYuvaUser.yuvaUserId}",
      "DATE_OF_BIRTH":"${ DateFormat("dd-MM-yyyy").format(eventDate)}"
    });
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
        Navigator.of(context).pop(); // page close

        notifyListeners();
      } else {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  initAddYuvaUser(BuildContext context, YuvaUser yuvaUser,
      List<YuvaUser> yuvaUserList) async {
    mobileFocus.addListener(() {
      bool hasFocus = mobileFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    wardFocus.addListener(() {
      bool hasFocus = wardFocus.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
    loadingPage = true;
    currentYuvaUser = yuvaUser;
    yuvaUsersList = yuvaUserList;
    await getAssemblyList();
    await Future.delayed(Duration.zero);
    boothList = await generateBoothList();
    loadingPage = false;
    notifyListeners();
  }

  Future<List<DropdownItem>> generateBoothList() async {
    final list = List.generate(
        250, (index) => DropdownItem(index.toString(), index.toString()));
    return list;
  }
}
