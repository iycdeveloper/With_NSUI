import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/events/event.dart';
import 'package:iyc/app/data/resources/repository/unit_management_repo.dart';

class EventsVM extends ChangeNotifier {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  bool showObAccess = false;

  EventController eventController = EventController();
  bool isLoading = false;
  List<Event> eventList = [];

  changeSelectedDay(BuildContext context, DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
    getEventsList(context, true, selected);
  }

  checkObAccess(BuildContext context) async {
    ApiResponse apiResponse = await UnitManagementRepo().checkOBAccess();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
      jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        showObAccess = true;
      } else {
        showObAccess = false;
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
      notifyListeners();
    }
  }

  Future getEventsList(BuildContext context, [bool refresh = false, DateTime? dateTIme]) async {
    eventList = [];
    isLoading = true;
    if (refresh) notifyListeners();
    ApiResponse apiResponse =
        await UnitManagementRepo().getDailyEvent(dateTIme ?? DateTime.now());
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      var responseDecoded =
          jsonDecode(utf8.decode(base64.decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        eventList = List<Event>.from(
            responseDecoded["response"].map((x) => Event.fromJson(x)));

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseDecoded['response'])));
      }
    }
  }

  void changeFocusedDay(BuildContext context, DateTime focused) {
    focusedDay = focused;
    notifyListeners();
  }
}
