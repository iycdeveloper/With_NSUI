// To parse this JSON data, do
//
//     final yuvaUser = yuvaUserFromJson(jsonString);

import 'dart:convert';

import 'dart:core';

YuvaUser yuvaUserFromJson(Map<String, dynamic> str) => YuvaUser.fromJson(str);

List<YuvaUser> yuvaUsersListFromJson(List<dynamic> str) =>
    List<YuvaUser>.from(str.map((x) => YuvaUser.fromJson(x)));

class YuvaUser {
  YuvaUser(
      {required this.firstName,
      required this.lastName,
      required this.mobile,
      required this.email,
      required this.boothsAssigned,
      required this.stateCode,
      required this.assemblyCode,
      required this.zoneCode,
      required this.sectorCode,
      required this.boothCode,
      required this.verificationStatus,
      required this.volunteerStatus,
      required this.digitalYouth,
      required this.roleName,
      required this.roleId,
      required this.roleShortName,
      required this.yuvaUserId,
      required this.assembliesAssigned,
      this.name,
      this.districtsAssigned});

  String? firstName;
  String? lastName;
  String mobile;
  String? email;
  String? boothsAssigned;
  String assembliesAssigned;
  String stateCode;
  String? assemblyCode;
  String? zoneCode;
  String? sectorCode;
  String? boothCode;
  String? verificationStatus;
  String? volunteerStatus;
  String? digitalYouth;
  String roleName;
  String roleId;
  String? roleShortName;
  String yuvaUserId;
  String? name;
  String? districtsAssigned;

  factory YuvaUser.fromJson(Map<String, dynamic> json) => YuvaUser(
      firstName: json["FIRST_NAME"],
      lastName: json["LAST_NAME"],
      name: json["NAME"],
      mobile: json["MOBILE"],
      email: json["EMAIL"],
      boothsAssigned: json["BOOTHS_ASSIGNED"],
      stateCode: json["STATE_CODE"],
      assemblyCode: json["ASSEMBLY_CODE"],
      zoneCode: json["ZONE_CODE"],
      sectorCode: json["SECTOR_CODE"],
      boothCode: json["BOOTH_CODE"],
      verificationStatus: json["VERIFICATION_STATUS"],
      volunteerStatus: json["VOLUNTEER_STATUS"],
      digitalYouth: json["DIGITAL_YOUTH"],
      roleName: json["ROLE_NAME"],
      roleId: json["ROLE_ID"],
      roleShortName: json["ROLE_SHORT_NAME"],
      yuvaUserId: json["YUVA_USER_ID"],
      assembliesAssigned: json["ASSEMBLY_ASSIGNED"],
      districtsAssigned: json["DISTRICT_ASSIGNED"]);

  Map<String, dynamic> toJson() => {
        "FIRST_NAME": firstName,
        "LAST_NAME": lastName,
        "MOBILE": mobile,
        "EMAIL": email,
        "BOOTHS_ASSIGNED": boothsAssigned,
        "STATE_CODE": stateCode,
        "ASSEMBLY_CODE": assemblyCode,
        "ZONE_CODE": zoneCode,
        "SECTOR_CODE": sectorCode,
        "BOOTH_CODE": boothCode,
        "VERIFICATION_STATUS": verificationStatus,
        "VOLUNTEER_STATUS": volunteerStatus,
        "DIGITAL_YOUTH": digitalYouth,
        "ROLE_NAME": roleName,
        "ROLE_ID": roleId,
        "ROLE_SHORT_NAME": roleShortName,
      };
}
