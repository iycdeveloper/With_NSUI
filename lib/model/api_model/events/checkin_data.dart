class CheckInData {
  CheckInData(
      {required this.eventDescription,
      required this.eventLocation,
      required this.dateTime});

  String eventDescription;
  String eventLocation;
  String dateTime;

  factory CheckInData.fromJson(Map<String, dynamic> json) => CheckInData(
      eventDescription: json["description"],
      eventLocation: json["address"],
      dateTime: json["date"]);
}
