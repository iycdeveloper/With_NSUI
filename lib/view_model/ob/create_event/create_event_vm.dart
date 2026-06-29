import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/events/event.dart';
import 'package:iyc/model/api_model/events/ob_user.dart';
import 'package:iyc/model/data_model/address.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';
import 'package:iyc/screens/ui/home/ob/create_event/choose_invites.dart';
import 'package:iyc/screens/ui/location/select_location_screen.dart';
import 'package:iyc/screens/widgets/custom_snack_bar.dart';
import 'package:iyc/screens/widgets/network_loading_dialog_box.dart';
import 'package:iyc/utils/utils.dart';
import 'package:iyc/view_model/location/select_location_vm.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'choose_invites_vm.dart';

class CreateEventVM extends ChangeNotifier {
  TextEditingController detailsController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool selectAllUser = false;

  onChangedSelectAllUser(bool value){
    selectAllUser = value;
    if(value){
      selectedEvent = 'Y';
    }else{
      selectedEvent = 'N';
    }
    notifyListeners();
  }

  List<ObUser> selectedObUserList = [];

  bool isLoading = false;
  bool showAddress = false;

  Address? resultAdress;

  DateTime eventDate = DateTime.now();
  TimeOfDay eventTime = TimeOfDay.now();
  String? selectedDate;
  String? selectedTime;
  String? selectedEventType;
  List<DropdownItem> eventTypeList = [
    DropdownItem("Campaign", "Campaign"),
    DropdownItem("Prachar", "Prachar"),
    DropdownItem("Protest", "Protest"),
    DropdownItem("Pradarshan", "Pradarshan"),
    DropdownItem("Rally", "Rally"),
    DropdownItem("Meeting", "Meeting"),
    DropdownItem("Training", "Training")
  ];

  String? selectedEventLevel;
  List<DropdownItem> eventLevelList = [
    DropdownItem("Assembly", "Assembly"),
    DropdownItem("District", "District"),
    DropdownItem("State", "State"),
    DropdownItem("National", "National"),
  ];

  String selectedEvent = 'N';
  // List<DropdownItem> eventList = [
  //   DropdownItem("Yes", "Y"),
  //   DropdownItem("No", "N"),
  // ];

  void onChangeEventType(String value){
    selectedEventType = value;
    notifyListeners();
  }

  void onChangeEventLevel(String value){
    selectedEventLevel = value;
    notifyListeners();
  }
  // void onChangeEventInvite(String value){
  //   selectedEvent = value;
  //   notifyListeners();
  // }

  changeDate(DateTime timeData) {
    selectedDate = "${timeData.day}-${timeData.month}-${timeData.year}";
    eventDate = timeData;
    notifyListeners();
  }

  changeTime(TimeOfDay timeData) {
    selectedTime =
        "${timeData.hour}:${timeData.minute.toString().length > 1 ? timeData.minute : "0" + "${timeData.minute}"}";
    print(selectedTime);
    eventTime = timeData;
    notifyListeners();
  }

  onTapChooseInvite(BuildContext context) async {
    final List<ObUser>? _selectedList = await toPage(
        context,
        ChangeNotifierProvider(
          create: (context) => ChooseInvitesVM(),
          child: ChooseInvites(),
        ));
    if (_selectedList != null && _selectedList.isNotEmpty) {
      selectedObUserList = _selectedList;
      notifyListeners();
    }
    print(selectedObUserList.length);
  }

  onTapAddress(BuildContext context) async {
    resultAdress = await toPage(
        context,
        ChangeNotifierProvider(
          create: (context) => SelectLocationVM(),
          child: SelectLocationScreen(),
        ));
    print(resultAdress?.formattedAddress);

    addressController.text = resultAdress?.formattedAddress ?? "";
    if (resultAdress != null) {
      showAddress = true;
    }
    notifyListeners();
  }

  createEvent(BuildContext context) async {
    // if (!validatePage(context)) return;
    //
    // showNetworkLoadingDialog(context);
    // Event event = Event(
    //     eventType: selectedEventType,
    //     eventLevel: selectedEventLevel,
    //     inviteAll: selectedEvent,
    //     eventName: titleController.text,
    //     eventDescription: detailsController.text,
    //     address: resultAdress,
    //     eventDateTime:
    //         "${DateFormat("dd-MM-yyyy").format(eventDate)} ${selectedTime}",
    //     eventLocation: addressController.text,
    //     inviteesList: selectedObUserList.map((e) => e.id).toList().join(","));
    // ApiResponse apiResponse = await UnitManagementRepo().createEvent(event);
    // if (apiResponse.response != null &&
    //     apiResponse.response!.statusCode == 200) {
    //   final responseDecoded =
    //       jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
    //   print(responseDecoded);
    //   if (responseDecoded['status'] == "SUCCESS") {
    //     Navigator.of(context).pop(); // loading
    //     await Alert(
    //       context: context,
    //       type: AlertType.success,
    //       title: "Success",
    //       desc: responseDecoded['response'],
    //       buttons: [
    //         DialogButton(
    //           child: Text(
    //             "OKAY",
    //             style: TextStyle(color: Colors.white, fontSize: 20),
    //           ),
    //           onPressed: () async {
    //             Navigator.pop(context);
    //           },
    //           width: 120,
    //         )
    //       ],
    //     ).show();
    //     Navigator.of(context).pop(true); //page close
    //   } else {
    //     Navigator.of(context).pop(); // loading
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
    //     return false;
    //   }
    // }
  }

  bool validatePage(BuildContext context) {
    detailsController.text.isEmpty
        ? showCustomSnackBar("Enter Meeting details", context)
        : titleController.text.isEmpty
            ? showCustomSnackBar("Enter Meeting Name", context)
            : selectedDate == null
                ? showCustomSnackBar("Enter Meeting Date", context)
                : selectedTime == null
                    ? showCustomSnackBar("Enter Meeting Time", context)
                    : addressController.text.isEmpty
                        ? showCustomSnackBar("Enter Meeting Address", context)
                        : (selectedObUserList.isEmpty && selectedEvent == "N")
                            ? showCustomSnackBar(
                                "Invite Meeting Users", context)
                            : null;

    return detailsController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null &&
        addressController.text.isNotEmpty &&
        (selectedEvent == "Y"?true:selectedObUserList.isNotEmpty);
  }
}
