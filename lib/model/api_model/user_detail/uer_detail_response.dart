// To parse this JSON data, do
//
//     final userDetailsResponse = userDetailsResponseFromJson(jsonString);

import 'dart:convert';

UserDetailsResponse userDetailsResponseFromJson(String str) =>
    UserDetailsResponse.fromJson(json.decode(str));

class UserDetailsResponse {
  UserDetailsResponse({
    required this.status,
    this.response,
  });

  String status;
  List<UserDetail>? response;

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) =>
      UserDetailsResponse(
        status: json["status"],
        response: List<UserDetail>.from(
            json["response"].map((x) => UserDetail.fromJson(x))),
      );
}

class UserDetail {
  UserDetail(
      {required this.name,
      required this.mobile,
      required this.dateOfBirth,
      required this.gender,
      required this.status,
      required this.stateCode,
      required this.districtCode,
      required this.assemblyCode,
      required this.blockCode,
      required this.wardCode,
      this.stateName,
      this.assemblyName,
      this.districtName,
      this.profilePic,
      this.workingState,
      this.roleName,
      this.designation,
      this.address,
      this.category,
      this.subCategory,
      this.pincode});

  String name;
  String mobile;
  String dateOfBirth;
  String gender;
  String status;
  String stateCode;
  String districtCode;
  String assemblyCode;
  String blockCode;
  String wardCode;
  String? stateName;
  String? assemblyName;
  String? districtName;
  String? profilePic;
  String? workingState;
  String? roleName;
  String? designation;
  String? address;
  String? pincode;
  String? category;
  String? subCategory;

  // {"status":"SUCCESS","response":[{"name":"Spurthi","mobile":"9916557335","date_of_birth":"16-1-1987","gender":"M","status":"ACTIVE","state_code":"CG","district_code":"12","assembly_code":"24","block_co
  // I/flutter (11681): de":"","ward_code":"","points":"71","profile_pic":"https:\/\/memberdoc.ycea.in\/PROFILE\/9916557335_P.jpg"}]}
  // I/flutter (11681):
  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
      name: json["name"],
      mobile: json["mobile"],
      dateOfBirth: json["date_of_birth"],
      gender: json["gender"],
      status: json["status"],
      stateCode: json["state_code"] ?? json["state"],
      districtCode: json["district_code"],
      assemblyCode: json["assembly_code"],
      blockCode: json["block_code"],
      wardCode: json["ward_code"],
      profilePic: json["profile_pic"],
      workingState: json["work_state"],
      roleName: json["role_name"]??'',
      designation: json["designation"],
      address: json["address"] ?? "",
      pincode: json["pincode"] ?? "",
      category: json["caste"] ?? "",
      subCategory: json["subcaste"] ?? "");

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "status": status,
        "state_code": stateCode,
        "district_code": districtCode,
        "assembly_code": assemblyCode,
        "block_code": blockCode,
        "ward_code": wardCode,
      };

  UserDetail copyWith({
    String? name,
    String? mobile,
    String? dateOfBirth,
    String? gender,
    String? status,
    String? stateCode,
    String? districtCode,
    String? assemblyCode,
    String? blockCode,
    String? wardCode,
  }) =>
      UserDetail(
          name: name ?? this.name,
          mobile: mobile ?? this.mobile,
          dateOfBirth: dateOfBirth ?? this.dateOfBirth,
          gender: gender ?? this.gender,
          status: status ?? this.status,
          stateCode: stateCode ?? this.stateCode,
          districtCode: districtCode ?? this.districtCode,
          assemblyCode: assemblyCode ?? this.assemblyCode,
          blockCode: blockCode ?? this.blockCode,
          wardCode: wardCode ?? this.wardCode,
          stateName: stateName ?? this.stateName,
          districtName: districtName ?? this.districtName,
          assemblyName: assemblyName ?? this.assemblyName);
}

class OBaccessDetails {
  String? ballot;
  String? postalloted;
  String? state;
  String? district;
  String? assembly;
  String? mandalam;

  OBaccessDetails({
    required this.ballot,
    required this.postalloted,
    required this.state,
    required this.district,
    required this.assembly,
    required this.mandalam,
  });
  factory OBaccessDetails.fromJson(Map<String, dynamic> json) =>
      OBaccessDetails(
        ballot: json["ballot"] ?? '',
        postalloted: json["post_alloted"] ?? '',
        state: json["state"] ?? '',
        district: json["district"] ?? '',
        assembly: json["assembly"] ?? '',
        mandalam: json["mandalam"] ?? '',
      );
}

class NOBaccessDetails {
  String? contestingfor;
  String? postalloted;
  String? territory;

  NOBaccessDetails({
    required this.contestingfor,
    required this.postalloted,
    required this.territory,
  });
  factory NOBaccessDetails.fromJson(Map<String, dynamic> json) =>
      NOBaccessDetails(
        contestingfor: json["contesting_for"] ?? '',
        postalloted: json["post_alloted"] ?? '',
        territory: json["territory"] ?? '',
      );
}
