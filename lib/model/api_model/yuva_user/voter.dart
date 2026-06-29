class Voter {
  String voterId;
  String name;
  String fatherOrHusbandName;
  String? houseNo;
  String? age;
  String gender;
  String? status;
  String? town;
  String? wardNo;
  String? policeStation;
  String? tehsil;
  String? district;
  String? pinCode;
  String? pollingStation;
  String? pollingStationAddress;
  String? partNO;
  String? assembly;
  String? parliament;
  String? selectedFamilyVoterOption;

  Voter(
      {required this.voterId,
      required this.name,
      required this.district,
      this.status,
      this.age,
      this.assembly,
      required this.fatherOrHusbandName,
      required this.gender,
      this.houseNo,
      this.parliament,
      this.partNO,
      this.pinCode,
      this.policeStation,
      this.pollingStation,
      this.pollingStationAddress,
      this.tehsil,
      this.town,
      this.wardNo,
      this.selectedFamilyVoterOption});

  factory Voter.fromJson(Map<String, dynamic> json) => Voter(
      name: json["NAME"],//
      district: json["DISTRICT"],
      fatherOrHusbandName: json["FATHER_HUSBAND_NAME"] ?? "",
      voterId: json["VOTER_ID"],//
      status: json["STATUS"],
      age: json["AGE"],
      assembly: json["ASSEMBLY"],
      gender: json["GENDER"] == "M"
          ? "M"
          : json["GENDER"] == "Male"
              ? "M"
              : json["GENDER"] == "\u092a\u0941\u0930\u0941\u0937"
                  ? "M"
                  : "F",
      houseNo: json["HOUSE_NO"],
      parliament: json["PARLIAMENT"],
      partNO: json["PART_NO"],
      pinCode: json["PINCODE"],
      policeStation: json["POLICE_STATION"],
      pollingStation: json["POLLING_STATION"],
      pollingStationAddress: json["POLLING_STATION_ADDRESS"],
      tehsil: json[" TEHSIL"],
      town: json["TOWN"],
      wardNo: json["WARD_NO"]);
}

List<Voter> votersListFromJson(List<dynamic> str) =>
    List<Voter>.from(str.map((x) => Voter.fromJson(x)));

// {voter_id: CKB0820290, name: L BHARTI, father_husband_name: L N SWAMY,
// hou se_no: 9, age: 54.0, gender:Male, status: Y, town: Delhi, ward_no: , police_station: TILAK MARG,
// tehsil: CONNAUGHT PLACE, district: NEW DELHI, pincode: 110001,
// polling_station: 54-JASWANT SINGH ROAD, polling_station_address:  LADY IRWIN SR SEC SCHOOL SHRIMANT MADHAV RAO SCINDIA MARG,
// part_no: 54, assembly: 40 - NEW DELHI (GEN), parliament: 4- NEW DELHI}
