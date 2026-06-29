class VerifyEventData {
  VerifyEventData(
      {this.eventId,
      this.eventName,
      this.eventDescription,
      this.eventDateTime,
      this.eventLocation,
      this.eventType,
      this.eventLevel,
      this.organiserName,
      this.organiserMobile,
      this.eventPic1,
      this.eventPic2,
      this.eventPic3,
      this.eventPic4,
      this.eventPic5});

  String? eventId;
  String? eventName;
  String? eventDescription;
  String? eventDateTime;
  String? eventLocation;
  String? eventType;
  String? eventLevel;
  String? organiserName;
  String? organiserMobile;
  String? eventPic1;
  String? eventPic2;
  String? eventPic3;
  String? eventPic4;
  String? eventPic5;

  factory VerifyEventData.fromJson(Map<String?, dynamic> json) => VerifyEventData(
      eventId: json["EVENT_ID"],
      eventName: json["EVENT_NAME"],
      eventDescription: json["EVENT_DESCRIPTION"],
      eventDateTime: json["EVENT_DATE_TIME"],
      eventType: json['EVENT_TYPE'],
      eventLevel: json['EVENT_LEVEL'],
      eventLocation: json["EVENT_LOCATION"],
      organiserName: json["EVENT_ORGANISER_NAME"],
      organiserMobile: json["EVENT_ORAGANISER_MOBILE"],
      eventPic1: json["EVENT_PIC_1"],
      eventPic2: json["EVENT_PIC_2"],
      eventPic3: json["EVENT_PIC_3"],
      eventPic4: json["EVENT_PIC_4"],
      eventPic5: json["EVENT_PIC_5"]);
}

// "EVENT_NAME":"Test 1",
// "EVENT_DESCRIPTION":"State Office Bearers Meeting",
// "EVENT_DATE_TIME":"23-10-2022 10:00:00",
// "EVENT_TYPE":"CAMPAIGN",
// "EVENT_LEVEL":"DISTRICT",
// "EVENT_LOCATION":"1124, Jalahalli",
// "EVENT_ORGANISER_NAME":"SPURTHI",
// "EVENT_ORGANISER_MOBILE":"9916557335",
// "EVENT_PIC_1":"https://memberdoc.ycea.in/TASKS/513_9916557335_1.jpg",
// "EVENT_PIC_2":"https://memberdoc.ycea.in/TASKS/513_9916557335_1.jpg",
// "EVENT_PIC_3":"https://memberdoc.ycea.in/TASKS/513_9916557335_1.jpg",
// "EVENT_PIC_4":"https://memberdoc.ycea.in/TASKS/513_9916557335_1.jpg",
// "EVENT_PIC_5":"https://memberdoc.ycea.in/TASKS/513_9916557335_1.jpg"
// }
