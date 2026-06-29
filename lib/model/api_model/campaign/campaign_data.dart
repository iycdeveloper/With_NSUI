class CampaignData {
  CampaignData(
      {required this.name,
      required this.mobile,
      required this.epicId,
      required this.status});

  String name;

  String mobile;

  String epicId;
  String status;

  factory CampaignData.fromJson(Map<String, dynamic> json) => CampaignData(
      name: json["name"],
      mobile: json["mobile"],
      epicId: json["epic"],
      status: json["verification_status"]);
}

//[{"name":"Tesr","mobile":"9740691161","age":"97","gender":"O","inclination":"BJP","campaign_code":"5644","epic":"Etw5e7r6y7","location":"Building No. 38\/5 Berlie Street
// I/flutter (28861): , Hosur Rd, near Baldwin Polytechnic College, Langford Town, Shanti Nagar, Bengaluru, Karnataka 560025, India","created_on":"2023-02-01 12:59:16","verification_status":"UNVERIFIED","reception":"5"},
