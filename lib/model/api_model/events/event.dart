import 'package:iyc/model/data_model/address.dart';

class Event {
  Event(
      {
        required this.eventName,
      this.eventId,
      required this.eventDescription,
      required this.eventDateTime,
      required this.eventLocation,
      required this.eventType,
      required this.eventLevel,
      this.inviteAll,
      this.rsvp,
      this.inviteesList,
      this.address,
      this.lat,
      this.long,
      this.createrFirstName,
      this.createrLastName,
      this.createrMobile,
      this.createrPost});

  String eventName;
  String eventDescription;
  String eventDateTime;
  String eventLocation;
  String? inviteesList;
  Address? address;
  String? lat;
  String? long;
  String? createrFirstName;
  String? createrLastName;
  String? createrMobile;
  String? createrPost;
  String? rsvp;
  String? eventId;
  String? eventType;
  String? eventLevel;
  String? inviteAll;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      eventName: json["EVENT_NAME"],
      eventId: json["EVENT_ID"],
      eventType: json['EVENT_TYPE'],
      eventLevel: json['EVENT_LEVEL'],
      eventDescription: json["EVENT_DESCRIPTION"],
      eventDateTime: json["EVENT_DATE_TIME"],
      eventLocation: json["EVENT_LOCATION"],
      lat: json["LATITUDE"],
      long: json["LONGITUDE"],
      createrFirstName: json["CREATOR_NAME"],
      createrLastName: json["CREATOR_LAST_NAME"],
      createrMobile: json["CREATOR_MOBILE"],
      createrPost: json["CREATOR_POST"],
      rsvp: json["RSVP"]);

  Map<String, dynamic> toJson() => {
        "EVENT_NAME": eventName,
        "EVENT_DESCRIPTION": eventDescription,
        "EVENT_DATE_TIME": eventDateTime,
        "EVENT_LOCATION": eventLocation,
        "EVENT_INVITEES": inviteesList
      };
}
